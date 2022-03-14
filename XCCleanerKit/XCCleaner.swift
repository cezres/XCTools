//
//  XCCleaner.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/2/8.
//

import Foundation
import Combine

public class XCCleaner: ObservableObject {
    public let url: URL
    public let progress: Progress
    @Published private(set) public var localizedStrings: [LocalizedStrings] = []
    @Published private(set) public var usedStrings: [String: [UsedString]] = [:]
    public private(set) var xcassets: [Xcassets] = []
    
    public init(url: URL, progress: Progress) {
        self.url = url
        self.progress = progress
    }
    
    public func load() async {
        // Load file urls
        let urls = FileManager.default.filter(types: [.strings, .swift, .storyboard, .xcassets], at: url)
        self.progress.totalUnitCount = Int64(urls.map { $0.value.count }.reduce(0, { $0 + $1 }))
        
        // Load xcassets
        if let urls = urls[.xcassets], !urls.isEmpty {
            xcassets = await withTaskGroup(of: Xcassets?.self, returning: [Xcassets].self) { group in
                urls.forEach { url in
                    group.addTask(priority: .medium) {
                        let result = Xcassets(url: url)
                        DispatchQueue.main.async {
                            self.progress.localizedDescription = "Loading xcassets \(url.lastPathComponent)"
                            self.progress.completedUnitCount += 1
                        }
                        return result
                    }
                }
                return await group.compactMap { $0 }.reduce([], { $0 + [$1] })
            }.sorted(by: {
                $0.imagesets.count > $1.imagesets.count
            })
            print("xcassets: \(xcassets.count)")
        }
        
        // Load LocalizedStrings
        if let urls = urls[.strings], !urls.isEmpty {            
            localizedStrings = await withTaskGroup(of: StringsFile?.self, returning: [LocalizedStrings].self) { group in
                urls.forEach { url in
                    group.addTask {
                        let result = TextFile(url: url)?.matches(rule: StringsFileMatchRule())
                        DispatchQueue.main.async {
                            self.progress.localizedDescription = "Loading localized strings \(url.lastPathComponent)"
                            self.progress.completedUnitCount += 1
                        }
                        return result
                    }
                }
                
                let results = await group.compactMap {
                    $0
                }.filter {
                    !$0.keyValues.isEmpty
                }.reduce([], {
                    $0 + [$1]
                })
                return LocalizedStrings.createLocalizedStrings(with: results)
            }
            self.progress.localizedDescription = "Loading localized strings is done"
        }
        
        // Load UsedStrings
        let rules: [UsedStringMatchRule] = [
            .init(fileType: .swift, stringPatterns: ["\"(.*?)\""], stringTypeRules: []),
            .init(fileType: .storyboard, stringPatterns: ["\"(.*?)\""], stringTypeRules: []),
        ]
        var useds: [UsedString] = []
        for rule in rules {
            guard let urls = urls[rule.fileType], !urls.isEmpty else {
                continue
            }
            useds += await withTaskGroup(of: [UsedString].self, returning: [UsedString].self, body: { group in
                urls.forEach { url in
                    group.addTask {
                        let result = TextFile(url: url)?.matches(rule: rule) ?? []
                        DispatchQueue.main.async {
                            self.progress.localizedDescription = "Loading used strings \(url.lastPathComponent)"
                            self.progress.completedUnitCount += 1
                        }
                        return result
                    }
                }
                return await group.reduce([], { $0 + $1 })
            })
            usedStrings = useds.toDictionary(keyPath: \.string)
        }
        self.progress.localizedDescription = "Loading used strings is done"
        
        self.progress.localizedDescription = "Loading project is done"
    }
}

extension XCCleaner: Equatable {
    public static func == (lhs: XCCleaner, rhs: XCCleaner) -> Bool {
        lhs.url == rhs.url
    }
}

extension XCCleaner {
    public func updateLocalizedStrings(newKey: LocalizedStrings.Key, oldKey: LocalizedStrings.Key, for strings: LocalizedStrings) {
        guard let stringsIndex = localizedStrings.firstIndex(where: { $0.name == strings.name && $0.directory == strings.directory }) else {
            return
        }
        /// Update Localezed Strings
        localizedStrings[stringsIndex].updateKey(newKey: newKey, oldKey: oldKey)
        
        /// Update Used Strings
        if let useds = usedStrings[oldKey] {
            usedStrings[newKey] = useds.map { $0.update(string: newKey) }
            usedStrings[oldKey] = nil
        }
    }
    
    public func updateLocalizedStrings(newValue: LocalizedStrings.Value, for strings: LocalizedStrings, key: LocalizedStrings.Key) {
        guard let stringsIndex = localizedStrings.firstIndex(where: { $0.name == strings.name && $0.directory == strings.directory }) else {
            return
        }
        localizedStrings[stringsIndex].updateValue(newValue: newValue, for: key)
    }
    
    public func removeLocalizedStrings(value: LocalizedStrings.Value, for strings: LocalizedStrings, key: LocalizedStrings.Key) {
        
    }
}

extension XCCleaner {
    public func removeImageset(_ imageset: Imageset, for xcassets: Xcassets) {
        guard let xcassetsIndex = self.xcassets.firstIndex(where: { $0.url == xcassets.url }) else {
            return
        }
        self.xcassets[xcassetsIndex].removeImageset(imageset)
    }
}

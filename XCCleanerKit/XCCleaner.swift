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
    
    public init(url: URL, progress: Progress) {
        self.url = url
        self.progress = progress
    }
    
    public func load() async {
        // Load file urls
        let urls = FileManager.default.filter(types: [.strings, .swift], at: url)
        
        self.progress.resume()
        
        self.progress.totalUnitCount = Int64(urls.map { $0.value.count }.reduce(0, { $0 + $1 }))
        
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
                }.reduce([], { partialResult, stringsFile in
                    partialResult + [stringsFile]
                })
                return LocalizedStrings.createLocalizedStrings(with: results)
            }
            self.progress.localizedDescription = "Loading localized strings is done"
        }
        
        // Load UsedStrings
        if let urls = urls[.swift] {
            let rules: [UsedStringMatchRule] = [
                .init(fileType: .swift, stringPatterns: ["\"(.*?)\""], stringTypeRules: [])
            ]
//            self.progress.totalUnitCount += Int64(urls.count)
            
            usedStrings = await withTaskGroup(of: [UsedString].self, returning: [String: [UsedString]].self, body: { group in
                urls.forEach { url in
                    group.addTask {
                        let result = TextFile(url: url)?.matches(rules: rules) ?? []
                        DispatchQueue.main.async {
                            self.progress.localizedDescription = "Loading used strings \(url.lastPathComponent)"
                            self.progress.completedUnitCount += 1
                        }
                        
                        return result.flatMap { $0 }
                    }
                }
                
                let result = await group.reduce([], { $0 + $1 })
                return result.toDictionary(keyPath: \.string)
            })
            self.progress.localizedDescription = "Loading used strings is done"
        }
        
        self.progress.localizedDescription = "Loading project is done"
    }
}

extension XCCleaner: Equatable {
    public static func == (lhs: XCCleaner, rhs: XCCleaner) -> Bool {
        lhs.url == rhs.url
    }
}

extension XCCleaner {
    public func updateLocalizedStrings(newKey: LocalizedStrings.Key, for strings: LocalizedStrings) {
        
    }
    
    public func updateLocalizedStrings(newValue: LocalizedStrings.Value, for strings: LocalizedStrings, key: LocalizedStrings.Key) {
        guard let stringsIndex = localizedStrings.firstIndex(where: { $0.name == strings.name && $0.directory == strings.directory }) else {
            return
        }
        var newStrings = localizedStrings[stringsIndex].strings
        newStrings[key] = newStrings[key]?.map { value in
            value.language == newValue.language ? newValue : value
        }
        
        localizedStrings[stringsIndex] = .init(
            name: strings.name,
            directory: strings.directory,
            files: strings.files,
            strings: newStrings
        )
        
        StringsFile(
            directory: strings.directory,
            name: strings.name,
            language: newValue.language,
            strings: localizedStrings[stringsIndex].strings.compactMap { (key, value) -> StringsFile.KeyValue? in
                if let value = value.first(where: { $0.language == newValue.language })?.string {
                    return .init(key: key, value: value)
                } else {
                    return nil
                }
            }.sorted(by: { $0.key < $1.key })
        ).write()
    }
}

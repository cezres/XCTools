//
//  LocalizedStrings.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/1/27.
//

import Foundation

public struct LocalizedStrings: Equatable {
    public let name: String
    public let directory: URL
    public let files: [StringsFile]
    public let strings: [Key: [Value]]
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name && lhs.directory == rhs.directory && lhs.files == rhs.files && lhs.strings == rhs.strings
    }
}

extension LocalizedStrings {
    public typealias Key = String
    
    public struct Value: Codable, Equatable, Hashable, Identifiable {
        public let language: String
        public let string: String
        
        public init(language: String, string: String) {
            self.language = language
            self.string = string
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.language == rhs.language && lhs.string == rhs.string
        }
        
        public var id: Int {
            hashValue
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(language)
            hasher.combine(string)
        }
    }
}

extension LocalizedStrings: Hashable, Identifiable {
    public var id: LocalizedStrings {
        self
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(directory)
    }
}

extension LocalizedStrings {
    static func createLocalizedStrings(with stringsFile: [StringsFile]) -> [LocalizedStrings] {
        let dictionary = stringsFile.toDictionary { element -> Int in
            (element.name + element.directory.path).hashValue
        }
        let result = dictionary.compactMap { (key, value) -> LocalizedStrings? in
            if let file = value.first {
                var strings: [Key: [Value]] = [:]
                
                value.forEach { item in
                    item.strings.forEach { keyValue in
                        if let texts = strings[keyValue.key] {
                            strings[keyValue.key] = texts + [.init(language: item.language, string: keyValue.value)]
                        } else {
                            strings[keyValue.key] = [.init(language: item.language, string: keyValue.value)]
                        }
                    }
                }
                
                return LocalizedStrings(name: file.name, directory: file.directory, files: value, strings: strings)
            } else {
                return nil
            }
        }
        return result
    }
        
    static func createLocalizedStrings(with directory: URL) -> [LocalizedStrings] {
        let urls = FileManager.default.filter(.strings, at: directory)
        let stringsFiles = urls.compactMap { StringsFile(url: $0) }
        return createLocalizedStrings(with: stringsFiles)
    }
}

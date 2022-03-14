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
    public var strings: [Key: [Value]]
    
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
    public func synchronize() {
        let keyValues = strings.map { $0 }.sorted(by: { $0.key < $1.key })
        
        files.forEach { file in
            let strings = keyValues.compactMap { (key, values) -> StringsFile.KeyValue? in
                if let value = values.first(where: { $0.language == file.language }) {
                    return StringsFile.KeyValue(key: key, value: value.string)
                } else {
                    return nil
                }
            }
            file.saveKeyValues(strings)
        }
    }
    
    public mutating func updateKey(newKey: Key, oldKey: Key) {
        /// Update Localezed Strings
        if let oldValues = strings[oldKey] {
            /// Add new key
            strings[newKey] = oldValues
            /// Remove old key
            strings[oldKey] = nil
            /// Write to file
            synchronize()
        }
    }
    
    public mutating func updateValue(newValue: Value, for key: Key) {
        if let values = strings[key], let file = files.first(where: { $0.language == newValue.language }) {
            strings[key] = values.map { $0.language == newValue.language ? newValue : $0 }
            
            let keyValues = strings.compactMap { (key, value) -> StringsFile.KeyValue? in
                if let value = value.first(where: { $0.language == newValue.language })?.string {
                    return .init(key: key, value: value)
                } else {
                    return nil
                }
            }.sorted(by: { $0.key < $1.key })
            file.saveKeyValues(keyValues)
        }
    }
}

extension LocalizedStrings {
    private func saveKeyValues() {
        
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
                    item.keyValues.forEach { keyValue in
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

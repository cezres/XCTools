//
//  StringsFile.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/1/25.
//

import Foundation

public struct StringsFile: Codable, Equatable {
    public let url: URL
    public let name: String
    public let directory: URL
    public let language: String
    public let strings: [KeyValue]
    
    public struct KeyValue: Codable {
        public let key: String
        public let value: String
        
        public init(key: String, value: String) {
            self.key = key
            self.value = value
        }
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.url == rhs.url
    }
}

extension StringsFile: Identifiable {
    public var id: Int {
        url.hashValue
    }
}

extension StringsFile {
    public init?(url: URL) {
        guard url.pathExtension.lowercased() == "strings" else {
            return nil
        }
        self.url = url
        self.directory = url.deletingLastPathComponent().deletingLastPathComponent()
        self.name = url.lastPathComponent
        self.language = url.deletingLastPathComponent().lastPathComponent
        self.strings = Self.loadKeyValues(url: url)
    }
    
    init(directory: URL, name: String, language: String, strings: [KeyValue]) {
        self.url = directory.appendingPathComponent(language).appendingPathComponent(name)
        self.directory = directory
        self.name = name
        self.language = language
        self.strings = strings
    }
    
    func write() {
        do {
            let text = strings.reduce("", { $0 + "\($1.key) = \($1.value);\n" })
            try text.data(using: .utf8)?.write(to: url)
        } catch {
            debugPrint(error)
        }
    }
}

extension StringsFile {
    public static func loadKeyValues(url: URL) -> [KeyValue] {
        guard let text = try? String(contentsOf: url, encoding: .utf8) else {
            return []
        }
        let lines = text.components(separatedBy: "\n")
        return lines.compactMap { lineText in
            loadKeyValue(lineText: lineText)
        }
    }
    
    public static func loadKeyValue(lineText: String) -> KeyValue? {
        guard let keyRange = findString(lineText, range: lineText.startIndex..<lineText.endIndex) else {
            return nil
        }
        
        guard let equalIndex = hasPrefixSymbolIndex(
            text: lineText,
            symbol: "=",
            skip: [" "],
            range: lineText.index(keyRange.upperBound, offsetBy: 1)..<lineText.endIndex
        ) else {
            debugPrint(lineText)
            return nil
        }
        
        guard let valueRange = findString(lineText, range: equalIndex..<lineText.endIndex) else {
            debugPrint(lineText)
            return nil
        }
        
        guard hasPrefixSymbolIndex(
            text: lineText,
            symbol: ";",
            skip: [" "],
            range: lineText.index(valueRange.upperBound, offsetBy: 1)..<lineText.endIndex
        ) != nil else {
            debugPrint(lineText)
            return nil
        }
        let key = String(lineText[keyRange])
        let value = String(lineText[valueRange])
        return .init(key: key, value: value)
    }
}

extension StringsFile {
    static func findString(_ text: String, range: Range<String.Index>) -> Range<String.Index>? {
        guard let startRange = text.range(of: "\"", options: .caseInsensitive, range: range, locale: nil) else {
            return nil
        }
        guard let endRange = text.range(of: "\"", options: .caseInsensitive, range: startRange.upperBound..<range.upperBound, locale: nil) else {
            return nil
        }
        return startRange.upperBound..<endRange.lowerBound
    }
    
    static func hasPrefixSymbolIndex(text: String, symbol: String, skip: [String], range: Range<String.Index>) -> String.Index? {
        var index = range.lowerBound
        while index < range.upperBound {
            let endIndex = text.index(index, offsetBy: 1)
            let value = String(text[index..<endIndex])
            if value == symbol {
                return endIndex
            } else if skip.contains(value) {
                index = endIndex
            } else {
                return nil
            }
        }
        return nil
    }
}

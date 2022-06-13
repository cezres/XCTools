//
//  StringExtensions.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/2/8.
//

import Foundation

extension String {
    var md5: String {
        data(using: .utf8)?.md5.hex ?? self
    }
}

extension String {
    func contains(pattern: String, range: Range<String.Index>? = nil) -> Bool {
        let range = range ?? startIndex..<endIndex
        return contains(pattern: pattern, nsRange: range.toNSRange(for: self))
    }
    
    func contains(pattern: String, nsRange: NSRange? = nil) -> Bool {
        let range = nsRange ?? .init(location: 0, length: count)
        let reg = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return reg.firstMatch(in: self, options: [], range: range) != nil
    }
    
    var fullRange: Range<Index> {
        startIndex..<endIndex
    }
    
    var fullNSRange: NSRange {
        .init(location: 0, length: count)
    }
}

extension String {
    static let blankCharacterSet: Set<Character> = [" ", "\n", "\t"]
    
    func removePrefixBlank() -> String {
        if let index = firstIndex(where: { !String.blankCharacterSet.contains($0) }) {
//            let distance = distance(from: startIndex, to: index)
//            return String(dropFirst(distance))
            return String(self[index..<endIndex])
        } else {
            return self
        }
    }
    
    func removeSuffixBlank() -> String {
        if let index = lastIndex(where: { !String.blankCharacterSet.contains($0) }) {
//            let distance = distance(from: startIndex, to: index)
//            return String(dropFirst(distance))
            return String(self[startIndex...index])
        } else {
            return self
        }
    }
}

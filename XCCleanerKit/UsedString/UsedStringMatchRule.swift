//
//  UsedStringMatchRule.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/2/24.
//

import Foundation

struct UsedStringMatchRule: TextMatcheRule {
    typealias Result = [UsedString]
    
    public let fileType: FileType
    public let stringPatterns: [String]
    public let stringTypeRules: [String]
    
    func matches(in file: TextFile) -> [UsedString] {
        guard fileType.check(url: file.url) else {
            return []
        }
        
        return stringPatterns.flatMap { pattern -> [NSRange] in
            do {
                let reg = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
                let ranges = reg.matches(in: file.text, options: [], range: .init(location: 0, length: file.text.count)).map {
                    $0.range
                }.filter {
                    $0.length > 0
                }
                if ranges.count > 2000 {
                    debugPrint("\(file.url.lastPathComponent) - \(ranges.count)")
                    return []
                } else {
                    return ranges
                }
            } catch {
                debugPrint(error)
                return []
            }
        }.map { range -> UsedString in
            let lineNumber = file.lineNumber(with: range)
            return .init(
                value: file.string(with: range),
                url: file.url,
                lineNumber: lineNumber,
                lineText: file.lineText(with: lineNumber).removePrefixBlank().removeSuffixBlank(),
                type: .none
            )
        }
    }
}

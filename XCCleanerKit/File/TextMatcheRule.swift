//
//  TextMatcheRule.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/1/25.
//

import Foundation

public protocol TextMatcheRule {
    associatedtype Result: Codable
    
    var identifier: String { get }
    
    func matches(in file: TextFile) -> Result
}

public extension TextMatcheRule {
    var identifier: String {
        String(describing: Self.self)
    }
}

extension TextFile {
    func matches<Rule: TextMatcheRule>(rule: Rule) -> Rule.Result {
        let reuseIdentifier = (rule.identifier + url.path).md5
        let differenceIdentifier = url.dataRepresentation.description.md5
        if let result: Rule.Result = Database.default.load(reuseIdentifier: reuseIdentifier, differenceIdentifier: differenceIdentifier) {
//            debugPrint("matches loaded from caches: \(url.lastPathComponent) - \(rule.identifier)")
            return result
        } else {
            let result = rule.matches(in: self)
            Database.default.save(value: result, forReuseIdentifier: reuseIdentifier, differenceIdentifier: differenceIdentifier)
            debugPrint("matches loaded: \(url.lastPathComponent) - \(rule.identifier)")
            return result
        }
    }
    
    func matches<Rule: TextMatcheRule>(rules: [Rule]) -> [Rule.Result] {
        return rules.map { rule in
            matches(rule: rule)
        }
    }
}

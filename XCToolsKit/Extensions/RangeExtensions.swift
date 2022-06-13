//
//  RangeExtensions.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/2/8.
//

import Foundation

public extension NSRange {
    func toRange(for string: String) -> Range<String.Index> {
        string.index(string.startIndex, offsetBy: location)..<string.index(string.startIndex, offsetBy: location + length)
    }
}

public extension Range where Bound == String.Index {
    func toNSRange(for string: String) -> NSRange {
        .init(
            location: string.distance(from: string.startIndex, to: lowerBound),
            length: string.distance(from: lowerBound, to: upperBound)
        )
    }
}

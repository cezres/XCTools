//
//  TextFile.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/1/25.
//

import Foundation

private let wrapRegularExpression = try! NSRegularExpression(pattern: "\n", options: .caseInsensitive)

public struct TextFile {
    let url: URL
    let fileModificationDate: Date
    let text: String
    let wrapIndexs: [NSRange]
    
    public init?(url: URL) {
        guard let fileModificationDate = url.fileModificationDate() else {
            return nil
        }
        self.url = url
        text = (try? String(contentsOfFile: url.path)) ?? ""
        self.fileModificationDate = fileModificationDate
        wrapIndexs = wrapRegularExpression.matches(in: text, options: [], range: text.fullNSRange).map { $0.range }
    }

    func lineNumber(with stringRange: NSRange) -> Int {
        if let index = wrapIndexs.firstIndex(where: {
            $0.location > stringRange.location
        }) {
            return index
        } else {
            return wrapIndexs.count
        }
    }
    
    func lineText(with lineNumber: Int) -> String {
        let startIndex = lineNumber == 0 ? text.startIndex : text.index(text.startIndex, offsetBy: wrapIndexs[lineNumber - 1].upperBound)
        let endIndex = lineNumber >= wrapIndexs.count ? text.endIndex : text.index(text.startIndex, offsetBy: wrapIndexs[lineNumber].location)
        return String(text[startIndex..<endIndex])
    }
    
    func string(with range: NSRange) -> String {
        let startIndex = text.index(text.startIndex, offsetBy: range.location + 1)
        let endIndex = text.index(text.startIndex, offsetBy: range.location + range.length - 1)
        return String(text[startIndex..<endIndex])
    }
}

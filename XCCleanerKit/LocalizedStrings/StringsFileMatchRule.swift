//
//  StringsFileMatchRule.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/3/4.
//

import Foundation

struct StringsFileMatchRule: TextMatcheRule {
    typealias Result = StringsFile?
    
    func matches(in file: TextFile) -> StringsFile? {
        guard file.url.pathExtension.lowercased() == "strings" else {
            return nil
        }
        
        return .init(
            url: file.url,
            name: file.url.lastPathComponent,
            directory: file.url.deletingLastPathComponent().deletingLastPathComponent(),
            language: file.url.deletingLastPathComponent().lastPathComponent,
            keyValues: StringsFile.loadKeyValues(url: file.url)
        )
    }
}

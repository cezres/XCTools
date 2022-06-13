//
//  FileManagerExtensions.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/1/25.
//

import Foundation

extension FileManager {
    public func traverseFileDirectory(_ directory: URL, handler: (_ file: URL, _ isDirectory: Bool) -> Void) {
        do {
            for item in try contentsOfDirectory(atPath: directory.path) {
                let file = directory.appendingPathComponent(item)
                
                var isDirectory: ObjCBool = false
                guard fileExists(atPath: file.path, isDirectory: &isDirectory) else {
                    return
                }
                
                if isDirectory.boolValue {
                    if file.absoluteString.contains("/Build/") || file.absoluteString.contains("Carthage") {
                        continue
                    }
                    handler(file, true)
                    traverseFileDirectory(file, handler: handler)
                } else {
                    handler(file, false)
                }
            }
        } catch {
        }
    }
}

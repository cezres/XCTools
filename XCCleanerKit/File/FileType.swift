//
//  FileType.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/1/25.
//

import Foundation

public enum FileType {
    case strings
    case swift
    case xcassets
    case imageset
    case image
    case storyboard
    
    var isDirectory: Bool {
        switch self {
        case .strings, .swift, .image, .storyboard:
            return false
        case .xcassets, .imageset:
            return true
        }
    }
    
    func check(url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return check(url: url, isDirectory: isDirectory.boolValue)
    }
    
    func check(url: URL, isDirectory: Bool) -> Bool {
        guard isDirectory == self.isDirectory else {
            return false
        }

        switch self {
        case .strings:
            return url.pathExtension.lowercased() == "strings"
        case .swift:
            return url.pathExtension.lowercased() == "swift"
        case .xcassets:
            return url.lastPathComponent.hasSuffix(".xcassets")
        case .imageset:
            return url.lastPathComponent.hasSuffix(".imageset")
        case .image:
            return ["png", "jpeg"].contains(url.pathExtension.lowercased())
        case .storyboard:
            return url.pathExtension.lowercased() == "storyboard"
        }
    }
}

extension FileManager {
    public func filter(types: [FileType], at url: URL) -> [FileType: [URL]] {
        var results: [FileType: [URL]] = [:]
        traverseFileDirectory(url) { file, isDirectory in
            for type in types {
                if type.check(url: file, isDirectory: isDirectory) {
                    if let array = results[type] {
                        results[type] = array + [file]
                    } else {
                        results[type] = [file]
                    }
                }
            }
        }
        return results
    }
    
    public func filter(_ type: FileType, at url: URL) -> [URL] {
        filter(types: [type], at: url)[type] ?? []
    }
}

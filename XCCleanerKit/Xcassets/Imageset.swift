//
//  Imageset.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/3/10.
//

import Foundation
import AppKit

public struct Imageset {
    public let url: URL
    public let name: String

    public init?(url: URL) {
        guard url.isFileDirectory && FileType.imageset.check(url: url) else {
            return nil
        }
        self.url = url
        self.name = url.deletingPathExtension().lastPathComponent
    }
    
    public init(url: URL, name: String) {
        self.url = url
        self.name = name
    }
    
    public mutating func updateName(_ newName: String) throws {
        let newUrl = url.deletingLastPathComponent().appendingPathComponent("\(newName).imageset")
        try FileManager.default.moveItem(at: url, to: newUrl)
        self = .init(url: url, name: newName)
    }
    
    public func compressImageQuality() {
    }
}

extension Imageset {
    public func imageUrls() -> [URL] {
        return FileManager.default.filter(.image, at: url).compactMap { url -> (url: URL, size: UInt64)? in
            if url.pathExtension.lowercased() == "json" {
                return nil
            } else if let size = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? UInt64 {
                return (url, size)
            } else {
                return nil
            }
        }.sorted(by: { $0.size < $1.size }).map { $0.url }
    }
}

extension Imageset: Hashable, Identifiable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
    
    public var id: Imageset {
        self
    }
}

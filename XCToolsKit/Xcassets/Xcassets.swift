//
//  Xcassets.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/3/10.
//

import Foundation

public struct Xcassets {
    public let url: URL
    public let name: String
    public var imagesets: [Imageset] = []
    
    init?(url: URL) {
        guard url.isFileDirectory && FileType.xcassets.check(url: url) else {
            return nil
        }
        
        self.init(
            url: url,
            name: url.deletingPathExtension().lastPathComponent,
            imagesets: FileManager.default.filter(.imageset, at: url).compactMap {
                Imageset(url: $0)
            }.sorted(by: { $0.name < $1.name })
        )
    }
    
    public init(url: URL, name: String, imagesets: [Imageset]) {
        self.url = url
        self.name = name
        self.imagesets = imagesets
    }
    
    public mutating func renameImageset(_ name: String, for imageset: Imageset) {
        guard let index = imagesets.firstIndex(where: { $0.url == imageset.url }) else { return }
        
        do {
            var imagesets = imagesets
            try imagesets[index].updateName(name)
            self = .init(url: url, name: name, imagesets: imagesets)
        } catch {
            debugPrint(error)
        }
    }
    
    public mutating func removeImageset(_ imageset: Imageset) {
        guard let index = imagesets.firstIndex(where: { $0.url == imageset.url }) else { return }
        
        do {
            try FileManager.default.removeItem(at: imageset.url)
            var imagesets = imagesets
            imagesets.remove(at: index)
            self = .init(url: url, name: name, imagesets: imagesets)
        } catch {
            debugPrint(error)
        }
    }
}

extension Xcassets: Identifiable, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(imagesets.count)
    }
    
    public var id: Xcassets {
        self
    }
}

//
//  URL+File.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/3/4.
//

import Foundation

extension URL {
    func fileModificationDate() -> Date? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)[.modificationDate] as? Date
        } catch {
            return nil
        }
    }
    
    var isFileDirectory: Bool {
        guard isFileURL else {
            return false
        }
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
}

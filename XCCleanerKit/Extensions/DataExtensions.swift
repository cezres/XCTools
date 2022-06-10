//
//  DataExtensions.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/2/8.
//

import Foundation
import CryptoKit

public extension Data {
    var md5: Data {
        var digest = Insecure.MD5()
        digest.update(data: self)
        return Data(digest.finalize())
    }
    
    var sha1: Data {
        var digest = Insecure.SHA1()
        digest.update(data: self)
        return Data(digest.finalize())
    }
    
    var hex: String {
        reduce("") { $0 + String(format: "%02x", $1) }
    }
}

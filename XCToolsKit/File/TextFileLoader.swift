//
//  TextFileLoader.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/3/8.
//

import Foundation

class TextFileLoader {
    static let shared = TextFileLoader()
    
    private var caches: [(url: URL, text: String)] = []
    
    private init() {
        
    }
    
    
}

//
//  AppState.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/8.
//

import Foundation
import ComposableArchitecture
import XCCleanerKit

struct AppState: Equatable {
    @BindableState var project: URL?
    
    var strings = LocalizedStringsState()
    
    var xcassets = XcassetsState()
    
    var compress = CompressState()
    
    var cleaner: XCCleaner? {
        didSet {
            strings.cleaner = cleaner
            xcassets.cleaner = cleaner
        }
    }
    
    var progress: Progress?
    
    var isActiveStrings = true
    var isActiveXcassets = false
    var isActiveComoress = false
}

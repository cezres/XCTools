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
    
    var localizedStrings = LocalizedStringsState()
    
    var xcassets = XcassetsState()
    
    var cleaner: XCCleaner? {
        didSet {
            localizedStrings.cleaner = cleaner
            xcassets.cleaner = cleaner
        }
    }
    
    var progress: Progress?
}

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
    
    var cleaner: XCCleaner?
    
    var progress: Progress?
}

extension AppState {
    mutating func setCleaner(_ cleaner: XCCleaner?) {
        self.cleaner = cleaner
        localizedStrings.updateCleaner(cleaner)
    }
}

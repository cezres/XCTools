//
//  LocalizedStringsState.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/8.
//

import Foundation
import ComposableArchitecture
import XCCleanerKit

struct LocalizedStringsState: Equatable {
    var strings: [LocalizedStrings] = []
    var keys: [LocalizedStrings.Key] = []
    var values: [LocalizedStrings.Value] = []
    var useds: [UsedString] = []
    var files: [StringsFile] = []
    
    var selectedStrings: LocalizedStrings?
    var selectedKey: LocalizedStrings.Key?
    
    var cleaner: XCCleaner?
    
    init() {
    }
}

extension LocalizedStringsState {
    mutating func updateCleaner(_ cleaner: XCCleaner?) {
        self.cleaner = cleaner
        
        guard let cleaner = cleaner else {
            strings = []
            selectLocalizedStrings(nil)
            return
        }
        
        strings = cleaner.localizedStrings.sorted(by: { $0.strings.count > $1.strings.count })
        
        if let selectedStrings = selectedStrings, cleaner.localizedStrings.contains(where: { $0.name == selectedStrings.name && $0.directory == selectedStrings.directory }) {
            selectLocalizedStrings(selectedStrings)
        } else {
            selectLocalizedStrings(strings.first)
        }
    }
    
    mutating func selectLocalizedStrings(_ strings: LocalizedStrings?) {
        selectedStrings = strings
        
        guard let selectedStrings = selectedStrings else {
            keys = []
            files = []
            selectKey(nil)
            return
        }
        
        keys = selectedStrings.strings.map { $0.key }.sorted(by: { $0 < $1 })
        files = selectedStrings.files
        
        if let selectedKey = selectedKey, keys.contains(selectedKey) {
            selectKey(selectedKey)
        } else {
            selectKey(keys.first)
        }
    }
    
    mutating func selectKey(_ key: LocalizedStrings.Key?) {
        selectedKey = key
        
        if let key = key {
            values = selectedStrings?.strings[key] ?? []
            useds = cleaner?.usedStrings[key] ?? []
        } else {
            values = []
            useds = []
        }
    }
}

//
//  LocalizedStringsState.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/8.
//

import Foundation
import ComposableArchitecture
import XCToolsKit

struct LocalizedStringsState: Equatable {
    var strings: [LocalizedStrings] = []
    var keys: [LocalizedStrings.Key] = []
    var values: [LocalizedStrings.Value] = []
    var useds: [UsedString] = []
    var files: [StringsFile] = []
    
    var selectedStrings: LocalizedStrings?
    var selectedKey: LocalizedStrings.Key? {
        didSet {
            if let key = selectedKey {
                values = selectedStrings?.strings[key] ?? []
                useds = cleaner?.usedStrings[key] ?? []
            } else {
                values = []
                useds = []
            }
        }
    }
    
    var cleaner: XCCleaner? {
        didSet {
            guard let cleaner = cleaner else {
                strings = []
                selectLocalizedStrings(nil)
                return
            }
            
            strings = cleaner.localizedStrings.sorted(by: { $0.strings.count > $1.strings.count })
            
            if let selectedStrings = selectedStrings, let strings = cleaner.localizedStrings.first(where: { $0.name == selectedStrings.name && $0.directory == selectedStrings.directory }) {
                selectLocalizedStrings(strings)
            } else {
                selectLocalizedStrings(strings.first)
            }
        }
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
        
        if let selectedStrings = selectedStrings, let strings = cleaner.localizedStrings.first(where: { $0.name == selectedStrings.name && $0.directory == selectedStrings.directory }) {
            selectLocalizedStrings(strings)
        } else {
            selectLocalizedStrings(strings.first)
        }
    }
    
    mutating func selectLocalizedStrings(_ strings: LocalizedStrings?) {
        selectedStrings = strings
        
        guard let selectedStrings = selectedStrings else {
            keys = []
            files = []
            selectedKey = nil
            return
        }
        
        keys = selectedStrings.strings.map { $0.key }.sorted(by: { $0 < $1 })
        files = selectedStrings.files
        
        if let selectedKey = selectedKey, keys.contains(selectedKey) {
            self.selectedKey = selectedKey
        } else {
            self.selectedKey = keys.first
        }
    }
}

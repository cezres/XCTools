//
//  LocalizedStringsAction.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/9.
//

import Foundation
import ComposableArchitecture
import XCCleanerKit

enum LocalizedStringsAction: BindableAction {    
    case none
    
    case selectedStrings(LocalizedStrings?)
    
    case selectedKey(LocalizedStrings.Key?)
    
    case binding(BindingAction<LocalizedStringsState>)
    
    case write(strings: LocalizedStrings)
    
    case updateKey(newKey: String, oldKey: String)
    
    case deleteKey(key: LocalizedStrings.Key)
    
    case updateValue(newValue: LocalizedStrings.Value, oldValue: LocalizedStrings.Value)
    case updateValueResponse(Result<XCCleaner, Error>)
    
    case deleteValue(value: LocalizedStrings.Value)
}

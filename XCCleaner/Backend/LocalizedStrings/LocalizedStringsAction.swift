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
    
    case updateKey(newValue: String, oldKey: String)
    case deleteKey(key: String)
    
    case updateValue(newValue: LocalizedStrings.Value, oldValue: LocalizedStrings.Value)
    case updateValueResponse(Result<XCCleaner, Error>)
}

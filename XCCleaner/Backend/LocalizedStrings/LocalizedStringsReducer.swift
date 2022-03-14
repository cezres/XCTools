//
//  LocalizedStringsReducer.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/9.
//

import Foundation
import ComposableArchitecture
import XCCleanerKit

let localizedStringsReducer = Reducer<LocalizedStringsState, LocalizedStringsAction, AppEnvironment>.init { state, action, env in
    switch action {
    case .none:
        return .none
    case .selectedStrings(let strings):
        state.selectLocalizedStrings(strings)
        return .none
    case .selectedKey(let value):
        state.selectedKey = value
        return .none
    case .write(let strings):
        strings.synchronize()
        return .none
    case .updateKey(let newKey, let oldKey):
        guard let strings = state.selectedStrings else {
            return .none
        }
        state.cleaner?.updateLocalizedStrings(newKey: newKey, oldKey: oldKey, for: strings)
        state.updateCleaner(state.cleaner)
        return .none
    case .deleteKey(let key):
        
        return .none
        
    case .updateValue(let newValue, let oldValue):
        guard let strings = state.selectedStrings, let key = state.selectedKey, let cleaner = state.cleaner else { return .none }
        return Effect<XCCleaner, Error>.task {
            cleaner.updateLocalizedStrings(newValue: newValue, for: strings, key: key)
            return cleaner
        }
        .receive(on: AnySchedulerOf<DispatchQueue>.main)
        .catchToEffect(LocalizedStringsAction.updateValueResponse)
    case .updateValueResponse(let .success(response)):
        state.updateCleaner(response)
        return .none
    case .updateValueResponse(.failure):
        return .none
        
    case .deleteValue(let value):
        
        return .none
        
    case .binding:
        return .none
    }
}.binding()

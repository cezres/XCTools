//
//  XcassetsReducer.swift
//  XCCleaner
//
//  Created by azusa on 2022/3/10.
//

import Foundation
import ComposableArchitecture
import XCCleanerKit

typealias XcassetsStateUpdater = (_ state: inout XcassetsState) -> Void
typealias StateUpdater<T> = (_ state: inout T) -> Void
 
let xcassetsReducer = Reducer<XcassetsState, XcassetsAction, AppEnvironment>.init { state, action, env in
    switch action {
    case .none(let result):
        return .none
    case .removeImageset(let imageset):
        guard let selectedXcassets = state.selectedXcassets, let cleaner = state.cleaner else { return .none }
        return Effect<XcassetsStateUpdater, Error>.task {
            cleaner.removeImageset(imageset, for: selectedXcassets)
            return { state in
                state.cleaner = cleaner
            }
        }
        .receiveOnMain()
        .catchToEffect(XcassetsAction.updater)
    case .renameImageset(name: let name, imageset: let imageset):
        return .none
    case .selectedXcassets(let xcassets):
        state.selectedXcassets = xcassets
        return .none
    case .selectedImageset(let imageset):
        state.selectedImageset = imageset
        return .none
    case .updater(let .success(response)):
        response(&state)
        return .none
    case .updater(.failure):
        return .none
    }
}

import Combine

extension Effect {
    func receiveOnMain() -> Publishers.ReceiveOn<Self, AnySchedulerOf<DispatchQueue>> {
        receive(on: AnySchedulerOf<DispatchQueue>.main)
    }
    
    func azusa() {
        
    }
}

extension Publisher {
    func receiveOnMain() -> Publishers.ReceiveOn<Self, AnySchedulerOf<DispatchQueue>> {
        receive(on: AnySchedulerOf<DispatchQueue>.main)
    }
}

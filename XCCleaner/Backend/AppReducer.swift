//
//  AppReducer.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/8.
//

import Foundation
import ComposableArchitecture
import XCCleanerKit

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    .init { state, action, env in
        switch action {
        case .close:
            state.project = nil
            state.cleaner = nil
            return .none
        case .loadProject(let url):
            state.project = url
            state.progress = Progress()
            if let url = url {
                return XCCleaner.fetch(url, progress: state.progress!)
                    .receive(on: AnySchedulerOf<DispatchQueue>.main)
                    .catchToEffect(AppAction.loadProjectResponse)
            } else {
                return .none
            }
        case let .loadProjectResponse(.success(response)):
            state.cleaner = response
            state.progress = nil
            return .none
        case .loadProjectResponse(.failure):
            return .none
        default:
            return .none
        }
    },
    localizedStringsReducer.pullback(
        state: \.localizedStrings,
        action: /AppAction.localizedString,
        environment: { value in
            return .init()
        }
    ),
    xcassetsReducer.pullback(state: \.xcassets, action: /AppAction.xcassets, environment: { value in
        return .init()
    })
)

extension XCCleaner {
    static func fetch(_ url: URL, progress: Progress) -> Effect<XCCleaner, Error> {
        Effect.task(priority: .medium) {
            let cleaner = XCCleaner.init(url: url, progress: progress)
            await cleaner.load()
            return cleaner
        }
    }
}

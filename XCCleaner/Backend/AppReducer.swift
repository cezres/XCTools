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
        case .xcassets(let action):
            if case .compressXcassets(let xcassets) = action {
                let urls = xcassets.imagesets.flatMap { $0.imageUrls() }
                state.compress.todoUrls.append(contentsOf: urls)
                state.isActiveXcassets = false
                state.isActiveComoress = true
            }
            return .none
        case .setIsActiveXcassets(let value):
            state.isActiveXcassets = value
            return .none
        case .setIsActiveComoress(let value):
            state.isActiveComoress = value
            return .none
        case .setIsActiveStrings(let value):
            state.isActiveStrings = value
            return .none
        default:
            return .none
        }
    },
    localizedStringsReducer.pullback(
        state: \.strings,
        action: /AppAction.strings,
        environment: { value in
            return .init()
        }
    ),
    xcassetsReducer.pullback(state: \.xcassets, action: /AppAction.xcassets, environment: { value in
        return .init()
    }),
    compressReducer.pullback(state: \.compress, action: /AppAction.compress, environment: { value in
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

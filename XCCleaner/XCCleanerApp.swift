//
//  XCCleanerApp.swift
//  XCCleaner
//
//  Created by azusa on 2022/1/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct XCCleanerApp: App {
    var body: some Scene {
        WindowGroup<ContentView> {
            ContentView(
                store: Store(
                    initialState: AppState(),
                    reducer: appReducer,
                    environment: AppEnvironment()
                )
            )
        }
        .windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: true))
    }
}

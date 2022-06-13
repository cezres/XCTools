//
//  XCToolsApp.swift
//  XCTools
//
//  Created by azusa on 2022/5/19.
//

import SwiftUI
import ComposableArchitecture

@main
struct XCToolsApp: App {
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

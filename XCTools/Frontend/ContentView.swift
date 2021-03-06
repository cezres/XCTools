//
//  ContentView.swift
//  XCCleaner
//
//  Created by azusa on 2022/1/25.
//

import SwiftUI
import ComposableArchitecture
import XCToolsKit

struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var navigationView: some View {
        NavigationView {
            List {
                WithViewStore(store) { viewStore in
                    NavigationLink(isActive: viewStore.binding(get: \.isActiveStrings, send: AppAction.setIsActiveStrings)) {
                        LocalizableStringsPage(store: store.scope(state: \.strings, action: AppAction.strings))
                    } label: {
                        Text("Strings")
                    }
                
                    NavigationLink(isActive: viewStore.binding(get: \.isActiveXcassets, send: AppAction.setIsActiveXcassets)) {
                        XcassetsPage(store: store.scope(state: \.xcassets, action: AppAction.xcassets))
                    } label: {
                        Text("Xcassets")
                    }
                    
                    NavigationLink(isActive: viewStore.binding(get: \.isActiveComoress, send: AppAction.setIsActiveComoress)) {
                        CompressPage(store: store.scope(state: \.compress, action: AppAction.compress))
                    } label: {
                        Text("Compress")
                    }
                    
                    NavigationLink {
                        SettingsPage()
                    } label: {
                        Text("Settings")
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 160)
        }
        .frame(minWidth: 1000, minHeight: 600)
    }
        
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {                
                navigationView
                    .navigationTitle(viewStore.project?.path ?? "XCCleaner")
                    .toolbar {
                        ToolbarItem {
                            if let progress = viewStore.progress {
                                ProgressView(progress)
                                    .progressViewStyle(LinearProgressViewStyle())
                                    .frame(width: 300, height: 30, alignment: .trailing)
                            }
                        }
                        ToolbarItem {
                            Button {
                                viewStore.send(.loadProject(viewStore.project))
                            } label: {
                                Image(systemName: "goforward")
                            }
                        }
                        ToolbarItem {
                            Button {
                                viewStore.send(.close)
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }
                    }
                OpenFileSelector(
                    url: viewStore.binding(get: \.project, send: AppAction.loadProject),
                    title: "Open a Xcode project directory"
                ).configurationOpenPanel { panel in
                    panel.canChooseFiles = false
                    panel.canChooseDirectories = true
                }
                .padding(Edge.Set.leading, 160)
            }
        }
    }
}

struct NavigationTitle: View {
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(
//            store: Store(
//                initialState: Counter(),
//                reducer: counterReducer,
//                environment: CounterEnvironment()
//            )
//        )
//    }
//}

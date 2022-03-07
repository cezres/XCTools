//
//  LocalizableStringsPage.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/8.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import XCCleanerKit

struct LocalizableStringsPage: View {
    let store: Store<LocalizedStringsState, LocalizedStringsAction>
    
    @State var index: Int? = 0
    
    @State var keyIndex: Int? = nil
    
    @State var key: LocalizedStrings.Key? = nil
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                HStack(spacing: 0) {
                    ListView(
                        selection: viewStore.binding(get: \.selectedStrings, send: LocalizedStringsAction.selectedStrings),
                        title: "Strings",
                        data: viewStore.strings
                    ) {
                        LocalizedStringsRowView(localizedStrings: $0)
                    }
                    
                    ListView(
                        selection: viewStore.binding(get: \.selectedKey, send: LocalizedStringsAction.selectedKey),
                        title: "Key",
                        data: viewStore.keys
                    ) {
                        LocalizedStringsKeyRowView(value: $0, color: viewStore.state.keyTextColor($0)) { newText, oldText in
                            viewStore.send(.updateKey(newValue: newText, oldKey: oldText))
                        } deleteAction: { text in
                            viewStore.send(.deleteKey(key: text))
                        }
                    }
                    
                    ListView(title: "Value", data: viewStore.values) {
                        LocalizedStringsValueRowView(value: $0) { newValue, oldValue in
                            viewStore.send(.updateValue(newValue: newValue, oldValue: oldValue))
                        } deleteAction: { text in
                            
                        }
                    }

                    ListView(title: "Used", data: viewStore.useds) {
                        UsedStringRowView(value: $0)
                    }
                    
                    ListView(title: "File", data: viewStore.files) {
                        LocalizedStringsFileRowView(stringsFile: $0)
                    }
                }
            }
        }
    }
}

extension LocalizedStringsState {
    func keyTextColor(_ key: LocalizedStrings.Key) -> Color? {
        if cleaner?.usedStrings[key]?.isEmpty ?? true {
            return .orange
        }
        if let strings = selectedStrings, let values = strings.strings[key], values.count != strings.files.count {
            return .red
        }
        return nil
    }
}

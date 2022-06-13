//
//  CompressImagePage.swift
//  XCCleaner
//
//  Created by azusa on 2022/3/14.
//

import SwiftUI
import ComposableArchitecture

struct CompressPage: View {
    let store: Store<CompressState, CompressAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Button {
                        viewStore.send(.handle)
                        print("Compress")
                    } label: {
                        Text("Compress")
                    }
                }
                HStack(spacing: 0) {
                    ListView(title: "Todo (\(viewStore.todoUrls.count))", data: viewStore.todoUrls.identifiable) {
                        Text("\($0.value.lastPathComponent)")
                            .padding(.vertical, 8)
                    }
                    ListView(title: "In Progress", data: viewStore.inProgressUrls.identifiable) {
                        Text("\($0.value.lastPathComponent)")
                            .padding(.vertical, 8)
                    }
                    ListView(title: "Done", data: viewStore.doneUrls.identifiable) {
                        Text("\($0.value.lastPathComponent)")
                            .padding(.vertical, 8)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Compress") {
                        print("Compress")
                    }
                }
            }
        }
    }
}

struct CompressPage_Previews: PreviewProvider {
    static var previews: some View {
        CompressPage(
            store: .unchecked(initialState: .init(), reducer: compressReducer, environment: .init())
        )
    }
}

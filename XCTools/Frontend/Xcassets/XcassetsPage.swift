//
//  XcassetsPage.swift
//  XCCleaner
//
//  Created by azusa on 2022/3/10.
//

import SwiftUI
import ComposableArchitecture
import XCToolsKit

struct XcassetsPage: View {
    let store: Store<XcassetsState, XcassetsAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ListView(
                        selection: viewStore.binding(get: \.selectedXcassets, send: XcassetsAction.selectedXcassets),
                        title: "Xcassets",
                        data: viewStore.xcassets
                    ) {
                        XcassetsRowView(value: $0) { xcassets in
                            viewStore.send(.compressXcassets(xcassets))
                        }
                    }
                    
                    ListView(
                        selection: viewStore.binding(get: \.selectedImageset, send: XcassetsAction.selectedImageset),
                        title: "Imageset",
                        data: viewStore.imagesets
                    ) {
                        XcassetsImagesetRowView(value: $0, color: viewStore.state.imagesetTextColor($0)) { name, imageset in
                            viewStore.send(.renameImageset(name: name, imageset: imageset))
                        } deleteAction: { value in
                            viewStore.send(.removeImageset(value))
                        }
                    }
                    
                    ListView(title: "Used", data: viewStore.useds) {
                        UsedStringRowView(value: $0)
                    }
                    
                    ListView(title: "Image", data: viewStore.images.identifiable) {
                        XcassetsImageRowView(url: $0.value)
                    }
                }
                Text("zzzz")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .padding()
            }
            
        }
    }
}

extension XcassetsState {
    func imagesetTextColor(_ imageset: Imageset) -> Color? {
        if imageset.imageUrls().isEmpty {
            return .red
        }
        if cleaner?.usedStrings[imageset.name]?.isEmpty ?? true {
            return .orange
        }
        return nil
    }
}

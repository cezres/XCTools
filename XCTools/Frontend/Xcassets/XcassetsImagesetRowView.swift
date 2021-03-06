//
//  XcassetsImagesetRowView.swift
//  XCCleaner
//
//  Created by azusa on 2022/3/11.
//

import SwiftUI
import XCToolsKit

struct XcassetsImagesetRowView: View {
    let value: Imageset
    let color: Color?
    let editAction: (_ name: String, _ imageset: Imageset) -> Void
    let deleteAction: (_ value: Imageset) -> Void
    
    var body: some View {
        TextEditorView(text: value.name, foregroundColor: color, contextMenuItems: [
            .init(label: "Show In Finder", action: {
                CommandLineTool.openFile(value.url)
            })
        ], editAction: { newText, oldText in
            editAction(newText, value)
        }, deleteAction: { text in
            deleteAction(value)
        })
    }
}

//struct XcassetsImagesetRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        XcassetsImagesetRowView()
//    }
//}

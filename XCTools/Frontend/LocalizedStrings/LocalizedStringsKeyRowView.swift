//
//  LocalizedStringsKeyRowView.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/23.
//

import SwiftUI
import XCToolsKit

struct LocalizedStringsKeyRowView: View {
    let value: LocalizedStrings.Key
    let color: Color?
    let editAction: (_ newValue: String, _ oldValue: String) -> Void
    let deleteAction: (_ value: String) -> Void
    
    var body: some View {
        TextEditorView(text: value, foregroundColor: color, editAction: editAction, deleteAction: deleteAction)
//            .padding(.vertical, 8)
    }
}

//struct LocalizedStringsKeyRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocalizedStringsKeyRowView()
//    }
//}

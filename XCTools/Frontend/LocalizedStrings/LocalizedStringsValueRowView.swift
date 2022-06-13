//
//  LocalizedStringsValueRowView.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/24.
//

import Foundation
import SwiftUI
import XCToolsKit

struct LocalizedStringsValueRowView: View {
    let value: LocalizedStrings.Value
    let editAction: (_ newValue: LocalizedStrings.Value, _ oldValue: LocalizedStrings.Value) -> Void
    let deleteAction: (_ value: LocalizedStrings.Value) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value.language)
                .font(.subheadline)
                .lineLimit(1)
                .foregroundColor(Color.gray)
            TextEditorView(text: value.string) { newText, oldText in
                editAction(.init(language: value.language, string: newText), value)
            } deleteAction: { text in
                deleteAction(value)
            }
        }
        .padding(.vertical, 8)
    }
}

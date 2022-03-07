//
//  TextEditor.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/28.
//

import SwiftUI

struct TextEditorView: View {
    var text: String
    var foregroundColor: Color?
    var contextMenuItems: [MenuItem] = []
    var editAction: (_ newText: String, _ oldText: String) -> Void
    var deleteAction: (_ text: String) -> Void
    
    struct MenuItem: Identifiable {
        let label: String
        let action: () -> Void
        
        var id: String { label }
    }
    
    @State private var tempText: String = ""
    @State private var isEditing = false

    var textView: some View {
        HStack {
            if isEditing {
                TextEditor(text: $tempText)
                    .font(.body)
                    .padding(.vertical, 8)
                    .foregroundColor(nil)
                Spacer()
                VStack {
                    Button {
                        isEditing = false
                        editAction(tempText, text)
                    } label: {
                        Image(systemName: "checkmark.square")
                    }
                    .buttonStyle(.borderless)
                    Button {
                        isEditing = false
                    } label: {
                        Image(systemName: "xmark.square")
                    }
                    .buttonStyle(.borderless)
                }
            } else {
                Text(text)
                    .font(.body)
                    .padding(.vertical, 8)
                    .foregroundColor(foregroundColor)
            }
        }
    }
    
    var body: some View {
        textView
            .contextMenu {
                Button("Edit") {
                    tempText = text
                    isEditing = true
                }
                Button("Remove") {
                    deleteAction(text)
                }
                Button("Copy") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(text, forType: .string)
                }
                ForEach(contextMenuItems) {
                    Button($0.label, action: $0.action)
                }
            }
    }
}

struct TextEditingView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView(text: "text1", editAction: { _,_ in
            
        }, deleteAction: { text in 
            
        })
    }
}


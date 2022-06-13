//
//  ListView.swift
//  XCCleaner
//
//  Created by azusa on 2021/12/17.
//

import SwiftUI

struct ListView<Data, Content, SelectionValue>: View where Data : RandomAccessCollection, Data.Element: Identifiable, Content: View, SelectionValue: Hashable {
    let selection: Binding<SelectionValue?>?
    let title: String
    let data: Data
    let content: (Data.Element) -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ListTitleView(title: title)
            List(selection: selection) {
                ForEach(data) {
                    content($0)
                }
            }
        }
    }
}

extension ListView where SelectionValue == Never {
    init(title: String, data: Data, content: @escaping (Data.Element) -> Content) {
        self.selection = nil
        self.title = title
        self.data = data
        self.content = content
    }
}

struct ListTitleView: View {
    let title: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.leading, 16)
            if let action = action {
                Spacer()
                Button(action: action) {
                    Image(systemName: "plus.circle")
                }
                .buttonStyle(.borderless)
                .padding(.trailing, 16)
            }
        }
        .padding(.vertical, 16)
    }
}


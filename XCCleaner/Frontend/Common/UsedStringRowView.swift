//
//  UsedStringRowView.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/25.
//

import SwiftUI
import XCCleanerKit

struct UsedStringRowView: View {
    let value: UsedString
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value.url.lastPathComponent)
                .foregroundColor(.gray)
                .font(.subheadline)
            Text("Line: \(value.lineNumber + 1)")
                .foregroundColor(.gray)
                .font(.subheadline)
            let components = value.lineText.replacingOccurrences(of: value.string, with: "###").components(separatedBy: "###")
            Text(components[0]) +
            Text(value.string)
                .foregroundColor(.red)
                .fontWeight(.bold) +
            Text(components[1])
        }
        .padding(.vertical, 8)
        .onTapGesture(count: 2) {
            CommandLineTool.openFile(value.url)
        }
    }
}

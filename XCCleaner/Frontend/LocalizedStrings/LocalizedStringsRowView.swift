//
//  LocalizedStringsRowView.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/23.
//

import SwiftUI
import XCCleanerKit

struct LocalizedStringsRowView: View {
    let value: LocalizedStrings
    let writeAction: (_ value: LocalizedStrings) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(value.name) (\(value.strings.count))")
            Text(value.directory.path)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .contextMenu {
            Button("Write to file") {
                writeAction(value)
            }
        }
        .padding(.vertical, 8)
    }
}

extension LocalizedStringsRowView: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value.name == rhs.value.name && lhs.value.strings.count == rhs.value.strings.count
    }
}

//struct LocalizedStringsRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocalizedStringsRowView()
//    }
//}

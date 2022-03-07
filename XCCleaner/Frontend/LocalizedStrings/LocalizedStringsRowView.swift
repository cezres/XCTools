//
//  LocalizedStringsRowView.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/23.
//

import SwiftUI
import XCCleanerKit

struct LocalizedStringsRowView: View {
    let localizedStrings: LocalizedStrings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(localizedStrings.name) (\(localizedStrings.strings.count))")
            Text(localizedStrings.directory.path)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

//struct LocalizedStringsRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocalizedStringsRowView()
//    }
//}

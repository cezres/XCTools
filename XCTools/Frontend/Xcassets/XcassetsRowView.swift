//
//  XcassetsRowView.swift
//  XCCleaner
//
//  Created by azusa on 2022/3/11.
//

import SwiftUI
import XCToolsKit

struct XcassetsRowView: View {
    let value: Xcassets
    let compress: (_ xcassets: Xcassets) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(value.name) (\(value.imagesets.count))")
            Text(value.url.path)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .contextMenu {
            Button("Compress Imagesets") {
                compress(value)
            }
        }
        .padding(.vertical, 8)
    }
}

//struct XcassetsRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        XcassetsRowView()
//    }
//}

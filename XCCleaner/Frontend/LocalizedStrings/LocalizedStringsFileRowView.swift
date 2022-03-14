//
//  LocalizedStringsFileRowView.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/23.
//

import SwiftUI
import XCCleanerKit

struct LocalizedStringsFileRowView: View {
    let stringsFile: StringsFile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stringsFile.language)
                .font(.subheadline)
                .foregroundColor(Color.gray)
            Text(stringsFile.url.path)
        }
        .padding(.vertical, 8)
        .onTapGesture(count: 2) {
            CommandLineTool.openFile(stringsFile.url)
        }
    }
}

//struct LocalizedStringsFileRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocalizedStringsFileRowView()
//    }
//}

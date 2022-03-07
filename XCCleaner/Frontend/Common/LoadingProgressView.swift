//
//  LoadingProgressView.swift
//  XCCleaner
//
//  Created by azusa on 2022/3/7.
//

import SwiftUI
import XCCleanerKit

struct LoadingProgressView: View {
    @State var progress2: Progress
    
    var body: some View {
        ProgressView(progress2)
            .progressViewStyle(LinearProgressViewStyle())
            .frame(width: 180, height: 30)
    }
}

//
//  XcassetsImageRowView.swift
//  XCCleaner
//
//  Created by azusa on 2022/3/11.
//

import SwiftUI

struct XcassetsImageRowView: View {
    let url: URL
    
    var body: some View {
        if let data = try? Data(contentsOf: url), let image = NSImage(data: data), let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            VStack(alignment: .leading) {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: min(100, image.size.height))
                    .background(Color(red: 240/255.0, green: 240/255.0, blue: 240/255.0))
                    .border(.gray, width: 1)
                Text("\(cgImage.width)x\(cgImage.height)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(data.count) Bytes")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .onTapGesture(count: 2) {
                CommandLineTool.openFile(url.deletingLastPathComponent())
            }
        }
    }
}

//struct XcassetsImageRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        XcassetsImageRowView()
//    }
//}

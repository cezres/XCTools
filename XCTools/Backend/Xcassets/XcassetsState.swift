//
//  XcassetsState.swift
//  XCCleaner
//
//  Created by azusa on 2022/3/10.
//

import Foundation
import XCToolsKit

struct XcassetsState: Equatable {
    var xcassets: [Xcassets] = []
    var imagesets: [Imageset] = []
    var useds: [UsedString] = []
    var images: [URL] = []
    
    var cleaner: XCCleaner? {
        didSet {
            guard let cleaner = cleaner else {
                xcassets = []
                imagesets = []
                useds = []
                images = []
                return
            }
            xcassets = cleaner.xcassets
            
            if let selectedXcassets = selectedXcassets, !xcassets.contains(selectedXcassets) {
                if let index = xcassets.firstIndex(where: { $0.url == selectedXcassets.url }) {
                    if selectedXcassets.imagesets.count != xcassets[index].imagesets.count {
                        self.selectedXcassets = xcassets[index]
                    }
                } else {
                    self.selectedXcassets = nil
                }
            }
        }
    }
    
    var selectedXcassets: Xcassets? {
        didSet {
            guard let selectedXcassets = selectedXcassets else {
                imagesets = []
                useds = []
                images = []
                return
            }
            
            imagesets = selectedXcassets.imagesets.sorted(by: { set1, set2 in
                set1.getSize() > set2.getSize()
            })
            
            if let selectedImageset = selectedImageset, !imagesets.contains(selectedImageset) {
                self.selectedImageset = nil
            }
        }
    }
    var selectedImageset: Imageset? {
        didSet {
            guard let selectedImageset = selectedImageset else {
                useds = []
                images = []
                return
            }
            useds = cleaner?.usedStrings[selectedImageset.name] ?? []
            images = selectedImageset.imageUrls()
        }
    }
        
    var unusedFiles: [URL] = []
    var unusedFileSize: UInt64 = 0
}

extension XcassetsState {
}

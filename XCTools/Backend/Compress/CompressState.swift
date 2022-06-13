//
//  CompressImageState.swift
//  XCCleaner
//
//  Created by azusa on 2022/3/14.
//

import Foundation

struct CompressState: Equatable {
    var todoUrls: [URL] = []
    var inProgressUrls: [URL] = []
    var doneUrls: [URL] = []
}

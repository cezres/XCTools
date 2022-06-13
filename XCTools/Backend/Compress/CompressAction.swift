//
//  CompressImageAction.swift
//  XCCleaner
//
//  Created by azusa on 2022/3/14.
//

import Foundation
import ComposableArchitecture

enum CompressAction {
    case addItems([URL])
    case handle
    case updater(Result<StateUpdater<CompressState>, Error>)
}

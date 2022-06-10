//
//  XcassetsAction.swift
//  XCCleaner
//
//  Created by azusa on 2022/3/10.
//

import Foundation
import ComposableArchitecture
import XCCleanerKit

enum XcassetsAction {
    case none(Result<Void, Error>)
    case updater(Result<XcassetsStateUpdater, Error>)

    case selectedXcassets(Xcassets?)
    case selectedImageset(Imageset?)
    
    case removeImageset(Imageset)
    case renameImageset(name: String, imageset: Imageset)
    
    case compressXcassets(Xcassets)
}

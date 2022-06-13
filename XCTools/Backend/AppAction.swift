//
//  AppAction.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/8.
//

import Foundation
import ComposableArchitecture
import XCToolsKit

enum AppAction {
    case close
    case strings(LocalizedStringsAction)
    case xcassets(XcassetsAction)
    case compress(CompressAction)
    
    case loadProject(URL?)
    case loadProjectResponse(Result<XCCleaner, Error>)
    
    case setIsActiveXcassets(Bool)
    case setIsActiveComoress(Bool)
    case setIsActiveStrings(Bool)
}

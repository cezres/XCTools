//
//  AppAction.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/8.
//

import Foundation
import ComposableArchitecture
import XCCleanerKit

enum AppAction {
    case close
    case localizedString(LocalizedStringsAction)
    
    case loadProject(URL?)
    case loadProjectResponse(Result<XCCleaner, Error>)
}

//
//  CompressImageReducer.swift
//  XCCleaner
//
//  Created by azusa on 2022/3/14.
//

import Foundation
import ComposableArchitecture
import XCCleanerKit

let compressReducer = Reducer<CompressState, CompressAction, AppEnvironment>.init { state, action, env in
    switch action {
    case .addItems(let urls):
        return .none
    case .handle:
        guard !state.todoUrls.isEmpty else {
            return .none
        }
        let state = state
        return Effect<StateUpdater<CompressState>, Error>.task(priority: .medium) {
            var todoUrls = state.todoUrls
            var inProgressUrls = state.inProgressUrls
            var doneUrls = state.doneUrls
            
            let tempDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)[0], isDirectory: true).appendingPathComponent("xccleaner").appendingPathComponent("compress_temp", isDirectory: true)
            try? FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true, attributes: nil)
            
            while !todoUrls.isEmpty {
                while !todoUrls.isEmpty && inProgressUrls.count < 20 {
                    inProgressUrls.append(todoUrls.removeFirst())
                }
                
                guard !inProgressUrls.isEmpty else { break }
                
                inProgressUrls.forEach { url in
                    do {
                        let data = try Data(contentsOf: url)
                        let toUrl = tempDirectory.appendingPathComponent(data.md5.hex)
                        try FileManager.default.copyItem(at: url, to: toUrl)
                    } catch {
                        debugPrint(error)
                    }
                }
                
                CommandLineTool.openFile(tempDirectory)
            }
            
            return { state in
                
            }
        }
        .receiveOnMain()
        .catchToEffect(CompressAction.updater)
    case .updater(let result):
        if case .success(let updater) = result {
            updater(&state)
        }
        return .none
    }
}

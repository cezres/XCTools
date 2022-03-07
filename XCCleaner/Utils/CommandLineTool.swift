//
//  CommandLineTool.swift
//  XCCleaner
//
//  Created by azusa on 2022/2/25.
//

import Foundation

struct CommandLineTool {
    static func openFile(_ url: URL) {
        launchedShell(shell: "open \(url.path)")
    }
    
    static func launchedShell(shell: String, directoryPath: String = "") {
        let process = Process()
        if directoryPath != "" {
            process.currentDirectoryPath = directoryPath
        }
        process.launchPath = "/bin/sh"
        process.arguments = ["-c", shell]
        process.launch()
        process.waitUntilExit()
    }
}

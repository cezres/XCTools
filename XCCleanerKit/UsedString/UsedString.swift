//
//  UsedString.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/2/24.
//

import Foundation

public struct UsedString: Codable {
    public var string: String
    public let url: URL
    public let lineNumber: Int
    public var lineText: String
    public let type: UsedStringType
    
    private let _id: Int
    
    init(value: String, url: URL, lineNumber: Int, lineText: String, type: UsedStringType) {
        self.string = value
        self.url = url
        self.lineNumber = lineNumber
        self.lineText = lineText
        self.type = type
        
        var hasher = Hasher()
        hasher.combine(value)
        hasher.combine(url)
        hasher.combine(lineNumber)
        hasher.combine(lineText)
        hasher.combine(type.rawValue)
        _id = hasher.finalize()
    }
    
    func update(string: String) -> Self {
        do {
            let text = try String(contentsOf: url)
            var lines = text.components(separatedBy: "\n")
            guard lineNumber < lines.count else {
                return self
            }
            guard let range = lines[lineNumber].range(of: "\"\(self.string)\"") else {
                return self
            }
            lines[lineNumber] = lines[lineNumber].replacingCharacters(in: range, with: "\"\(string)\"")
            try lines.joined(separator: "\n").data(using: .utf8)?.write(to: url)
            return .init(value: string, url: url, lineNumber: lineNumber, lineText: lines[lineNumber], type: type)
        } catch {
            return self
        }
    }
    
//    enum CodingKeys: String, CodingKey {
//        case string
//        case url
//    }
    
//    public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//    }
}

extension UsedString: Hashable, Identifiable {
    public var id: Int {
        _id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
}

public enum UsedStringType: Int, Codable {
    case none
    case imageset
    case localizedString
}

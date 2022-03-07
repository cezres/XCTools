//
//  UsedString.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/2/24.
//

import Foundation

public struct UsedString: Codable {
    public let string: String
    public let url: URL
    public let lineNumber: Int
    public let lineText: String
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
    
//    enum CodingKeys: String, CodingKey {
//        case string
//        case url
//    }
    
//    public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//    }
}

extension UsedString: Hashable, Identifiable {
    public var id: Self {
        self
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

//
//  Array+Identifiable.swift
//  XCCleaner
//
//  Created by azusa on 2021/12/20.
//

import Foundation

struct IdentifiableValue<T>: Identifiable {
    var id: Int
    let value: T
    
    init(identifiable: Int, value: T) {
        self.id = identifiable
        self.value = value
    }
}

extension Array {
    var identifiable: [IdentifiableValue<Element>] {
        return enumerated().map { (index, item) in
            IdentifiableValue<Element>(identifiable: index, value: item)
        }
    }
    
    var indexs: [Int] {
        enumerated().map { $0.offset }
    }
}

extension Int: Identifiable {
    public var id: Int {
        self
    }
}

//
//  SequenceExtensions.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/1/27.
//

import Foundation

extension Sequence {
    public func toDictionary<ID, Value>(keyPath: KeyPath<Element, ID>, valuePath: KeyPath<Element, Value>) -> [ID: [Value]] where ID: Hashable {
        var dictionary: [ID: [Value]] = [:]
        
        forEach { element in
            let key = element[keyPath: keyPath]
            let value = element[keyPath: valuePath]
            if let sequence = dictionary[key] {
                dictionary[key] = sequence + [value]
            } else {
                dictionary[key] = [value]
            }
        }
        
        return dictionary
    }
    
    public func toDictionary<ID>(keyPath: KeyPath<Element, ID>) -> [ID: [Element]] where ID: Hashable {
        var dictionary: [ID: [Element]] = [:]
        
        forEach { element in
            let key = element[keyPath: keyPath]
            if let sequence = dictionary[key] {
                dictionary[key] = sequence + [element]
            } else {
                dictionary[key] = [element]
            }
        }
        
        return dictionary
    }
    
    public func toDictionary<ID>(keyPath: (_ element: Element) -> ID) -> [ID: [Element]] where ID: Hashable {
        var dictionary: [ID: [Element]] = [:]
        
        forEach { element in
            let key = keyPath(element)
            if let sequence = dictionary[key] {
                dictionary[key] = sequence + [element]
            } else {
                dictionary[key] = [element]
            }
        }
        
        return dictionary
    }

    public func toSet() -> Set<Element> where Element: Hashable {
        .init(self)
    }
}

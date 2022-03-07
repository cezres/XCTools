//
//  Database.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/2/28.
//

import Foundation
import SQLite

let DownloadsDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)[0], isDirectory: true)

class Database {
    public static let `default` = Database(directory: DownloadsDirectory.appendingPathComponent("xccleaner", isDirectory: true))
    public static let inMemory = Database(location: .inMemory)
    public static let temporary = Database(location: .temporary)
    
//    public var enable = true
    
    private var db: Connection?
    private let location: Connection.Location
    
    private init(location: Connection.Location) {
        self.location = location
        _ = database()
    }
    
    private convenience init(directory: URL) {
        do {
            let path = directory.appendingPathComponent("xccleaner.db").path
            if !FileManager.default.fileExists(atPath: directory.path) {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: false, attributes: nil)
            }
            self.init(location: .uri(path))
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func database() -> Connection? {
        guard db == nil else {
            return db
        }
        
        do {
            db = try Connection(location, readonly: false)
            
            try db?.run(
                cachesTable.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { builder in
                    builder.column(reuseIdentifierExpression, primaryKey: true)
                    builder.column(differenceIdentifierExpression)
                    builder.column(dataExpression)
                })
            )
        } catch {
            debugPrint(error)
        }
        return db
    }
    
    /// Table
    let cachesTable = Table("caches")
    let reuseIdentifierExpression = Expression<String>("reuseIdentifier")
    let differenceIdentifierExpression = Expression<String>("differenceIdentifier")
    let dataExpression = Expression<Data>("data")
}

extension Database {
    func load<Value: Codable>(type: Value.Type, forReuseIdentifier reuseIdentifier: String, differenceIdentifier: String) -> Value? {
        return load(reuseIdentifier: reuseIdentifier, differenceIdentifier: differenceIdentifier)
    }
    
    func load<Value: Codable>(reuseIdentifier: String, differenceIdentifier: String) -> Value? {
        guard let db = database() else {
            return nil
        }
        
        do {
            let query = cachesTable.filter(
                reuseIdentifierExpression == reuseIdentifier && differenceIdentifierExpression == differenceIdentifier
            )
            for item in try db.prepare(query) {
                let data = item[dataExpression]
                return try JSONDecoder().decode(Value.self, from: data)
            }
        } catch {
            debugPrint(error)
        }
        return nil
    }
    
    func save<Value: Codable>(value: Value, forReuseIdentifier reuseIdentifier: String, differenceIdentifier: String) {
        guard let db = database() else {
            return
        }
        
        do {
            let data = try JSONEncoder().encode(value)
            let row = cachesTable.filter(reuseIdentifierExpression == reuseIdentifier)
            if try db.prepare(row).suffix(1).isEmpty {
                try db.run(
                    cachesTable.insert(
                        reuseIdentifierExpression <- reuseIdentifier,
                        differenceIdentifierExpression <- differenceIdentifier,
                        dataExpression <- data
                    )
                )
            } else {
                try db.run(
                    row.update(
                        differenceIdentifierExpression <- differenceIdentifier,
                        dataExpression <- data
                    )
                )
            }
        } catch {
            debugPrint(error)
        }
    }
}

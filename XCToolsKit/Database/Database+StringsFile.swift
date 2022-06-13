//
//  Database+StringsFile.swift
//  XCCleanerKit
//
//  Created by azusa on 2022/2/28.
//

import Foundation
import SQLite


protocol DatabaseTable {
    static var tableName: String { get }
    
    static func tableBuilder(_ builder: TableBuilder)
    
    func save(to db: Connection) throws
    
    static func load(reuseIdentifier: String, differenceIdentifier: String, for db: Connection) -> Self?
}

extension DatabaseTable {
    static var table: Table {
        .init(tableName)
    }
    
    static func createTable(for db: Connection) throws {
        let sql = table.create(temporary: false, ifNotExists: true, withoutRowid: false) { builder in
            tableBuilder(builder)
        }
        try db.run(sql)
    }
}

struct TableExample: DatabaseTable {
    static var tableName: String = "Aaaaa"
    static let reuseIdentifierExpression = Expression<String>("reuseIdentifier")
    static let differenceIdentifierExpression = Expression<String>("differenceIdentifier")
    static let dataExpression = Expression<Data>("data")
        
    static func tableBuilder(_ builder: TableBuilder) {
        builder.column(reuseIdentifierExpression, primaryKey: true)
        builder.column(differenceIdentifierExpression)
        builder.column(dataExpression)
    }
    
    let reuseIdentifier: String
    let differenceIdentifier: String
    let data: Data
    
    init(reuseIdentifier: String, differenceIdentifier: String, data: Data) {
        self.reuseIdentifier = reuseIdentifier
        self.differenceIdentifier = differenceIdentifier
        self.data = data
    }
    
    init<Value: Codable>(reuseIdentifier: String, differenceIdentifier: String, value: Value) {
        self.init(
            reuseIdentifier: reuseIdentifier,
            differenceIdentifier: differenceIdentifier,
            data: try! JSONEncoder().encode(value)
        )
    }
    
    func loadValue<Value: Codable>() -> Value? {
        do {
            return try JSONDecoder().decode(Value.self, from: data)
        } catch {
            return nil
        }
    }
    
    func save(to db: Connection) {
        
    }
    
    static func load(reuseIdentifier: String, differenceIdentifier: String, for db: Connection) -> TableExample? {
        do {
            let query = table.filter(
                reuseIdentifierExpression == reuseIdentifier && differenceIdentifierExpression == differenceIdentifier
            )
            for item in try db.prepare(query) {
                let data = item[Self.dataExpression]
                return .init(reuseIdentifier: reuseIdentifier, differenceIdentifier: differenceIdentifier, data: data)
            }
        } catch {
        }
        return nil
    }
}

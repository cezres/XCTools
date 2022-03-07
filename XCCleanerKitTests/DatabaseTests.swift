//
//  DatabaseTests.swift
//  XCCleanerKitTests
//
//  Created by azusa on 2022/2/28.
//

import XCTest
@testable import XCCleanerKit

class DatabaseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let db = Database.inMemory
        
        db.save(value: 2233, forReuseIdentifier: "111", differenceIdentifier: "111")
        
        XCTAssertEqual(db.load(type: Int.self, forReuseIdentifier: "111", differenceIdentifier: "111"), 2233)
        XCTAssertEqual(db.load(type: Int.self, forReuseIdentifier: "111", differenceIdentifier: "222"), nil)
        
        db.save(value: 2244, forReuseIdentifier: "111", differenceIdentifier: "222")
        XCTAssertEqual(db.load(type: Int.self, forReuseIdentifier: "111", differenceIdentifier: "111"), nil)
        XCTAssertEqual(db.load(type: Int.self, forReuseIdentifier: "111", differenceIdentifier: "222"), 2244)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

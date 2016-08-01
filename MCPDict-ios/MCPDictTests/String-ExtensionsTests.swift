//
//  String-ExtensionsTests.swift
//  MCPDict
//
//  Created by zengming on 6/7/16.
//  Copyright © 2016 ioi.im. All rights reserved.
//

import XCTest



class String_ExtensionsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        
        let u1 = "曾你 abc".unicodeScalars
        for u in u1 {
            
            print([u], String(format: "%04X", u.value))
            
            
        }
        
        let c:UInt32 = 0x4f60
        let u = UnicodeScalar(c)
        // Convert UnicodeScalar to a Character.
        let char = Character(u)
        
        // Write results.
        print(char)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}

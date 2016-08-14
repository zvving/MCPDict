//
//  OrthographyTests.swift
//  MCPDict
//
//  Created by zengming on 6/19/16.
//  Copyright © 2016 ioi.im. All rights reserved.
//

import XCTest


class OrthographyTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPU() {
        let pys = [("ni1", "nī"),
                   ("wo3", "wǒ"),
                   ("gui2", "guí"),
                   ("niu2", "niú"),
                   ("ao4", "ào"),
                   ("yv2","yǘ"),
                   ("yv_","yü"),
                   ("e1", "ē"),
                   ("mo", "mo")]
        
        
        for py in pys {
            let s = Orthography.displayPU(py.0)
            let b = s == py.1
            assert(b, "音标错啦")
        }
    }
    
    func testVN() {
        let vns = [("nhix,neex", "nhĩ,nễ"),
                   ("ngax", "ngã"),
                   ]
        
        
        for vn in vns {
            let s = Orthography.displayVN(vn.0)
            let b = s == vn.1
            assert(b, "音标错啦")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.

    }

}

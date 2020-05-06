//
//  DBHelper.swift
//  MCPDict
//
//  Created by zengming on 2020/5/3.
//  Copyright © 2020 ioi.im. All rights reserved.
//

import SQLite
import Foundation



class DBHelper {
    
    static let shared = DBHelper()
    
    private let db: Connection
    
    init() {
        let path = Bundle.main.path(forResource: "mcpdict", ofType: "db")
        db = try! Connection(path ?? "", readonly: true)
        
        db.trace { (log) in
            print("db: \(log)")
        }
    }
}

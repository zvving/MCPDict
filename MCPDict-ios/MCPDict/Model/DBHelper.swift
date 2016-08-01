//
//  DBHelper.swift
//  MCPDict
//
//  Created by zengming on 6/5/16.
//  Copyright © 2016 ioi.im. All rights reserved.
//

import SQLite

let unicode = Expression<String?>("unicode")
let mc = Expression<String?>("mc")
let pu = Expression<String?>("pu")
let ct = Expression<String?>("ct")
let sh = Expression<String?>("sh")
let mn = Expression<String?>("mn")
let kr = Expression<String?>("kr")
let vn = Expression<String?>("vn")
let jp_go = Expression<String?>("jp_go")
let jp_kan = Expression<String?>("jp_kan")
let jp_tou = Expression<String?>("jp_tou")
let jp_kwan = Expression<String?>("jp_kwan")
let jp_other = Expression<String?>("jp_other")

let db_col_field = Expression<String>("field")

let dbTableDicts = Table("mcpdict")

let dbTableVariants = Table("orthography_hz_variants")

class DBHelper {
    
    private var db : Connection

    static let sharedInstance = DBHelper()
    
    private init() {
        let path = NSBundle.mainBundle().pathForResource("mcpdict", ofType: "db")
        db = try! Connection(path!)
        db.trace { (str) in
            print(str)
        }
    }
    
    func query(query: QueryType) -> [Row] {
        return Array(try! db.prepare(query))
    }
}

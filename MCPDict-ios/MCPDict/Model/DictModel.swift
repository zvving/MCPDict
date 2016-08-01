//
//  DictModel.swift
//  MCPDict
//
//  Created by zengming on 6/5/16.
//  Copyright © 2016 ioi.im. All rights reserved.
//


class DictModel: CustomStringConvertible {
    
    // todo: 你如何查询多个 unicode ?
    
    var hz: String!
    
    /// 主键 我 6211
    var unicodeString: String! {
        didSet {
            self.unicodeInt = UInt32(unicodeString, radix: 16)
        }
    }
    
    var unicodeInt: UInt32! {
        didSet {
            let u = UnicodeScalar(unicodeInt)
            self.hz = String(u)
        }
    }
    
    /// 中古 ngax todo: 中文提示来源?
    var mc: String!
    
    /// 普通话 wo3
    var pu: String!
    
    /// 粤语 ngo5
    var ct: String!
    
    /// 吴语 ngu1,|ngu6|
    var sh: String!
    
    /// 闽 |gua2|,*ngoo2*
    var mn: String!
    
    /// 朝 a
    var kr: String!
    
    /// 越 ngax
    var vn: String!
    
    
    /// 日吴 *ga*
    var jp_go: String!
    
    
    /// 日汉 *ga*
    var jp_kan: String!
    
    ///
    var jp_tou: String!
    
    ///
    var jp_kwan: String!
    
    /// 日他
    var jp_other: String!
    
    var hasFavorited: Bool = false
    
    init() {
        
    }
    
    var description: String {
        get {
            return "[+U\(unicode)]\(hz):"
        }
    }
    
    
}

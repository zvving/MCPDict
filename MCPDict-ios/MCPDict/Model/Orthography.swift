//
//  Orthography.swift
//  MCPDict
//
//  Created by zengming on 6/19/16.
//  Copyright © 2016 ioi.im. All rights reserved.
//

import CSwiftV


class Orthography: NSObject {
    
    static let sharedInstance = Orthography()
    
    
    var pu_pinyin: [String:(combined:String, base:String, tone:String)]
    
    var pu_bopomofo_partial: [String:String]
    var pu_bopomofo_whole: [String:String]
    var pu_bopomofo_tone: [String:String]

    
    private override init() {
        
        /// orthography_pu_pinyin
        let arrays = Orthography.loadArrays("orthography_pu_pinyin", ext: "tsv")
        
        var rs:[String:(combined:String, base:String, tone:String)] = [:]
        for row in arrays {
            let k = "\(row[1])\(row[2])"
            let v = (combined:row[0], base:row[1], tone:row[2])
            rs[k] = v
        }
        
        /// orthography_pu_bopomofo
//        let arrays_pu_bopomofo = Orthography.loadFileContent("orthography_pu_bopomofo", ext: "tsv")
        
        pu_pinyin = [:]
        pu_bopomofo_partial = [:]
        pu_bopomofo_whole = [:]
        pu_bopomofo_tone = [:]
        
    }

    static func displayPU(origin:String) -> String {
        var varOrigin = origin
        guard let match = varOrigin.rangeOfString("[1234_]", options: .RegularExpressionSearch) else {
            print("none:\(varOrigin)")
            return varOrigin
        }
        
        let tone = varOrigin.substringWithRange(match)
        varOrigin.replaceRange(match, with: "")
        
        var range:Range<String.Index>!
        var base = ""
        if let r = varOrigin.rangeOfString("ui") {
            base = "i"
            range = r.startIndex.advancedBy(1) ..< r.endIndex
        } else if let r = varOrigin.rangeOfString("iu") {
            base = "u"
            range = r.startIndex.advancedBy(1) ..< r.endIndex
        } else if let r = varOrigin.rangeOfString("a") {
            base = "a"
            range = r
        } else if let r = varOrigin.rangeOfString("o") {
            base = "o"
            range = r
        } else if let r = varOrigin.rangeOfString("e") {
            base = "e"
            range = r
        } else if let r = varOrigin.rangeOfString("i") {
            base = "i"
            range = r
        } else if let r = varOrigin.rangeOfString("u") {
            base = "u"
            range = r
        } else if let r = varOrigin.rangeOfString("v") {
            base = "v"
            range = r
        }
        
        varOrigin.replaceRange(range!, with: Orthography.sharedInstance.pu_pinyin["\(base)\(tone)"]?.combined ?? "*")
        
        
        
        
        print("...:\(tone),\(varOrigin)")
        return varOrigin
    }
    
    private static func loadFileContent(name:String, ext:String) -> String {
        return try! String(contentsOfFile: NSBundle.mainBundle().pathForResource(name, ofType: ext)!, encoding: NSUTF8StringEncoding)
    }
    
    private static func loadArrays(fileName:String, ext:String) -> [[String]] {
        let content = Orthography.loadFileContent("orthography_pu_pinyin", ext: "tsv")
        
        var rows = content.componentsSeparatedByString("\n")
        rows = rows.map({
            if let regex = try? NSRegularExpression(pattern: "#.*", options: .CaseInsensitive) {
                let modString = regex.stringByReplacingMatchesInString($0, options: .WithTransparentBounds, range: NSMakeRange(0, $0.characters.count), withTemplate: "")
                return modString
            }
            return $0
        }).filter({
            !$0.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet()).isEmpty
        })
        
        let rs = rows.map { (row) -> [String] in
            return row.componentsSeparatedByString("\t")
        }
        
        return rs
    }
}

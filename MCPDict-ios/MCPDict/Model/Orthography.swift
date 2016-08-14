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
    
    // mc
    
    var mc_initials: [String:String]
    var mc_initials_keys: [String]
    
    var mc_finals: [String:(se:String, deng:String, hu:String, yun:String)]
    var mc_bieng_siyix: [String:String]
    
    // pu
    var pu_pinyin: [String:(combined:String, base:String, tone:String)]
    
    var pu_bopomofo_partial: [String:String]
    var pu_bopomofo_whole: [String:String]
    var pu_bopomofo_tone: [String:String]
    
    // vn
    
    var vn: [String:(combined:String, base:String, tone:String)]
    
    // jp
    
    // 日本式羅馬字
    var jp_nippon: [String:(hiragana:String, katakana:String)]
    var jp_nippon_keys: [String]
    
    // 黑本式羅馬字
    var jp_hepburn: [String:(hiragana:String, katakana:String)]
    var jp_hepburn_keys: [String]

    
    private override init() {
        
        mc_initials = [:]
        mc_initials_keys = []
        mc_finals = [:]
        mc_bieng_siyix = [:]
        
        pu_pinyin = [:]
        pu_bopomofo_partial = [:]
        pu_bopomofo_whole = [:]
        pu_bopomofo_tone = [:]
        
        vn = [:]
        
        jp_nippon = [:]
        jp_nippon_keys = []
        jp_hepburn = [:]
        jp_hepburn_keys = []
        
        // mc
        
        var arrays = Orthography.loadArrays("orthography_mc_initials", ext: "tsv")
        for row in arrays {
            mc_initials[row[0]] = row[1];
        }
        mc_initials_keys = mc_initials.keys.sort { (s0, s1) -> Bool in
            s0.characters.count > s1.characters.count
        }
        arrays = Orthography.loadArrays("orthography_mc_finals", ext: "tsv")
        for row in arrays {
            let v = (se:row[1], deng:row[2], hu:row[3], yun:row[4])
            mc_finals[row[0]] = v;
        }
        arrays = Orthography.loadArrays("orthography_mc_bieng_sjyix", ext: "tsv")
        for row in arrays {
            let chats:[Character] = Array(row[1].characters)
            for char in chats {
                mc_bieng_siyix[String(char)] = row[0];
            }
        }
        
        
        // pu_pinyin
        arrays = Orthography.loadArrays("orthography_pu_pinyin", ext: "tsv")
        for row in arrays {
            let k = "\(row[1])\(row[2])"
            let v = (combined:row[0], base:row[1], tone:row[2])
            pu_pinyin[k] = v;
        }
        
        // vn
        arrays = Orthography.loadArrays("orthography_vn", ext: "tsv")
        for row in arrays {
            let k = "\(row[1])\(row[2])"
            let v = (combined:row[0], base:row[1], tone:row[2])
            vn[k] = v;
        }
        
        // jp
        arrays = Orthography.loadArrays("orthography_jp", ext: "tsv")
        for row in arrays {
            let v = (hiragana:row[0], katakana:row[1])
            jp_nippon[row[2]] = v;
            jp_hepburn[row[3]] = v;
        }
        // 音标字符从长到短排序, 转换时优先转换长音标
        jp_nippon_keys = jp_nippon.keys.sort { (s0, s1) -> Bool in
            s0.characters.count > s1.characters.count
        }
        jp_hepburn_keys = jp_hepburn.keys.sort { (s0, s1) -> Bool in
            s0.characters.count > s1.characters.count
        }

        
    }
    
    // mc
    static func displayMC(origin:String?) -> String? {
        // 简单实现
        
        guard var varOrigin = origin where !varOrigin.isEmpty else {
            return nil
        }
        
        // tone
        var tone = 0
        let lastStr = String(varOrigin.characters.last!)
        switch lastStr {
        case "x":
            tone = 1
            varOrigin = varOrigin.stringByReplacingOccurrencesOfString(lastStr, withString: "")
            break
        case "h":
            tone = 2
            varOrigin = varOrigin.stringByReplacingOccurrencesOfString(lastStr, withString: "")
            break
        case "d":
            tone = 2
            break
        case "p":
            tone = 3
            varOrigin = varOrigin.stringByReplacingOccurrencesOfString(lastStr, withString: "m")
            break
        case "t":
            tone = 3
            varOrigin = varOrigin.stringByReplacingOccurrencesOfString(lastStr, withString: "n")
            break
        case "k":
            tone = 3
            varOrigin = varOrigin.stringByReplacingOccurrencesOfString(lastStr, withString: "ng")
            break
            
        default:
            break
        }

        // 切割声部韵部
        
        let initialsDict = Orthography.sharedInstance.mc_initials
        let initialsDictKeys = Orthography.sharedInstance.mc_initials_keys
        
        var start = "";
        var end = "";
        
        for key in initialsDictKeys {
            if varOrigin.hasPrefix(key) {
                start = key;
                end = varOrigin.stringByReplacingOccurrencesOfString(start, withString: "")
                break
            }
        }
        
        start = initialsDict[start] ?? "*"
        
        let endTuple = Orthography.sharedInstance.mc_finals[end]! // ?? (se:"*", deng:"*", hu:"*", yun:"*")
        
        let range = endTuple.yun.startIndex.advancedBy(tone)
        let yun = String(endTuple.yun[range])
        let yunDiao = Orthography.sharedInstance.mc_bieng_siyix[yun] ?? "*"
        
        end = "\(endTuple.se)\(yun)\(endTuple.deng)\(endTuple.hu) \(yunDiao)"
        
        return "\(origin!)(\(start)\(end))"
    }
    

    // pu
    static func displayPU(origin:String?) -> String? {
        
        guard var varOrigin = origin where !varOrigin.isEmpty else {
            return nil
        }
        
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
    
    // vn
    static func displayVN(origin:String?) -> String? {
        guard var varOrigin = origin where !varOrigin.isEmpty else {
            return nil
        }
        // 这块 android 实现没看懂, 先简单实现
        
        let vnDict = Orthography.sharedInstance.vn
        for key in vnDict.keys {
            varOrigin = varOrigin.stringByReplacingOccurrencesOfString(
                key,
                withString: (vnDict[key]?.combined)!)
        }
        
        return varOrigin
    }
    
    // jp
    static func displayJP(origin:String?) -> String? {
        // 简单实现
        
        guard var varOrigin = origin where !varOrigin.isEmpty else {
            return nil
        }
        
        // todo: from config
        let jpDict = Orthography.sharedInstance.jp_nippon
        let keys = Orthography.sharedInstance.jp_nippon_keys
        
        for key in keys {
            // todo: from config
            let str = jpDict[key]?.katakana ?? "*"
            varOrigin = varOrigin.stringByReplacingOccurrencesOfString(
                key,
                withString: str)
        }
        
        return varOrigin
    }

    
    // common
    
    private static func loadFileContent(name:String, ext:String) -> String {
        return try! String(contentsOfFile: NSBundle.mainBundle().pathForResource(name, ofType: ext)!, encoding: NSUTF8StringEncoding)
    }
    
    private static func loadArrays(fileName:String, ext:String) -> [[String]] {
        let content = Orthography.loadFileContent(fileName, ext: ext)
        
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

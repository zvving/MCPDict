//
//  Extensions.swift
//  MCPDict
//
//  Created by zengming on 6/7/16.
//  Copyright © 2016 ioi.im. All rights reserved.
//

import Foundation


extension String
{
    func firstToUnicodeString() -> String? {
        
        return ""
    }
    
    func UnicodeStringToString() -> String? {
        return String(format: "%04x", self)
    }
}

extension String {
    func regex (pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(rawValue: 0))
            let nsstr = self as NSString
            let all = NSRange(location: 0, length: nsstr.length)
            var matches : [String] = [String]()
            regex.enumerateMatchesInString(self, options: NSMatchingOptions(rawValue: 0), range: all) {
                (result : NSTextCheckingResult?, _, _) in
                if let r = result {
                    let result = nsstr.substringWithRange(r.range) as String
                    matches.append(result)
                }
            }
            return matches
        } catch {
            return [String]()
        }
    }
} 

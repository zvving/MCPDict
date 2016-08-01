//
//  DictProvider.swift
//  MCPDict
//
//  Created by zengming on 6/5/16.
//  Copyright © 2016 ioi.im. All rights reserved.
//

import SQLite

enum SearchArgument {
        /// 仅在广韵中查找
    case KuangxYonhOnly
        /// 简繁转换
    case AllowVariants
        /// 声调不敏感
    case ToneInsensitive
}

enum SearchMode : String  {
    case HZ = "汉字"
    case MC = "中古拼音"
    case PU = "普通话"
    case CT = "粤语"
    case SH = "吴语（上海话）"
    case MN = "闽南语"
    case KR = "朝鲜语"
    case VN = "越南语"
    case JP_GO = "日语吴音"
    case JP_KAN = "日语汉音"
    case JP_ANY = "日语（任意读音）"
    
    static let allValues = [HZ, MC, PU, CT, SH, MN, KR, VN, JP_GO, JP_KAN, JP_ANY]
    
    var queryKey: Expression<String?> {
        switch self {
        case .HZ:
            return unicode
        case .MC:
            return mc
        case .PU:
            return pu
        case .CT:
            return ct
        case .SH:
            return sh
        case .MN:
            return mn
        case .KR:
            return kr
        case .VN:
            return vn
        case .JP_GO:
            return jp_go
        case .JP_KAN:
            return jp_kan
        case .JP_ANY:
            return jp_other
        }
    }
}

class DictProvider {
    
    static let sharedInstance = DictProvider()
    
    func query(keywords : String, mode : SearchMode, extraArguments : [SearchArgument]) -> [DictModel] {

        var formatKeywords = keywords
        
        print("query:\(keywords),\(mode),\(extraArguments)")
        
        // 检查
        
        // 判断空
        
        var dictModels : [DictModel] = []
        
        var wordArr:[String] = []
        
        
        if (mode == SearchMode.HZ) {
            // 汉字
            
            // 简繁转换&异形字 AllowVariants
            if extraArguments.contains(SearchArgument.AllowVariants) {
                formatKeywords = ""
                for char in keywords.characters {
                    
                    let query = dbTableVariants.filter(db_col_field.like("\(char)%"))
                    let rows = DBHelper.sharedInstance.query(query)
                    
                    if rows.count > 0 {
                        let variants: String = rows.first!.get(db_col_field)
                        formatKeywords = formatKeywords + variants
                    } else {
                        formatKeywords = formatKeywords + "\(char)"
                    }
                    
                }
                
            }
            
            // 分拆
            wordArr = formatKeywords.characters.map{ String($0) }
        

            
            
        } else {
            // 非汉字
            
            // 分拆
            wordArr = formatKeywords.componentsSeparatedByString(" ")
            
            // todo: ToneInsensitive
        }
        
        
        // 去重
        wordArr = Array(Set(wordArr))
        
        for word in wordArr {
            let models = self.queryOne(word, mode: mode, extraArguments: extraArguments)
            dictModels.appendContentsOf(models)
        }
        
        return dictModels
        
    }
    
    private func queryOne( oneWord : String, mode : SearchMode, extraArguments : [SearchArgument]) -> [DictModel] {
        
        // KuangxYonhOnly
        var isKuangxYonhOnly:Expression<Bool?> = Expression<Bool?>(value: true)
        if extraArguments.contains(SearchArgument.KuangxYonhOnly) {
            isKuangxYonhOnly = mc != nil
        }
        
        var query:QueryType!
        
        switch mode {
        case .HZ:
            let unicodeOneWord = String(oneWord.unicodeScalars.first?.value ?? 0, radix: 16).uppercaseString
            query = dbTableDicts.filter(isKuangxYonhOnly && mode.queryKey == unicodeOneWord)
            
            break
            
        case .MC, .PU, .CT, .SH, .MN, .KR, .VN, .JP_GO, .JP_KAN, .JP_ANY:
            query = dbTableDicts.filter(isKuangxYonhOnly && mode.queryKey == oneWord)
            
            break
            
//        default:
//            break
        }
        
        return queryOneWordByQuery(query)
    }
    
    
    private func queryOneWordByQuery( query: QueryType) -> [DictModel] {
        
        let rows = DBHelper.sharedInstance.query(query)
        var models: [DictModel] = []
        
        for r in rows {
            if let model = convertRowToDictModel(r) {
                models.append(model)
            }
        }
        
        return models
    }
    
    private func convertRowToDictModel(origin_row: Row?) -> DictModel? {
        
        guard let row = origin_row else {
            return nil
        }

        let model = DictModel()
        model.unicodeString = row[unicode]
        model.mc = row[mc]
        model.pu = row[pu]
        model.ct = row[ct]
        model.sh = row[sh]
        model.mn = row[mn]
        model.kr = row[kr]
        model.vn = row[vn]
        model.jp_go = row[jp_go]
        model.jp_kan = row[jp_kan]
        model.jp_tou = row[jp_tou]
        model.jp_kwan = row[jp_kwan]
        model.jp_other = row[jp_other]
            
        return model
    }
}

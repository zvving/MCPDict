//
//  ItemView.swift
//  MCPDict
//
//  Created by zengming on 2020/5/3.
//  Copyright © 2020 ioi.im. All rights reserved.
//

import SwiftUI

enum LangType: String {
    case ct         = "lang_ct"         // 粤
    case jpGo       = "lang_jp_go"      // 日吴
    case jpKan      = "lang_jp_kan"     // 日汉
    case jpKwan     = "lang_jp_kwan"    // 日惯
    case jpOther    = "lang_jp_other"   // 日他
    case jpTou      = "lang_jp_tou"     // 日唐
    case kr         = "lang_kr"         // 朝
    case mc         = "lang_mc"         // 中古
    case mn         = "lang_mn"         // 闽
    case pu         = "lang_pu"         // 普
    case sh         = "lang_sh"         // 吴
    case vn         = "lang_vn"         // 越
}


struct ItemLabel: View {
    
    @State var text: String?
    var langType: LangType
    
    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(langType.rawValue)
                .resizable()
                .frame(width: 16, height: 15)
            Text(text ?? "哈哈一串解释")
                .font(.caption)
                .foregroundColor(.primary)
        }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct ItemView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack {
                Text("你").font(.largeTitle).foregroundColor(.red)
                Text("U+4F34").font(.subheadline).foregroundColor(.secondary)
            }.frame(width: 80)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    ItemLabel(text: nil, langType: .mc)
//                    Button(action: {}, label: { Image(systemName: "bookmark") })
                }
                HStack {
                    ItemLabel(text: nil, langType: .pu)
                    ItemLabel(text: nil, langType: .ct)
                }
                HStack {
                    ItemLabel(text: nil, langType: .sh)
                    ItemLabel(text: nil, langType: .mn)
                }
                HStack {
                    ItemLabel(text: nil, langType: .kr)
                    ItemLabel(text: nil, langType: .vn)
                }
                HStack {
                    ItemLabel(text: nil, langType: .jpGo)
                    ItemLabel(text: nil, langType: .jpKan)
                }
                HStack {
                    ItemLabel(text: nil, langType: .jpKwan)
                    ItemLabel(text: nil, langType: .jpTou)
                }
                HStack {
                    ItemLabel(text: nil, langType: .jpOther)
                }
            }
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ItemView()
        }
    }
}

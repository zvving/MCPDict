//
//  QueryView.swift
//  MCPDict
//
//  Created by zengming on 2020/5/3.
//  Copyright © 2020 ioi.im. All rights reserved.
//

import SwiftUI

struct QueryView: View {
    
    
    
    var body: some View {
        VStack {
            HStack {
                Text("查询内容：")
                TextField("输入汉字或读音", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                .frame(height: 44)
            }
            HStack {
                Text("查询配置：")
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("模式")
                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("选项")
                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }.frame(height: 44)

            List {
                ItemView()
                    .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
            }
            
            
            
        }.padding(20)
    }
}

struct QueryView_Previews: PreviewProvider {
    static var previews: some View {
        QueryView()
    }
}

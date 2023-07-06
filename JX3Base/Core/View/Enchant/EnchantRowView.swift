//
//  EnchantView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/6.
//

import SwiftUI

/// 展示小附魔、大附魔的视图
struct EnchantRowView: View {
    // 附魔实体类
    let enchant: Enchant
    // 是否显示属性
    let showAttri: Bool
    
    /// 初始化附魔展示视图
    /// - Parameters:
    ///   - enchant: 附魔实体
    ///   - showAttri: 是否显示附魔属性
    init(enchant: Enchant, showAttri: Bool = true) {
        self.enchant = enchant
        self.showAttri = showAttri
    }
    
    var body: some View {
        HStack {
            Text(enchant.name)
                .bold()
                .foregroundColor(enchant.quality?.color ?? .gray)
                .lineLimit(1)
            if showAttri, let attriName = enchant.attriName {
                Spacer()
                Text(attriName)
                    .font(.caption)
            }
        }
    }
}

struct EnchantView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            EnchantRowView(enchant: dev.enchant1)
            EnchantRowView(enchant: dev.enchant1, showAttri: false)
        }
    }
}

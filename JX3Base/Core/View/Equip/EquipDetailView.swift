//
//  EquipDetailView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/21.
//

import SwiftUI

struct EquipDetailView: View {
    let equip: EquipDTO
    
    @State private var diamondAttributeLevels: [Int]
    private let diamondAttributeCount: Int

    init(equip: EquipDTO) {
        self.equip = equip
        self.diamondAttributeCount = equip.diamondAttributes.count
        self.diamondAttributeLevels = Array(repeating: 6, count: diamondAttributeCount)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            header
            baseInfoView
            magicInfoView
            embedding
            
            requireTypeView
            
            Spacer()
        }
        .foregroundColor(.white)
        .font(.headline)
        .padding()
        .background(Color.theme.panel)
    }
    
    // MARK: 头部
    private var header: some View {
        VStack(spacing: 8) {
            HStack {
                Text(equip.name)
                    .foregroundColor(equip.quality.color)
                    .font(.title3)
                    .bold()
                HStack {
                    HStack(spacing: 0) {
                        ForEach(1 ... equip.maxStrengthLevel, id: \.self) { l in
                            if l <= equip.maxStrengthLevel / 2 {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            } else {
                                Image(systemName: "star")
                            }
                        }
                    }
                    .font(.caption)
                    
                    Spacer()
                    
                    Text("精炼等级：\(equip.maxStrengthLevel/2)/\(equip.maxStrengthLevel)")
                        .foregroundColor(.theme.strength)
                }
            }
            HStack {
                Text(equip.subType.name)
                Spacer()
                if equip.isWepaon {
                    Text(equip.detailType)
                }
            }
            .foregroundColor(.white)
        }
    }
    
    // MARK: 武器伤害
    @ViewBuilder
    private var baseInfoView: some View {
        if equip.isWepaon {
            if let base3Type = equip.baseTypes[2] {
                HStack(spacing: 0) {
                    Text(base3Type.weaponDecs + " \(String(equip.attackBase))")
                    if base3Type.isRand || base3Type.isSpeed {
                        Text(" - \(String(equip.attackBase + equip.attackRange))")
                    }
                    Spacer()
                    if base3Type.isSpeed {
                        Text("速度 \(String(format:"%.1f", equip.attackSpeed))")
                    }
                }
                if base3Type.isSpeed {
                    let apsDesc = "每秒伤害 \(String(format: "%.1f", Double(equip.attackBase + equip.attackRange / 2) / equip.attackSpeed).replacingOccurrences(of: "\\.0$", with: "", options: .regularExpression))"
                    HStack {
                        Text(apsDesc)
                        Spacer()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var magicInfoView: some View {
        ForEach(equip.magicTypes) { magic in
            HStack(spacing: 0) {
                if magic.label.isEmpty {
                    if magic.isPrimaryAttr {
                        Text(magic.briefDesc)
                            .foregroundColor(.white)
                            .bold()
                    } else {
                        Text(magic.attrDesc)
                            .bold()
                            .foregroundColor(.theme.textGreen)
                    }
                    Text(" (+\(magic.score(level: equip.maxStrengthLevel / 2, maxLevel: equip.maxStrengthLevel)))")
                        .bold()
                        .foregroundColor(.theme.strength)
                } else {
                    JX3GameText(text: magic.label, color: EquipQuality._5.color)
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var embedding: some View {
        ForEach(0..<diamondAttributeCount, id: \.self) { index in
            let da = equip.diamondAttributes[index]
            let level = diamondAttributeLevels[index]
            HStack(spacing: 8) {
                Image("Embedding\(level)")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("镶嵌孔：\(da.label) \(Int(da.embedValue(level: level)))")
                    .foregroundColor(.theme.textGreen)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    var requireTypeView: some View {
        if let requireLevel = equip.requireLevel {
            Text("需求等级 \(requireLevel)")
        }
        if let requireSchool = equip.requireSchool {
            Text("需要门派 \(requireSchool.name ?? "")")
        }
        if let requireGender = equip.requireGender {
            Text("仅 \(requireGender ? "男性" : "女性") 可穿戴")
        }
        if let camp = equip.requireCamp {
            Text("需要 \(camp)")
        }
    }
}

struct EquipDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EquipDetailView(equip: dev.weapon1)
    }
}

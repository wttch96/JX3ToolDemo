//
//  EquipDetailView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/21.
//

import SwiftUI

struct EquipDetailView: View {
    let equip: EquipDTO
    let strengthLevel: Int
    let diamondAttributeLevels: [DiamondAttribute: Int]
    let enhance: Enchant?
    let enchant: Enchant?
    
    init(equip: EquipDTO, strengthLevel: Int, diamondAttributeLevels: [DiamondAttribute : Int], enhance: Enchant?, enchant: Enchant?) {
        self.equip = equip
        self.strengthLevel = strengthLevel
        self.diamondAttributeLevels = diamondAttributeLevels
        self.enhance = enhance
        self.enchant = enchant
    }
    
    init(strengthEquip: StrengthEquip) {
        self.init(equip: strengthEquip.equip, strengthLevel: strengthEquip.strengthLevel, diamondAttributeLevels: strengthEquip.embeddingStone, enhance: strengthEquip.enchance, enchant: strengthEquip.enchant)
    }

    // 图标大小
    private let iconSize: CGFloat = 16
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            header
            baseInfoView
            magicInfoView
            embedding
            
            requireTypeView
            
            if let maxDurability = equip.maxDurability, maxDurability != "0" {
                Text("耐久度：\(maxDurability)/\(maxDurability)")
            }
            
            // 小附魔
            HStack(spacing: 4) {
                Image("Enhance\(enhance == nil ? "None" : "")")
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                Text(enhance?.attriName ?? "未强化")
                    .foregroundColor(enhance?.attriName == nil ? .gray : .blue)
            }
            HStack(alignment: .top, spacing: 4) {
                Image("Enchant\(enchant == nil ? "None" : "")")
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                if let attriName = enchant?.boxAttriName {
                    JX3GameText(text: attriName, color: EquipQuality._4.color)
                } else {
                    Text("未强化")
                        .foregroundColor(.gray)
                }
            }
            
            HStack(spacing: 0) {
                Text("品质等级：\(equip.level)")
                    .foregroundColor(.yellow)
                Text("(+\(equip.strengthLevelScore(strengthLevel: strengthLevel)))")
                    .foregroundColor(.theme.strength)
            }
            HStack(spacing: 0) {
                Text("装备分数：\(equip.equipScore)")
                    .foregroundColor(EquipQuality._5.color)
                Text("(+\(equip.strengthLevelScore(strengthLevel: strengthLevel)))")
                    .foregroundColor(.theme.strength)
            }
            
//            if let getType = equip.getType {
//                Text("装备来源：\(getType)")
//            }
        }
        .foregroundColor(.white)
        .font(.headline)
        .padding()
        .background(Color.theme.panel)
        .navigationTitle(equip.name)
    }
    
    // MARK: 头部
    private var header: some View {
        VStack(spacing: 8) {
            HStack {
                Text(equip.name)
                    .foregroundColor(equip.quality.color)
                    .bold()
                HStack(spacing: 0) {
                    if equip.maxStrengthLevel >= 1 {
                        ForEach(1 ... equip.maxStrengthLevel, id: \.self) { l in
                            if l <= strengthLevel {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            } else {
                                Image(systemName: "star")
                            }
                        }
                    }
                }
                .font(.caption)
                
                Spacer()
                Text("精炼等级：\(strengthLevel)/\(equip.maxStrengthLevel)")
                    .foregroundColor(.theme.strength)
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
            HStack(spacing: 0) {
                if let weaponBase = equip.weaponBase {
                    // 攻击力
                    Text(weaponBase.weaponDecs + " \(weaponBase.baseMin)")
                    if let weaponRand = equip.weaponRand {
                        // 攻击距离
                        Text(" - \(String(weaponBase.baseMin + weaponRand.baseMin))")
                        if let weaponSpeed = equip.weaponSpeed {
                            // 攻速
                            Spacer()
                            Text("速度 \(String(format:"%.1f", Double(weaponSpeed.baseMin) / 16))")
                        }
                    }
                }
            }
            if let weaponBase = equip.weaponBase, let weaponRand = equip.weaponRand, let weaponSpeed = equip.weaponSpeed {
                let attackSpeed = Double(weaponSpeed.baseMin) / 16
                let apsDesc = "每秒伤害 \(String(format: "%.1f", Double(weaponBase.baseMin + weaponRand.baseMin / 2) / attackSpeed).replacingOccurrences(of: "\\.0$", with: "", options: .regularExpression))"
                HStack {
                    Text(apsDesc)
                    Spacer()
                }
            }
            // else 没有攻击属性
        } else {
            ForEach(equip.baseTypes) { type in
                Text(type.labelDesc)
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
                    } else {
                        Text(magic.attrDesc)
                            .foregroundColor(.theme.textGreen)
                    }
                    Text(" (+\(magic.score(level: strengthLevel, maxLevel: equip.maxStrengthLevel)))")
                        .foregroundColor(.theme.strength)
                } else {
                    JX3GameText(text: magic.label, color: EquipQuality._5.color)
                }
                Spacer()
            }
        }
    }
    
    // MARK: 五行石镶嵌
    @ViewBuilder
    private var embedding: some View {
        ForEach(equip.diamondAttributes) { attr in
            HStack(spacing: 4) {
                let level = diamondAttributeLevels[attr, default: 0]
                if level == 0 {
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundColor(.gray)
                } else {
                    Image("Embedding\(level)")
                        .resizable()
                        .frame(width: iconSize, height: iconSize)
                }
                Text("镶嵌孔：\(attr.label) \(Int(attr.embedValue(level: diamondAttributeLevels[attr] ?? 0)))")
                    .foregroundColor( diamondAttributeLevels[attr, default: 0] == 0 ? .gray : .theme.textGreen)
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
        EquipDetailView(equip: dev.weapon1, strengthLevel: 6, diamondAttributeLevels: [:], enhance: nil, enchant: nil)
        EquipDetailView(equip: dev.equip1, strengthLevel: 6, diamondAttributeLevels: [:], enhance: dev.enchant1, enchant: nil)
    }
}

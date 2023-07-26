//
//  EquipDetailView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/21.
//

import SwiftUI

struct EquipDetailView: View {
    // 一定要用 ObservedObject 不然不会刷新子视图
    @ObservedObject private var strengthEquip: StrengthedEquip
    
    @StateObject private var equipSetVm = EquipSetViewModel()
    
    @available(*, deprecated, message: "弃用")
    init(equip: EquipDTO, strengthLevel: Int, diamondAttributeLevels: [DiamondAttribute : Int], enhance: Enchant?, enchant: Enchant?) {
        self.strengthEquip = StrengthedEquip()
    }
    
    init(strengthEquip: StrengthedEquip) {
        self.strengthEquip = strengthEquip
    }

    // 图标大小
    private let iconSize: CGFloat = 16
    
    var equip: EquipDTO { return strengthEquip.equip! }
    var enchance: Enchant? { return strengthEquip.enchance }
    var enchant: Enchant? { return strengthEquip.enchant }
    var diamondAttributeLevels: [DiamondAttribute: Int] { return strengthEquip.embeddingStone }
    
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
            
            // 大小附魔
            enchantView
            
            // 套装
            equipSetView
            
            HStack(spacing: 0) {
                Text("品质等级：\(equip.level)")
                    .foregroundColor(.yellow)
                Text("(+\(equip.strengthLevelScore(strengthLevel: strengthEquip.strengthLevel)))")
                    .foregroundColor(.theme.strength)
            }
            HStack(spacing: 0) {
                Text("装备分数：\(equip.equipScore)")
                    .foregroundColor(EquipQuality._5.color)
                Text("(+\(ScoreUtil.getGsStrengthScore(base: equip.equipScore, strengthLevel: strengthEquip.strengthLevel))+\(extraScore))")
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
        .onAppear {
            if let setId = strengthEquip.equip?.setId {
                equipSetVm.loadEquipSet(setId)
            }
        }
        .onChange(of: strengthEquip.equip) { newValue in
            if let setId = newValue?.setId {
                equipSetVm.loadEquipSet(setId)
            }
        }
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
                            if l <= strengthEquip.strengthLevel {
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
                Text("精炼等级：\(strengthEquip.strengthLevel)/\(equip.maxStrengthLevel)")
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
                    Text(" (+\(magic.score(level: strengthEquip.strengthLevel, maxLevel: equip.maxStrengthLevel)))")
                        .foregroundColor(.theme.strength)
                } else {
                    JX3GameText(text: magic.label, color: EquipQuality._5.color)
                }
                Spacer()
            }
        }
    }
    // MARK: 套装
    @ViewBuilder
    private var equipSetView: some View {
        VStack(alignment: .leading) {
            if let equipSet = equipSetVm.set {
                let activeCount = 0
                Text("\(equipSet.name ?? "未知套")(\(activeCount)/\(equipSetVm.setList.count))")
                    .foregroundColor(.yellow)
                
                ForEach(equipSetVm.setList, content: { item in
                    Text(item.name ?? "未知装备")
                })
            }
        }
        .padding(.vertical)
    }
    
    // MARK: 大小附魔
    @ViewBuilder
    private var enchantView: some View {
        // 小附魔
        HStack(spacing: 4) {
            Image("Enhance\(enchance == nil ? "None" : "")")
                .resizable()
                .frame(width: iconSize, height: iconSize)
            Text(enchance?.attriName ?? "未强化")
                .foregroundColor(enchance?.attriName == nil ? .gray : .blue)
        }
        HStack(alignment: .top, spacing: 4) {
            if let attriName = enchant?.boxAttriName {
                Image("Enchant")
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                JX3GameText(text: attriName, color: EquipQuality._4.color)
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

extension EquipDetailView {
    var extraScore: Int {
        // 五行石分数 + 五彩石分数 + 小附魔分数 + 大附魔分数
        return ScoreUtil.stoneScore(diamondAttributeLevels) + 0 + (enchance?.score ?? 0) + (enchant?.score ?? 0)
    }
}

struct EquipDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EquipDetailView(equip: dev.weapon1, strengthLevel: 6, diamondAttributeLevels: [:], enhance: nil, enchant: nil)
        EquipDetailView(equip: dev.equip1, strengthLevel: 6, diamondAttributeLevels: [:], enhance: dev.enchant1, enchant: nil)
    }
}

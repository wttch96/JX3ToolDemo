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

    init(equip: EquipDTO) {
        self.equip = equip
        self.diamondAttributeLevels = Array(repeating: 6, count: equip.diamondAttributes.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            baseInfoView
            magicInfoView
            
            VStack(alignment: .leading) {
                ForEach(equip.diamondAttributes) { da in
                    Text("[6]镶嵌孔：\(da.label) \(Int(da.embedValue(level: 6)))")
                        .foregroundColor(.theme.textGreen)
                }
            }
            
            
            Spacer()
        }
        .padding()
        .background(Color.theme.panel)
    }
    
    // MARK: 头部
    private var header: some View {
        VStack(spacing: 8) {
            HStack {
                Text(equip.name)
                    .foregroundColor(equip.quality.color)
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
            .font(.title2)
        }
        .font(.title3)
    }
    
    // MARK: 武器伤害
    private var baseInfoView: some View {
        var attackBase: Int = 0
        var attackRange: Int = 0
        var attackSpeed: Double = 0
        if let base3Type = equip.baseTypes[2] {
            if base3Type.isBase {
                attackBase = base3Type.baseMin
            } else if base3Type.isRand, let base2Type = equip.baseTypes[1] {
                attackBase = base2Type.baseMin
                attackRange = base3Type.baseMin
            } else if base3Type.isSpeed, let base1Type = equip.baseTypes[0], let base2Type = equip.baseTypes[1] {
                attackBase = base1Type.baseMin
                attackRange = base2Type.baseMin
                attackSpeed = Double(base3Type.baseMin) / 16
            }
        }
        return VStack {
            if equip.isWepaon {
                if let base3Type = equip.baseTypes[2] {
                    HStack(spacing: 0) {
                        Text(base3Type.weaponDecs + " \(String(attackBase))")
                        if base3Type.isRand || base3Type.isSpeed {
                            Text(" - \(String(attackBase + attackRange))")
                        }
                        Spacer()
                        if base3Type.isSpeed {
                            Text("速度 \(String(format:"%.1f", attackSpeed))")
                        }
                    }
                    if base3Type.isSpeed {
                        let apsDesc = "每秒伤害 \(String(format: "%.1f", Double(attackBase + attackRange / 2) / attackSpeed).replacingOccurrences(of: "\\.0$", with: "", options: .regularExpression))"
                        HStack {
                            Text(apsDesc)
                            Spacer()
                        }
                    }
                }
            }
        }
        .foregroundColor(.white)
        .font(.headline)
    }
    
    private var magicInfoView: some View {
        VStack {
            ForEach(0..<equip.magicTypes.count, id: \.hashValue) { i in
                if let magic = equip.magicTypes[i] {
                    HStack(spacing: 0) {
                        if magic.label.isEmpty {
                            if i < 2 {
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
                            JX3GameText(text: magic.label, color: .theme.gold)
                        }
                        Spacer()
                    }
                }
            }
        }
        .font(.headline)
    }
}

struct EquipDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EquipDetailView(equip: dev.weapon1)
    }
}

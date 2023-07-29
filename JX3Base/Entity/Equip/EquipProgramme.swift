//
//  EquipProgramme.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/29.
//

import Foundation

// 配装方案
class EquipProgramme: ObservableObject {
    @Published var equips: [EquipPosition: StrengthedEquip] = [:]
}

extension EquipProgramme {
    // 配装方案总五行石数量
    var stoneCount: Int {
        return equips.values.reduce(into: 0) { partialResult, strengthedEquip in
            partialResult += strengthedEquip.embeddingStone.count
        }
    }
    // 配装方案总五行石等级
    var stoneTotalLevel: Int {
        return equips.values.reduce(into: 0) { partialResult, strengthedEquip in
            let totalLevel = strengthedEquip.embeddingStone.values.reduce(into: 0) { partialResult, level in
                partialResult += level
            }
            partialResult += totalLevel
        }
    }
    
    // 判断五彩石属性是否激活
    func actived(_ attr: ColorStoneAttribute) -> Bool {
        return stoneCount >= Int(attr.diamondCount) ?? 0 && stoneTotalLevel >= Int(attr.diamondIntensity) ?? 0
    }
}

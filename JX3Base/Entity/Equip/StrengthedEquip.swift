//
//  StrengthedEquip.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/22.
//

import Foundation

class StrengthedEquip: ObservableObject {
    @Published var equip: Equip? = nil {
        didSet {
            if let equip = equip {
                self.embeddingStone =  equip.diamondAttributes.reduce(into: [:] as [DiamondAttribute: Int], { partialResult, attr in
                        partialResult[attr] = 6
                    }
                )
                self.strengthLevel = equip.maxStrengthLevel
            } else {
                self.embeddingStone = [:]
                self.strengthLevel = 0
            }
            self.enchant = nil
            self.enchance = nil
            self.colorStone = nil
        }
    }
    // 强化等级
    @Published var strengthLevel: Int = 0
    // 五行石镶嵌
    @Published var embeddingStone: [DiamondAttribute: Int] = [:]
    // 小附魔
    @Published var enchance: Enchant? = nil
    // 大附魔
    @Published var enchant: Enchant? = nil
    // 五彩石
    @Published var colorStone: ColorStone? = nil
    
    func toDAO() -> StrengthedEquipDAO {
        return StrengthedEquipDAO(equip: equip, strengthLevel: strengthLevel, embeddingStone: embeddingStone, enchance: enchance, enchant: enchant, colorStone: colorStone)
    }
}

struct StrengthedEquipDAO: Codable {
    let equip: Equip?
    let strengthLevel: Int
    let embeddingStone: [DiamondAttribute: Int]
    let enchance: Enchant?
    let enchant: Enchant?
    let colorStone: ColorStone?
}

extension StrengthedEquip: Equatable {
    static func ==(lhs: StrengthedEquip, rhs: StrengthedEquip) -> Bool {
        return lhs.equip == rhs.equip
        && lhs.strengthLevel == rhs.strengthLevel
        && lhs.embeddingStone == rhs.embeddingStone
        && lhs.enchance == rhs.enchance
        && lhs.enchant == rhs.enchant
        && lhs.colorStone == rhs.colorStone
    }
    
    
    var totalScore: Int {
        return (equip?.equipScore ?? 0) + strengthScore + extraScore
    }
    
    /// 精炼装分
    var strengthScore: Int {
        if let equip = self.equip {
            return ScoreUtil.getGsStrengthScore(base: equip.equipScore, strengthLevel: strengthLevel)
        }
        return 0
    }
    
    /// 扩展分数
    var extraScore: Int {
        if let _ = self.equip {
            // 五行石分数 + 五彩石分数 + 小附魔分数 + 大附魔分数
            return ScoreUtil.stoneScore(embeddingStone) + ScoreUtil.colorStoneScore(colorStone) + (enchance?.score ?? 0) + (enchant?.score ?? 0)
        }
        return 0
    }
}

//
//  StrengthEquip.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/18.
//

import Foundation

struct StrengthEquip {
    let equip: EquipDTO
    // 强化等级
    let strengthLevel: Int
    // 五行石镶嵌
    let embeddingStone: [DiamondAttribute: Int]
    // 小附魔
    let enchance: Enchant?
    // 大附魔
    let enchant: Enchant?
    
    
    init(equip: EquipDTO) {
        self.equip = equip
        self.strengthLevel = 0
        self.embeddingStone = [:]
        self.enchant = nil
        self.enchance = nil
    }
    
    init(equip: EquipDTO, strengthLevel: Int, embeddingStone: [DiamondAttribute : Int], enchance: Enchant?, enchant: Enchant?) {
        self.equip = equip
        self.strengthLevel = strengthLevel
        self.embeddingStone = embeddingStone
        self.enchance = enchance
        self.enchant = enchant
    }
    
    func strengthLevel(_ level: Int) -> StrengthEquip {
        return StrengthEquip(equip: self.equip, strengthLevel: level, embeddingStone: self.embeddingStone, enchance: self.enchance, enchant: self.enchant)
    }
    
    func embeddingStone(_ stones: [DiamondAttribute: Int]) -> StrengthEquip {
        return StrengthEquip(equip: self.equip, strengthLevel: self.strengthLevel, embeddingStone: stones, enchance: self.enchance, enchant: self.enchant)
    }
    
    func enchant(_ enchant: Enchant?) -> StrengthEquip {
        return StrengthEquip(equip: self.equip, strengthLevel: self.strengthLevel, embeddingStone: self.embeddingStone, enchance: self.enchance, enchant: enchant)
    }
    
    func enchance(_ enchance: Enchant?) -> StrengthEquip {
        return StrengthEquip(equip: self.equip, strengthLevel: self.strengthLevel, embeddingStone: self.embeddingStone, enchance: enchance, enchant: self.enchant)
    }
}


extension StrengthEquip: Equatable {
    
    static func ==(lhs: StrengthEquip, rhs: StrengthEquip) -> Bool {
        return lhs.equip.id == rhs.equip.id
    }
    
    // 五行石分数
    var stoneScore: Int {
        return ScoreUtil.stoneScore(embeddingStone)
    }
    
    var enchanceScore: Int {
        return enchance?.score ?? 0
    }
    
    var enchantScore: Int {
        return enchant?.score ?? 0
    }
}

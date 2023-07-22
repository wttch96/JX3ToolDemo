//
//  StrengthedEquip.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/22.
//

import Foundation

class StrengthedEquip: ObservableObject {
    @Published var equip: EquipDTO? = nil {
        didSet {
            if let equip = equip {
                self.embeddingStone =  equip.diamondAttributes.reduce(into: [:] as [DiamondAttribute: Int], { partialResult, attr in
                        partialResult[attr] = 6
                    }
                )
            } else {
                self.embeddingStone = [:]
            }
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
}

//
//  StrengthedEquip.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/22.
//

import Foundation

// MARK: ViewModel
/// 强化的装备，用于 View 已继承 ObservableObject。
class StrengthedEquipViewModel: ObservableObject {
    /// 原始装备信息
    @Published var equip: Equip? = nil {
        didSet {
            // 修改装备时:
            if let equip = equip {
                // 初始化五行石镶嵌，默认为6级
                self.embeddingStone =  equip.diamondAttributes.reduce(into: [:] as [DiamondAttribute: Int], { partialResult, attr in
                        partialResult[attr] = 6
                    }
                )
                // 初始化强化等级为最大强化等级
                self.strengthLevel = equip.maxStrengthLevel
            } else {
                self.embeddingStone = [:]
                self.strengthLevel = 0
            }
            // 强化和五彩石置空
            self.enchant = nil
            self.enchance = nil
            self.colorStone = nil
        }
    }
    /// 强化等级
    @Published var strengthLevel: Int = 0
    /// 五行石镶嵌，属性对应其五行石等级
    @Published var embeddingStone: [DiamondAttribute: Int] = [:]
    /// 小附魔
    @Published var enchance: Enchant? = nil
    /// 大附魔
    @Published var enchant: Enchant? = nil
    /// 五彩石
    @Published var colorStone: ColorStone? = nil
    
    /// 将实体转换为 实现 Codable 的实体类型对象
    /// - Returns: 实现 codable 可以序列化的对象
    func toEntity() -> StrengthedEquip {
        return StrengthedEquip(equip: equip, strengthLevel: strengthLevel, embeddingStone: embeddingStone, enchance: enchance, enchant: enchant, colorStone: colorStone)
    }
}

extension StrengthedEquipViewModel: Equatable {
    static func ==(lhs: StrengthedEquipViewModel, rhs: StrengthedEquipViewModel) -> Bool {
        return lhs.equip == rhs.equip
        && lhs.strengthLevel == rhs.strengthLevel
        && lhs.embeddingStone == rhs.embeddingStone
        && lhs.enchance == rhs.enchance
        && lhs.enchant == rhs.enchant
        && lhs.colorStone == rhs.colorStone
    }
    
    /// 获取装备的总装分
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
    
    /// 扩展分数:  五行石分数 + 五彩石分数 + 小附魔分数 + 大附魔分数
    var extraScore: Int {
        if let _ = self.equip {
            // 五行石分数 + 五彩石分数 + 小附魔分数 + 大附魔分数
            return ScoreUtil.stoneScore(embeddingStone) + ScoreUtil.colorStoneScore(colorStone) + (enchance?.score ?? 0) + (enchant?.score ?? 0)
        }
        return 0
    }
}

// MARK: 实体

/// 已强化装备实体
struct StrengthedEquip: Codable {
    /// 装备
    let equip: Equip?
    /// 强化等级
    let strengthLevel: Int
    /// 五行石镶嵌
    let embeddingStone: [DiamondAttribute: Int]
    /// 小附魔
    let enchance: Enchant?
    /// 大附魔
    let enchant: Enchant?
    /// 五彩石
    let colorStone: ColorStone?
}

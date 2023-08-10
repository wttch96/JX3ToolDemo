//
//  PanelAttributeType.swift
//  JX3Demo
//
//  Created by Wttch on 2023/8/10.
//

import Foundation

struct PanelAttributeGroup: Identifiable, Decodable {
    let title: String
    let child: [PanelAttributeRow]
    
    var id: String {
        return title
    }
}

struct PanelAttributeRow: Identifiable, Decodable {
    let header: PanelAttribute
    let child: [[PanelAttribute]]
    
    var id: String {
        return header.id
    }
}

struct PanelAttribute: Identifiable, Decodable {
    let type: PannelAttributeType
    let desc: String
    let isPercent: Bool
    
    init(_ type: PannelAttributeType, desc: String, isPercent: Bool = false) {
        self.type = type
        self.desc = desc
        self.isPercent = isPercent
    }
    
    var id: String {
        return type.id
    }
}

/// 属性
enum PannelAttributeType: String, Identifiable, Decodable {
    // MARK: 基础
    /// 体质
    case vitality = "Vitality"
    /// 体质气血值提升
    case vitalityToHealth = "VitalityToHealth"
    /// 基础气血最大值
    case vitalityToMaxHealth = "VitalityToMaxHealth"
    /// 最终气血最大值
    case vitalityToFinalMaxHealth = "VitalityToFinalMaxHealth"

    /// 根骨
    case spirit = "Spirit"
    case spiritToMagicCriticalStrike = "SpiritToMagicCriticalStrike"
    
    /// 力道
    case strength = "Strength"
    case strengthToAttack = "StrengthToAttack"
    case strengthToOvercome = "StrengthToOvercome"
    
    /// 身法
    case agility = "Agility"
    case agilityToCriticalStrike = "AgilityToCriticalStrike"
    
    /// 元气
    case spunk = "Spunk"
    case spunkToAttack = "SpunkToAttack"
    case spunkToOvercome = "SpunkToOvercome"
    
    // MARK: 伤害
    case attack = "Attack"
    case physicsAttack = "PhysicsAttack"
    case physicsFinalAttack = "PhysicsFinalAttack"
    case lunarAttack = "LunarAttack"
    case lunarFinalAttack = "LunarFinalAttack"
    case solarAttack = "SolarAttack"
    case solarFinalAttack = "SolarFinalAttack"
    case neutralAttack = "NeutralAttack"
    case neutralFinalAttack = "NeutralFinalAttack"
    case poisonAttack = "PoisonAttack"
    case poisonFinalAttack = "PoisonFinalAttack"
    
    var id: String {
        return self.rawValue
    }
    
    init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        if let type = PannelAttributeType.init(rawValue: rawValue) {
            self = type
        } else {
            fatalError("初始化 PanelAttributeType.json 错误")
        }
    }
}

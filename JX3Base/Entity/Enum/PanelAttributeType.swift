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
    // 治疗量
    case therapy = "Therapy"
    case therapyBase = "TherapyBase"
    // MARK: 会心
    case CriticalStrike
    case CriticalStrikeRate
    case PhysicsCriticalStrike
    case PhysicsCriticalStrikeRate
    case LunarCriticalStrike
    case LunarCriticalStrikeRate
    case SolarCriticalStrike
    case SolarCriticalStrikeRate
    case NeutralCriticalStrike
    case NeutralCriticalStrikeRate
    case PoisonCriticalStrike
    case PoisonCriticalStrikeRate
    // MARK: 会效
    case CriticalDamagePower
    case CriticalDamagePowerPercent
    case PhysicsCriticalDamagePower
    case PhysicsCriticalDamagePowerPercent
    case LunarCriticalDamagePower
    case LunarCriticalDamagePowerPercent
    case SolarCriticalDamagePower
    case SolarCriticalDamagePowerPercent
    case NeutralCriticalDamagePower
    case NeutralCriticalDamagePowerPercent
    case PoisonCriticalDamagePower
    case PoisonCriticalDamagePowerPercent
    // MARK: 破防
    case OvercomePercent
    case PhysicsOvercome
    case PhysicsOvercomePercent
    case LunarOvercome
    case LunarOvercomePercent
    case SolarOvercome
    case SolarOvercomePercent
    case NeutralOvercome
    case NeutralOvercomePercent
    case PoisonOvercome
    case PoisonOvercomePercent
    // MARK: 加速
    case Haste
    case HastePercent
    // MARK: 无双
    case Strain
    case StrainPercent
    // MARK: 破招
    case SurplusValue
    case SurplusValuePercent
    // MARK: 防御
    case PhysicsShieldBase
    case PhysicsShield
    case PhysicsShieldPercent
    // MARK: 内防
    case MagicShieldPercent
    case LunarMagicShieldBase
    case LunarMagicShield
    case LunarMagicShieldPercent
    case SolarMagicShieldBase
    case SolarMagicShield
    case SolarMagicShieldPercent
    case NeutralMagicShieldBase
    case NeutralMagicShield
    case NeutralMagicShieldPercent
    case PoisonMagicShieldBase
    case PoisonMagicShield
    case PoisonMagicShieldPercent
    
    
    
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

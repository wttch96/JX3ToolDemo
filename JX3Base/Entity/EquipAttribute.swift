//
//  EquipAttribute.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import Foundation

//    "Surplus": "破招",
//    "Strain": "无双",
//    "Haste": "加速",
//    "Critical": "会心",
//    "CriticalDamage": "会效",
//    "Overcome": "破防",
//    "Hit": "命中",
//    "PhysicsShield": "外防",
//    "MagicShield": "内防",
//    "Dodge": "闪避",
//    "Parry": "招架",
//    "Toughness": "御劲",
//    "Decritical": "化劲"
enum EquipAttribute: String, CaseIterable {
    case surplus = "Surplus"
    case strain = "Strain"
    case haste = "Haste"
    case critical = "Critical"
    case criticalDamage = "CriticalDamage"
    case overcome = "Overcome"
    case hit = "Hit"
    case physicsShield = "PhysicsShield"
    case magicShield = "MagicShield"
    case dodge = "Dodge"
    case parry = "Parry"
    case toughness = "Toughness"
    case decritical = "Decritical"
}

extension EquipAttribute: Decodable {
    var label: String {
        switch self {
        case .surplus: return "破招"
        case .strain: return "无双"
        case .haste: return "加速"
        case .critical: return "会心"
        case .criticalDamage: return "会效"
        case .overcome: return "破防"
        case .hit: return "命中"
        case .physicsShield: return "外防"
        case .magicShield: return "内防"
        case .dodge: return "闪避"
        case .parry: return "招架"
        case .toughness: return "御劲"
        case .decritical: return "化劲"
        }
    }
}


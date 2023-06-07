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
    case hasts = "Haste"
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
    
}


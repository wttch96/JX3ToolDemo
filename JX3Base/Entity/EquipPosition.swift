//
//  EquipPosition.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import Foundation

//    HELM: EquipType.HELM,                   // 帽子
//    CHEST: EquipType.CHEST,                 // 上衣
//    WAIST: EquipType.WAIST,                 // 腰带
//    BANGLE: EquipType.BANGLE,               // 护腕
//    PANTS: EquipType.PANTS,                 // 下装
//    BOOTS: EquipType.BOOTS,                 // 鞋子
//    AMULET: EquipType.AMULET,               // 项链
//    PENDANT: EquipType.PENDANT,             // 腰坠
//    RING_1: `${EquipType.RING}_1`,          // 戒指1
//    RING_2: `${EquipType.RING}_2`,          // 戒指2
//    MELEE_WEAPON: EquipType.MELEE_WEAPON,   // 近身武器
//    RANGE_WEAPON: EquipType.RANGE_WEAPON,   // 远程武器
enum EquipPosition: String, CaseIterable {
    case helm
    case chest
    case waist
    case bangle
    case pants
    case boots
    case amulet
    case pendant
    case ring1 = "ring_1"
    case ring2 = "ring_2"
    // 近身武器
    case meleeWeapon = "melee_weapon"
    // 重剑
    case meleeWeapon2 = "melee_weapon2"
    // 远程武器
    case rangeWeapon = "range_weapon"
}

extension EquipPosition {
    var type: EquipType {
        switch self {
        case .helm: return .helm
        case .chest: return .chest
        case .waist: return .waist
        case .bangle: return .bangle
        case .pants: return .pants
        case .boots: return .boots
        case .amulet: return .amulet
        case .pendant: return .pendant
        case .ring1: return .ring
        case .ring2: return .ring
        case .meleeWeapon: return .meleeWeapon
        case .meleeWeapon2: return .meleeWeapon
        case .rangeWeapon: return .rangeWeapon
        }
    }
    
    var label: String {
        return self == .meleeWeapon2 ? "重剑" : type.label
    }
    
    var aucGenre: Int {
        switch self {
        case .meleeWeapon: return 1
        case .meleeWeapon2: return 1
        case .rangeWeapon: return 2
        case .helm: return 3
        case .chest: return 3
        case .waist: return 3
        case .bangle: return 3
        case .pants: return 3
        case .boots: return 3
        case .amulet: return 4
        case .pendant: return 4
        case .ring1: return 4
        case .ring2: return 4
        }
    }
    var aucSubGenre: Int {
        switch self {
        case .meleeWeapon: return -1
        case .meleeWeapon2: return -1
        case .rangeWeapon: return -1
        case .helm: return 2
        case .chest: return 1
        case .waist: return 3
        case .bangle: return 6
        case .pants: return 4
        case .boots: return 5
        case .amulet: return 1
        case .pendant: return 3
        case .ring1: return 2
        case .ring2: return 2
        }
    }
}

//
//  EquipType.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import Foundation

//    HELM: 'helm',                   // 帽子
//    CHEST: 'chest',                 // 上衣
//    WAIST: 'waist',                 // 腰带
//    BANGLE: 'bangle',               // 护腕
//    PANTS: 'pants',                 // 下装
//    BOOTS: 'boots',                 // 鞋子
//    AMULET: 'amulet',               // 项链
//    PENDANT: 'pendant',             // 腰坠
//    RING: 'ring',                   // 戒指
//    MELEE_WEAPON: 'melee_weapon',   // 近身武器
//    RANGE_WEAPON: 'range_weapon',   // 远程武器
//    AMMO_POUCH: 'ammo_pouch',       // 暗器弹药
enum EquipType: String, CaseIterable {
    // 帽子
    case helm
    // 上衣
    case chest
    // 腰带
    case waist
    // 护腕
    case bangle
    // 下装
    case pants
    // 鞋子
    case boots
    // 项链
    case amulet
    // 腰坠
    case pendant
    // 戒指
    case ring
    // 近身武器
    case meleeWeapon = "melee_weapon"
    // 远程武器
    case rangeWeapon = "range_weapon"
    //暗器弹药
    case ammoPouch = "ammo_pouch"
}

extension EquipType {
    var label: String {
        switch self {
        case .helm: return "帽子"
        case .chest: return "上衣"
        case .waist: return "腰带"
        case .bangle: return "护腕"
        case .pants: return "下装"
        case .boots: return "鞋子"
        case .amulet: return "项链"
        case .pendant: return "腰坠"
        case .ring: return "戒指"
        case .meleeWeapon: return "近身武器"
        case .rangeWeapon: return "远程武器"
        case .ammoPouch: return "弹药"
        }
    }
    
}

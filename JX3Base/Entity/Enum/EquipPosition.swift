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
enum EquipPosition: String, CaseIterable, Codable {
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
    
    var value: Int {
        switch self {
        case .helm: return 3
        case .chest: return 2
        case .waist: return 6
        case .bangle: return 10
        case .pants: return 8
        case .boots: return 9
        case .amulet: return 4
        case .pendant: return 7
        case .ring1: return 5
        case .ring2: return 5
        case .meleeWeapon: return 0
        case .meleeWeapon2: return 0
        case .rangeWeapon: return 1
        }
    }
    
    var label: String {
        return self == .meleeWeapon2 ? "\(type.label)(重兵)" : type.label
    }
    
    var remark: String {
        switch self {
        case .helm: return "头部"
        case .chest: return label
        case .waist: return label
        case .bangle: return "护手"
        case .pants: return "裤子"
        case .boots: return label
        case .amulet: return label
        case .pendant: return label
        case .ring1: return "\(label)1"
        case .ring2: return "\(label)2"
        case .meleeWeapon: return "主武器"
        case .meleeWeapon2: return "副武器"
        case .rangeWeapon: return "暗器"
        }
    }
    
    var tabType: EquipPositionTabType {
        switch self {
        case .helm: fallthrough
        case .chest: fallthrough
        case .waist: fallthrough
        case .bangle: fallthrough
        case .pants: fallthrough
        case .boots: return .clothes
        case .amulet: fallthrough
        case .pendant: fallthrough
        case .ring1: fallthrough
        case .ring2: return .jewelry
        case .meleeWeapon: fallthrough
        case .meleeWeapon2: fallthrough
        case .rangeWeapon: return .weapon
        }
    }
    
    // 位置是否可以小附魔
    var haveEnhance: Bool {
        var enchanceMap: [ClientType: Bool] = [:]
        if self.type == .ring {
            enchanceMap = [.std: true, .origin: true]
        } else {
            enchanceMap = [.std: true, .origin: false]
        }
        
        return enchanceMap[.std, default: false]
    }
    
    // 位置是否可以大附魔
    var haveEnchant: Bool {
        var enchantMap: [ClientType: Bool] = [:]
        if self == .pants || self.tabType == .weapon {
            // 裤子或武器
            enchantMap = [.std: false, .origin: false]
        } else if self.tabType == .jewelry {
            // 饰品
            enchantMap = [.std: false, .origin: true]
        } else {
            enchantMap = [.std: true, .origin: false]
        }
        return enchantMap[.std, default: false]
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

enum EquipPositionTabType: Int {
    // 饰品
    case jewelry = 8
    // 衣服
    case clothes = 7
    // 武器
    case weapon = 6
}


//{
//    "HAT": {
//        "label": "帽子",
//        "remark": "头部",
//        "position": 3,
//        "type": "armor",
//        "tab_type": 7,
//        "enhance": {
//            "std": true,
//            "origin": false
//        },
//        "enchant": {
//            "std": true,
//            "origin": false
//        }
//    },
//    "JACKET": {
//        "label": "上衣",
//        "remark": "上衣",
//        "position": 2,
//        "type": "armor",
//        "tab_type": 7,
//        "enhance": {
//            "std": true,
//            "origin": false
//        },
//        "enchant": {
//            "std": true,
//            "origin": false
//        }
//    },
//    "BELT": {
//        "label": "腰带",
//        "remark": "腰带",
//        "position": 6,
//        "type": "armor",
//        "tab_type": 7,
//        "enhance": {
//            "std": true,
//            "origin": false
//        },
//        "enchant": {
//            "std": true,
//            "origin": false
//        }
//    },
//    "WRIST": {
//        "label": "护腕",
//        "remark": "护手",
//        "position": 10,
//        "type": "armor",
//        "tab_type": 7,
//        "enhance": {
//            "std": true,
//            "origin": false
//        },
//        "enchant": {
//            "std": true,
//            "origin": false
//        }
//    },
//    "BOTTOMS": {
//        "label": "下装",
//        "remark": "裤子",
//        "position": 8,
//        "type": "armor",
//        "tab_type": 7,
//        "enhance": {
//            "std": true,
//            "origin": false
//        },
//        "enchant": {
//            "std": false,
//            "origin": false
//        }
//    },
//    "SHOES": {
//        "label": "鞋子",
//        "remark": "鞋子",
//        "position": 9,
//        "type": "armor",
//        "tab_type": 7,
//        "enhance": {
//            "std": true,
//            "origin": false
//        },
//        "enchant": {
//            "std": true,
//            "origin": false
//        }
//    },
//    "NECKLACE": {
//        "label": "项链",
//        "remark": "项链",
//        "position": 4,
//        "type": "trinket",
//        "tab_type": 8,
//        "enhance": {
//            "std": true,
//            "origin": false
//        },
//        "enchant": {
//            "std": false,
//            "origin": true
//        }
//    },
//    "PENDANT": {
//        "label": "腰坠",
//        "remark": "腰坠",
//        "position": 7,
//        "type": "trinket",
//        "tab_type": 8,
//        "enhance": {
//            "std": true,
//            "origin": false
//        },
//        "enchant": {
//            "std": false,
//            "origin": true
//        }
//    },
//    "RING_1": {
//        "label": "戒指",
//        "remark": "戒指1",
//        "position": 5,
//        "type": "trinket",
//        "tab_type": 8,
//        "enhance": {
//            "std": true,
//            "origin": true
//        },
//        "enchant": {
//            "std": false,
//            "origin": true
//        }
//    },
//    "RING_2": {
//        "label": "戒指",
//        "remark": "戒指2",
//        "position": 5,
//        "type": "trinket",
//        "tab_type": 8,
//        "enhance": {
//            "std": true,
//            "origin": true
//        },
//        "enchant": {
//            "std": false,
//            "origin": true
//        }
//    },
//    "PRIMARY_WEAPON": {
//        "label": "近身武器",
//        "remark": "主武器",
//        "position": 0,
//        "type": "weapon",
//        "tab_type": 6,
//        "enhance": {
//            "std": true,
//            "origin": false
//        },
//        "enchant": {
//            "std": false,
//            "origin": false
//        }
//    },
//    "TERTIARY_WEAPON": {
//        "label": "近身武器（重兵）",
//        "remark": "副武器",
//        "position": 0,
//        "type": "weapon",
//        "tab_type": 6,
//        "enhance": {
//            "std": true,
//            "origin": false
//        },
//        "enchant": {
//            "std": false,
//            "origin": false
//        }
//    },
//    "SECONDARY_WEAPON": {
//        "label": "远程武器",
//        "remark": "暗器",
//        "position": 1,
//        "type": "weapon",
//        "tab_type": 6,
//        "enhance": {
//            "std": true,
//            "origin": false
//        },
//        "enchant": {
//            "std": false,
//            "origin": false
//        }
//    }
//}

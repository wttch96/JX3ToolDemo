//
//  PanelAttributeType.swift
//  JX3Demo
//
//  Created by Wttch on 2023/8/10.
//

import Foundation

struct PanelAttributeGroup: Identifiable {
    let title: String
    let child: [PanelAttributeRow]
    
    var id: String {
        return title
    }
    
    static let groups: [PanelAttributeGroup] = [
        PanelAttributeGroup(title: "基础", child: [.vitality, .spirit, .strength, .agility, .spunk]),
    ]
}

struct PanelAttributeRow: Identifiable {
    let header: PanelAttribute
    let child: [PanelAttribute]
    
    var id: String {
        return header.id
    }
    
    static let vitality = PanelAttributeRow(header: .vitality, child: [.vitalityToHealth, .vitalityMaxHealth, .vitalityFinalMaxHealth])
    static let spirit = PanelAttributeRow(header: .spirit, child: [.spiritToMagicCriticalStrike])
    static let strength = PanelAttributeRow(header: .strength, child: [.strengthToAttack, .strengthToOvercome])
    static let agility = PanelAttributeRow(header: .agility, child: [.agilityToCriticalStrike])
    static let spunk = PanelAttributeRow(header: .spunk, child: [.spunkToAttack, .spunkToOvercome])
}

struct PanelAttribute: Identifiable {
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
    
    static let vitality = PanelAttribute(.vitality, desc: "体质")
    static let vitalityToHealth = PanelAttribute(.vitalityToHealth, desc: "气血值提高")
    static let vitalityMaxHealth = PanelAttribute(.vitalityMaxHealth, desc: "基础气血最大值为")
    static let vitalityFinalMaxHealth = PanelAttribute(.vitalityFinalMaxHealth, desc: "最终气血最大值为")
    
    static let spirit = PanelAttribute(.spirit, desc: "根骨")
    static let spiritToMagicCriticalStrike = PanelAttribute(.spiritToMagicCriticalStrike, desc: "内功会心等级提高")
    
    static let strength = PanelAttribute(.strength, desc: "力道")
    static let strengthToAttack = PanelAttribute(.strengthToAttack, desc: "外功攻击提高")
    static let strengthToOvercome = PanelAttribute(.strengthToOvercome, desc: "外功破防提高")
    
    static let agility = PanelAttribute(.agility, desc: "身法")
    static let agilityToCriticalStrike = PanelAttribute(.agilityToCriticalStrike, desc: "外功会心等级提高")
    
    static let spunk = PanelAttribute(.spunk, desc: "元气")
    static let spunkToAttack = PanelAttribute(.spunkToAttack, desc: "内功攻击提高")
    static let spunkToOvercome = PanelAttribute(.spunkToOvercome, desc: "内功破防提高")
}

/// 属性
enum PannelAttributeType: String, Identifiable {
    /// 体质
    case vitality = "Vitality"
    /// 体质气血值提升
    case vitalityToHealth
    /// 基础气血最大值
    case vitalityMaxHealth
    /// 最终气血最大值
    case vitalityFinalMaxHealth

    /// 根骨
    case spirit = "Spirit"
    case spiritToMagicCriticalStrike
    
    /// 力道
    case strength = "Strength"
    case strengthToAttack
    case strengthToOvercome
    
    /// 身法
    case agility = "Agility"
    case agilityToCriticalStrike
    
    /// 元气
    case spunk = "Spunk"
    case spunkToAttack
    case spunkToOvercome
    
    var id: String {
        return self.rawValue
    }
}

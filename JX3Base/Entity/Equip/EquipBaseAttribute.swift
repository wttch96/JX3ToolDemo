//
//  EquipBaseType.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/21.
//

import Foundation

/// 装备基础属性。
/// 例如：
/// "Base1Type": "atPhysicsShieldBase",
/// "Base1Min": "261",
/// "Base1Max": "261",
struct EquipBaseAttribute {
    /// 属性类型
    let type: String
    // 属性小值字符串
    private let baseMinValue: String
    // 属性大值字符串
    private let baseMaxValue: String
    
    init?(decoder: Decoder, index: Int) throws {
        let container = try decoder.container(keyedBy: CustomKey.self)
        if let rawValue = try container.decodeIfPresent(String.self, forKey: CustomKey(stringValue: "Base\(index)Type")),
           let baseMinValue = try container.decodeIfPresent(String.self, forKey: CustomKey(stringValue: "Base\(index)Min")),
           let baseMaxValue = try container.decodeIfPresent(String.self, forKey: CustomKey(stringValue: "Base\(index)Max")) {
            self.type = rawValue
            self.baseMinValue = baseMinValue
            self.baseMaxValue = baseMaxValue
        } else {
            return nil
        }
    }
}

extension EquipBaseAttribute: Identifiable, Codable {
    var id: String { return type }
    
    var baseMin: Int { Int(baseMinValue) ?? 0 }
    var baseMax: Int { Int(baseMaxValue) ?? 0 }
    
    var weaponDecs : String {
        return "\(isMelleWeaponSpeed ? "近身" : "远程")武器伤害提高 "
    }
    
    /// 是否为武器基础值属性
    var isWeaponBase : Bool {
        return ["atMeleeWeaponDamageBase","atRangeWeaponDamageBase"].contains(type)
    }
    /// 是否为武器攻击范围属性
    var isWeaponRand : Bool {
        return ["atMeleeWeaponDamageRand", "atRangeWeaponDamageRand"].contains(type)
    }
    /// 是否为武器攻击速度属性
    var isWeaponSpeed : Bool {
        return isMelleWeaponSpeed || isRandeWeaponSpeed
    }
    /// 是否为近战武器速度属性
    var isMelleWeaponSpeed : Bool {
        return "atMeleeWeaponAttackSpeedBase" == type
    }
    /// 是否为远程武器攻击速度属性
    var isRandeWeaponSpeed : Bool {
        return "atRangeWeaponAttackSpeedBase" == type
    }
    // 简要描述
    var labelDesc : String {
        return (AssetJsonDataManager.shared.attrDescMap[type, default: "nil"]) + "+\(baseMin)"
    }
    
}

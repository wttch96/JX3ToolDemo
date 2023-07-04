//
//  EquipBaseType.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/21.
//

import Foundation

struct EquipBaseType: Identifiable {
    let rawValue: String
    private let baseMinValue: String
    private let baseMaxValue: String
    
    init?(decoder: Decoder, index: Int) throws {
        let container = try decoder.container(keyedBy: CustomKey.self)
        if let rawValue = try container.decodeIfPresent(String.self, forKey: CustomKey(stringValue: "Base\(index)Type")),
           let baseMinValue = try container.decodeIfPresent(String.self, forKey: CustomKey(stringValue: "Base\(index)Min")),
           let baseMaxValue = try container.decodeIfPresent(String.self, forKey: CustomKey(stringValue: "Base\(index)Max")) {
            self.rawValue = rawValue
            self.baseMinValue = baseMinValue
            self.baseMaxValue = baseMaxValue
        } else {
            return nil
        }
    }
    
    var id: String {
        return rawValue
    }
}

extension EquipBaseType {
    var baseMin: Int { Int(baseMinValue) ?? 0 }
    var baseMax: Int { Int(baseMaxValue) ?? 0 }
    
    var weaponDecs : String {
        return "\(isMelleWeaponSpeed ? "近身" : "远程")武器伤害提高 "
    }
    
    var isBase : Bool {
        return ["atMeleeWeaponDamageBase","atRangeWeaponDamageBase"].contains(rawValue)
    }
    
    var isRand : Bool {
        return ["atMeleeWeaponDamageRand", "atRangeWeaponDamageRand"].contains(rawValue)
    }
    
    var isSpeed : Bool {
        return isMelleWeaponSpeed || isRandeWeaponSpeed
    }
    
    var isMelleWeaponSpeed : Bool {
        return "atMeleeWeaponAttackSpeedBase" == rawValue
    }
    
    var isRandeWeaponSpeed : Bool {
        return "atRangeWeaponAttackSpeedBase" == rawValue
    }
    // 简要描述
    var labelDesc : String {
        return (AssetJsonDataManager.shared.attrDescMap[rawValue, default: "nil"]) + "+\(baseMin)"
    }
    
}

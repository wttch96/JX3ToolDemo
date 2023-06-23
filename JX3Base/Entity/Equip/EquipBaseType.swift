//
//  EquipBaseType.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/21.
//

import Foundation

struct EquipBaseType {
    let rawValue: String?
    private let baseMinValue: String?
    private let baseMaxValue: String?
    
    init(decoder: Decoder, index: Int) throws {
        let container = try decoder.container(keyedBy: CustomKey.self)
        self.rawValue = try container.decodeIfPresent(String.self, forKey: CustomKey(stringValue: "Base\(index)Type"))
        self.baseMinValue = try container.decodeIfPresent(String.self, forKey: CustomKey(stringValue: "Base\(index)Min"))
        self.baseMaxValue = try container.decodeIfPresent(String.self, forKey: CustomKey(stringValue: "Base\(index)Max"))
    }
}

extension EquipBaseType {
    var label: String? { return rawValue }
    var baseMin: Int { baseMinValue.flatMap{ Int($0) } ?? 0 }
    var baseMax: Int { baseMinValue.flatMap{ Int($0) } ?? 0 }
    
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
}

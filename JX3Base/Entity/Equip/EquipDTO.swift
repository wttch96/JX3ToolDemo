//
//  EquipDTO.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/18.
//

import Foundation

//    "ID": 91372,
//    "Name": "无封护臂",
//    "UiID": "200584",
//    "RepresentID": "291",
//    "ColorID": "1",
//    "ColorID1": null,
//    "ColorID2": null,
//    "Genre": null,
//    "SubType": "10",
//    "DetailType": "0",
//    "Price": "949483",
//    "Level": 9100,
//    "BindType": "2",
//    "MaxDurability": "3360",
//    "AbradeRate": "716",
//    "MaxExistTime": null,
//    "MaxExistAmount": null,
//    "CanTrade": null,
//    "CanDestroy": null,
//    "SetID": null,
//    "ScriptName": null,
//    "Quality": "4",
//    "Base1Type": "atPhysicsShieldBase",
//    "Base1Min": "261",
//    "Base1Max": "261",
//    "Base2Type": "atMagicShield",
//    "Base2Min": "208",
//    "Base2Max": "208",
//    "Base3Type": "atInvalid",
//    "Base3Min": null,
//    "Base3Max": null,
//    "Base4Type": null,
//    "Base4Min": null,
//    "Base4Max": null,
//    "Base5Type": null,
//    "Base5Min": null,
//    "Base5Max": null,
//    "Base6Type": null,
//    "Base6Min": null,
//    "Base6Max": null,
//    "Require1Type": "5",
//    "Require1Value": "120",
//    "Require2Type": null,
//    "Require2Value": null,
//    "Require3Type": null,
//    "Require3Value": null,
//    "Require4Type": null,
//    "Require4Value": null,
//    "Require5Type": null,
//    "Require5Value": null,
//    "Require6Type": null,
//    "Require6Value": null,
//    "Magic1Type": "48085",
//    "Magic2Type": "55746",
//    "Magic3Type": "0",
//    "Magic4Type": "0",
//    "Magic5Type": "0",
//    "Magic6Type": "0",
//    "Magic7Type": "0",
//    "Magic8Type": "0",
//    "Magic9Type": "0",
//    "Magic10Type": "0",
//    "Magic11Type": "0",
//    "Magic12Type": "0",
//    "SkillID": null,
//    "SkillLevel": null,
//    "BelongSchool": "精简",
//    "MagicKind": "外功",
//    "MagicType": "攻击会心高级",
//    "GetType": "活动",
//    "_CATEGORY": null,
//    "CoolDownID": null,
//    "IconTag1": null,
//    "IconTag2": null,
//    "IsSpecialIcon": null,
//    "IsSpecialRepresent": null,
//    "IconID": null,
//    "CanSetColor": null,
//    "AucGenre": "3",
//    "AucSubType": "6",
//    "RequireCamp": "7",
//    "RequireProfessionID": null,
//    "RequireProfessionLevel": null,
//    "RequireProfessionBranch": null,
//    "PackageGenerType": null,
//    "PackageSubType": null,
//    "TargetType": null,
//    "EnchantRepresentID1": null,
//    "EnchantRepresentID2": null,
//    "EnchantRepresentID3": null,
//    "EnchantRepresentID4": null,
//    "ExistType": null,
//    "DiamondTypeMask1": "17",
//    "DiamondAttributeID1": "9481",
//    "DiamondTypeMask2": "17",
//    "DiamondAttributeID2": "223",
//    "DiamondTypeMask3": "0",
//    "DiamondAttributeID3": "0",
//    "EquipCoolDownID": null,
//    "RecommendID": "2",
//    "MaxStrengthLevel": "3",
//    "CanApart": "1",
//    "MapBanUseItemMask": null,
//    "IgnoreBindMask": "0",
//    "CanExterior": "0",
//    "BelongForceMask": "67108863",
//    "Represent1": null,
//    "SpecialRepair": null,
//    "CanChangeMagic": "1",
//    "GrowthTabIndex": null,
//    "NeedGrowthExp": null,
//    "CanShared": "0",
//    "MapBanTradeItemMask": null,
//    "MapCanExistItemMask": null,
//    "MapBanEquipItemMask": null,
//    "IsPVEEquip": "1",
//    "RepairPriceRebate": "512",
//    "_Magic1Type": {
//        "attr": [
//            "atPhysicsAttackPowerBase",
//            "1887",
//            "1887",
//            null,
//            null
//        ],
//        "label": ""
//    },
//    "_Magic2Type": {
//        "attr": [
//            "atPhysicsCriticalStrike",
//            "4278",
//            "4278",
//            null,
//            null
//        ],
//        "label": ""
//    },
//    "_Magic3Type": null,
//    "_Magic4Type": null,
//    "_Magic5Type": null,
//    "_Magic6Type": null,
//    "_Magic7Type": null,
//    "_Magic8Type": null,
//    "_Magic9Type": null,
//    "_Magic10Type": null,
//    "_Magic11Type": null,
//    "_Magic12Type": null,
//    "_DiamondAttributeID1": [
//        "atPhysicsCriticalDamagePowerBase",
//        "161",
//        "161",
//        "0",
//        "0"
//    ],
//    "_DiamondAttributeID2": [
//        "atPhysicsCriticalStrike",
//        "161",
//        "161",
//        null,
//        null
//    ],
//    "_DiamondAttributeID3": null,
//    "_AttrType": [
//        "atPhysicsShieldBase",
//        "atMagicShield",
//        "atInvalid",
//        "atPhysicsCriticalDamagePowerBase",
//        "atPhysicsCriticalStrike",
//        "atPhysicsAttackPowerBase"
//    ],
//    "_PvType": "1",
//    "_IconID": "9244",
//    "_Duty": "1",
//    "_Attrs": [
//        "Critical"
//    ],
//    "_SetAttrbs": null,
//    "_SetData": {},
//    "_SkillDesc": null,
//    "_isAwesome": 1
struct EquipDTO: Decodable, Identifiable {
    let id: Int
    let attrs: [EquipAttribute]
    let attrType: [String]
    let belongSchool: String?
    let name: String
    let uuid: String
    let representId: String?
    let iconId: String?
    let level: Int
    // 最大强化等级
    let maxStrengthLevelValue: String?
    // 品质
    let quality: EquipQuality
    let skillId: String?
    
    let baseTypes: [EquipBaseType?]
    let magicTypes : [EquipMagicType?]
    
    let detailTypeValue : String?
    let subType: EquipSubType
    let diamondAttributes: [DiamondAttribute]
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.attrs = try container.decode([EquipAttribute].self, forKey: .attrs)
        self.attrType = try container.decode([String].self, forKey: .attrType)
        self.belongSchool = try container.decodeIfPresent(String.self, forKey: .belongSchool)
        self.name = try container.decode(String.self, forKey: .name)
        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.representId = try container.decodeIfPresent(String.self, forKey: .representId)
        self.iconId = try container.decodeIfPresent(String.self, forKey: .iconId)
        self.level = try container.decode(Int.self, forKey: .level)
        self.maxStrengthLevelValue = try container.decodeIfPresent(String.self, forKey: .maxStrengthLevelValue)
        self.quality = try container.decode(EquipQuality.self, forKey: .quality)
        self.skillId = try container.decodeIfPresent(String.self, forKey: .skillId)
        self.detailTypeValue = try container.decode(String.self, forKey: .detailTypeValue)
        self.subType = try container.decode(EquipSubType.self, forKey: .subType)
        
        self.baseTypes = try EquipDTO.loadBaseTypes(from: decoder)
        self.magicTypes = try EquipDTO.loadMagicTypes(from: decoder)
        self.diamondAttributes = try EquipDTO.loadDiamondAttribute(from: decoder)
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case attrs = "_Attrs"
        case attrType = "_AttrType"
        case belongSchool = "BelongSchool"
        case name = "Name"
        case uuid = "UiID"
        case representId = "RepresentID"
        case iconId = "_IconID"
        case level = "Level"
        case maxStrengthLevelValue = "MaxStrengthLevel"
        case quality = "Quality"
        case skillId = "SkillID"
        case subType = "SubType"
        case detailTypeValue = "DetailType"
    }
}


// MARK: 一些扩展的判断属性
extension EquipDTO {
    var isSimp: Bool {
        return belongSchool == "精简" || hasEffect
    }
    
    var hasEffect: Bool {
        return skillId != nil || attrType.contains("atSetEquipmentRecipe") || attrType.contains("atSkillEventHandler")
    }
    
    var maxStrengthLevel: Int {
        guard let maxStrengthLevelValue = self.maxStrengthLevelValue,
              let level = Int(maxStrengthLevelValue) else { return 6 }
        
        return level
    }
    
    var isWepaon : Bool {
        return subType == .PRIMARY_WEAPON || subType == .SENCONDARY_WEAPON
    }
    
    var detailType : String {
        return AssetJsonDataManager.shared.weaponType[detailTypeValue ?? "", default: "未知武器: \(detailTypeValue ?? "")"]
    }
    
    private static func loadBaseTypes(from decoder: Decoder) throws -> [EquipBaseType?] {
        var baseTypes: [EquipBaseType?] = Array(repeating: nil, count: 6)
        for i in 0..<baseTypes.count {
            baseTypes[i] = try EquipBaseType(decoder: decoder, index: i + 1)
        }
        return baseTypes
    }
    
    private static func loadMagicTypes(from decoder: Decoder) throws -> [EquipMagicType?] {
        var magicTypes: [EquipMagicType?] = Array(repeating: nil, count: 12)
        for i in 0..<magicTypes.count {
            magicTypes[i] = try EquipMagicType(decoder: decoder, index: i + 1)
        }
        return magicTypes
    }
    
    private static func loadDiamondAttribute(from decoder: Decoder) throws -> [DiamondAttribute] {
        var diamondAttributes: [DiamondAttribute] = []
        for i in 0..<3 {
            if let da = try DiamondAttribute(from: decoder, index: i + 1) {
                diamondAttributes.append(da)
            }
        }
        return diamondAttributes
    }
}

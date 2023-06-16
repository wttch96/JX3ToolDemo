//
//  BoxResponse.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/8.
//

import Foundation



struct BoxResponse<T>: Decodable where T: Decodable {
    let total: Int
    let per: Int
    let pages: Int
    let page: Int
    let list: [T]
}

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
    let name: String
    let uuid: String
    let representId: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case uuid = "UiID"
        case representId = "RepresentID"
    }
}

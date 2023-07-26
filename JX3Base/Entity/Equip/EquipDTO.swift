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
struct EquipDTO: Decodable {
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
    
    // 基础属性，主要是攻击力
    let baseTypes: [EquipBaseType]
    // 装备的其他属性
    let magicTypes : [EquipMagicType]
    
    let detailTypeValue : String?
    let subType: EquipSubType
    // 五行石镶嵌
    let diamondAttributes: [DiamondAttribute]
    // 装备需求
    private let requireTypes: [EquipRequireType]
    // 最大耐久度
    let maxDurability: String?
    // 来源
    let getType: String?
    // 装备类型: 伤、御、疗
    let duty: String?
    // 套装id
    let setId: String?
    
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
        self.maxDurability = try container.decodeIfPresent(String.self, forKey: .maxDurability)
        self.getType = try container.decodeIfPresent(String.self, forKey: .getType)
        self.duty = try container.decodeIfPresent(String.self, forKey: .duty)
        self.setId = try container.decodeIfPresent(String.self, forKey: .setId)
        
        self.baseTypes = try EquipDTO.loadBaseTypes(from: decoder)
        self.magicTypes = try EquipDTO.loadMagicTypes(from: decoder)
        self.diamondAttributes = try EquipDTO.loadDiamondAttribute(from: decoder)
        self.requireTypes = try EquipDTO.loadRequireTypes(from: decoder)
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
        case maxDurability = "MaxDurability"
        case getType = "GetType"
        case duty = "_Duty"
        case setId = "SetID"
    }
}


// MARK: 扩展属性
extension EquipDTO {
    // 是否为精简
    var isSimp: Bool {
        return belongSchool == "精简" || hasEffect
    }
    // 是否为特效武器
    var hasEffect: Bool {
        return skillId != nil || attrType.contains("atSetEquipmentRecipe") || attrType.contains("atSkillEventHandler")
    }
    // 最大精炼等级
    var maxStrengthLevel: Int {
        guard let maxStrengthLevelValue = self.maxStrengthLevelValue,
              let level = Int(maxStrengthLevelValue) else { return 6 }
        
        return level
    }
    // 是否为武器
    var isWepaon: Bool {
        return subType == .PRIMARY_WEAPON || subType == .SENCONDARY_WEAPON
    }
    // 武器描述
    var detailType: String {
        return AssetJsonDataManager.shared.weaponType[detailTypeValue ?? "", default: "未知武器: \(detailTypeValue ?? "")"]
    }
}

// MARK: 武器伤害计算
extension EquipDTO {
    // 获取武器攻击速度属性
    var weaponSpeed: EquipBaseType? {
        return baseTypes.first(where: { $0.isSpeed })
    }
    // 获取武器攻击力范围属性
    var weaponRand: EquipBaseType? {
        return baseTypes.first { $0.isRand }
    }
    // 获取武器基础攻击力属性
    var weaponBase: EquipBaseType? {
        return baseTypes.first(where: { $0.isBase })
    }
}

// MARK: 装备需求
extension EquipDTO {
    // 需求等级
    var requireLevel: Int? {
        if let rt = requireTypes.first( where: { $0.type == "5" }) {
            return Int(rt.value)
        }
        return nil
    }
    // 需求门派
    var requireSchool: School? {
        if let rt = requireTypes.first( where: { $0.type == "6" }) {
            return School(forceId: Int(rt.value))
        }
        return nil
    }
    // 需求性别
    var requireGender: Bool? {
        if let rt = requireTypes.first( where: { $0.type == "7" }) {
            return rt.value == "1"
        }
        return nil
    }
    // 需求阵营
    var requireCamp: String? {
        if let rt = requireTypes.first(where: { $0.type == "100" }) {
            switch rt.value {
            case "1": return "中立";
            case "2": fallthrough
            case "3": return "浩气盟";
            case "4": fallthrough
            case "5": return "恶人谷"
            case "6": return "浩气盟，或恶人谷"
            default: return nil
            }
        }
        return nil
    }
}
// MARK: 装分
extension EquipDTO {
    // 装备基础装分
    var equipScore: Int {
        return ScoreUtil.getEquipScore(level: level, quality: quality.rawValue, position: subType.rawValue)
    }
    // 精炼品质分
    func strengthLevelScore(strengthLevel: Int) -> Int {
        return ScoreUtil.getGsStrengthScore(base: level, strengthLevel: strengthLevel)
    }
}

// MARK: 构造工具方法
extension EquipDTO {
    // 从 json 中加载武器攻击属性
    private static func loadBaseTypes(from decoder: Decoder) throws -> [EquipBaseType] {
        var baseTypes: [EquipBaseType] = []
        for i in 0..<6 {
            if let type =  try EquipBaseType(decoder: decoder, index: i + 1) {
                baseTypes.append(type)
            }
        }
        return baseTypes
    }
    // 从 json 中加载其他属性
    private static func loadMagicTypes(from decoder: Decoder) throws -> [EquipMagicType] {
        var magicTypes: [EquipMagicType] = []
        for i in 0..<12 {
            if let mt = try EquipMagicType(decoder: decoder, index: i + 1) {
                magicTypes.append(mt)
            }
        }
        return magicTypes
    }
    // 从 json 中加载五行石镶嵌孔
    private static func loadDiamondAttribute(from decoder: Decoder) throws -> [DiamondAttribute] {
        var diamondAttributes: [DiamondAttribute] = []
        for i in 0..<3 {
            if let da = try DiamondAttribute(from: decoder, index: i + 1) {
                diamondAttributes.append(da)
            }
        }
        return diamondAttributes
    }
    // 从 json 中加载装备要求信息
    private static func loadRequireTypes(from decoder: Decoder) throws -> [EquipRequireType] {
        var requireTypes: [EquipRequireType] = []
        for i in 1...6 {
            if let rt = try EquipRequireType(from: decoder, index: i) {
                requireTypes.append(rt)
            }
        }
        return requireTypes
    }
}
// MARK: Hash, Id
extension EquipDTO: Hashable, Identifiable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var hashValue: Int {
        return id.hashValue
    }
    
    static func ==(lhs: EquipDTO, rhs: EquipDTO) -> Bool {
        return lhs.id == rhs.id
    }
}

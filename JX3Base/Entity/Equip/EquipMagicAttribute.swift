//
//  EquipMagicType.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/23.
//

import Foundation

// MARK: DTO

/// 装备魔法属性 DTO，原始的数据解析使用。
///
/// json数据格式例子:
/// "_Magic1Type": {
///     "attr": [
///         "atPhysicsAttackPowerBase",
///         "1887",
///         "1887",
///         null,
///         null
///     ],
///     "label": ""
/// }
struct EquipMagicAttributeDTO: Decodable {
    // dto 原始属性数组
    var attr : [String?]
    // 特殊的描述标签。
    // 例如: "<text>text=\"装备：“无我无剑”伤害提高5%\" font=101 </text>"
    var label: String
    
    /// 使用 Decoder 和 MagicType的索引数字进行初始化
    /// - Parameters:
    ///   - decoder: decoder
    ///   - index: magicType的数字索引
    init?(decoder : Decoder, index: Int) throws {
        let container = try decoder.container(keyedBy: CustomKey.self)
        if let type = try container.decodeIfPresent(EquipMagicAttributeDTO.self, forKey: CustomKey(stringValue: "_Magic\(index)Type")) {
            self = type
        } else {
            return nil
        }
    }
    
    /// 转换为应用内使用的实体对象
    /// - Returns: 转换为应用内使用的实体
    func toAttribute() -> EquipMagicAttribute? {
        if !attr.isEmpty, let type = attr[0] {
            let min = attr[1].flatMap({ Int($0) }) ?? 0
            return EquipMagicAttribute(type: type, min: min, label: label)
        }
        
        return nil
    }
}


// MARK: 实体

/// 装备魔法属性实体
struct EquipMagicAttribute {
    // 属性类型，从原始数据数组第1个数值获取
    var type : String
    // 属性值，从原始数据数组第2个数值获取
    var min: Int
    // 特殊的描述标签。
    // 例如: "<text>text=\"装备：“无我无剑”伤害提高5%\" font=101 </text>"
    var label: String
}

extension EquipMagicAttribute: Codable, Identifiable {
    var id: String { return type }
    
    // 是否是主要属性
    var isPrimaryAttr: Bool {
        return ["atVitalityBase", "atSpunkBase", "atSpiritBase", "atStrengthBase", "atAgilityBase"].contains(type)
    }
    
    var attrDesc : String {
        return (AssetJsonDataManager.shared.attrDescMap[type] ?? "nil") + "\(min)"
    }
    
    var briefDesc : String {
        return (AssetJsonDataManager.shared.attrBriefDescMap[type] ?? "nil") + "+\(min)"
    }
    
    /// 获取装备属性的强化分数
    /// - Parameters:
    ///   - level: 强化等级
    ///   - maxLevel: 最大强化等级
    /// - Returns: 装备属性的强化分数
    func score(level: Int, maxLevel: Int) -> Int {
        return ScoreUtil.getStrengthScore(base: min, strengthLevel: level, equipLevel: maxLevel)
    }
}
 

//
//  EquipMagicType.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/23.
//

import Foundation


struct EquipMagicType : Decodable, Identifiable {
    typealias ID = String
    var id : String { return UUID().uuidString }
    var attr : [String?]
    var label: String
    
    var min : Int { return attr[1].flatMap({ Int($0) }) ?? 0 }
    
    init?(decoder : Decoder, index: Int) throws {
        let container = try decoder.container(keyedBy: CustomKey.self)
        if let type = try container.decodeIfPresent(EquipMagicType.self, forKey: CustomKey(stringValue: "_Magic\(index)Type")) {
            self = type
        } else {
            return nil
        }
    }
}

extension EquipMagicType {
    var type: String? {
        if !attr.isEmpty {
            return attr[0]
        }
        return nil
    }
    // 是否是主要属性
    var isPrimaryAttr: Bool {
        return ["atVitalityBase", "atSpunkBase", "atSpiritBase", "atStrengthBase", "atAgilityBase"].contains(attr[0] ?? "")
    }
    
    var attrDesc : String {
        return (AssetJsonDataManager.shared.attrDescMap[attr[0] ?? ""] ?? "nil") + "\(min)"
    }
    
    var briefDesc : String {
        return (AssetJsonDataManager.shared.attrBriefDescMap[attr[0] ?? ""] ?? "nil") + "+\(min)"
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
 

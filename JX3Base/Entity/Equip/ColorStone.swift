//
//  ColorStone.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/28.
//

import Foundation
import SwiftUI

//"ID": 621,
//"Name": "彩·瞬影·斩铁·痛击(陆)",
//"UIID": "30192",
//"AttriName": null,
//"Attribute1ID": "atAgilityBase",
//"Attribute1Value1": "131",
//"Attribute1Value2": "131",
//"Score": 0,
//"DiamondType1": "5",
//"Compare1": "3",
//"DiamondCount1": "14",
//"DiamondIntensity1": "50",
//"Attribute2ID": "atPhysicsOvercomeBase",
//"Attribute2Value1": "1170",
//"Attribute2Value2": "1170",
//"DiamondType2": "5",
//"Compare2": "3",
//"DiamondCount2": "16",
//"DiamondIntensity2": "90",
//"Attribute3ID": "atPhysicsCriticalDamagePowerBase",
//"Attribute3Value1": "2340",
//"Attribute3Value2": "2340",
//"DiamondType3": "5",
//"Compare3": "3",
//"DiamondCount3": "18",
//"DiamondIntensity3": "108",
//"ScriptName": null,
//"Attribute4ID": null,
//"Attribute4Value1": null,
//"Attribute4Value2": null,
//"RepresentIndex": null,
//"RepresentID": null,
//"Time": null,
//"DestItemSubType": null,
//"TabType": "5",
//"TabIndex": "0",
//"PackageSize": null,
//"MapInvalidMask": null,
//"BelongKungfuID": null,
//"is_stone": "1",
//"stone_level": "6",
//"icon": "2341",
//"subtype": "3",
//"_AttriName": null,
//"_Attrs": [
//   "atAgilityBase",
//   "atPhysicsOvercomeBase",
//   "atPhysicsCriticalDamagePowerBase"
//],
//"_quality": null,
//"_latest_enhance": null
struct ColorStone: Decodable, Identifiable {
    let id: Int
    let name: String
    let icon: String
    let level: String
    
    let attributes: [ColorStoneAttribute]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.level = try container.decode(String.self, forKey: .level)
        
        var attributes: [ColorStoneAttribute] = []
        for i in 1...3 {
            if let attribute = try ColorStoneAttribute(decoder: decoder, index: i) {
                attributes.append(attribute)
            }
        }
        self.attributes = attributes
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case icon = "icon"
        case level = "stone_level"
    }
}

extension ColorStone: Equatable {
    var color: Color {
        return EquipQuality(rawValue: "\(((Int(level) ?? 0) + 1) / 2 + 1)")?.color ?? .gray
    }
    
    var briefRemark: String {
        return attributes.map { $0.briefLabel }.joined(separator: "･")
    }
    
    static func == (lhs: ColorStone, rhs: ColorStone) -> Bool {
        return lhs.id == rhs.id && lhs.level == rhs.level
    }
}

struct ColorStoneAttribute: Identifiable {
    let id: String
    let value1: String
    let value2: String
    let diamondType: String
    let compare: String
    let diamondCount: String
    let diamondIntensity: String
    
    let index: Int
    
    init?(decoder: Decoder, index: Int) throws {
        self.index = index
        let container = try decoder.container(keyedBy: CustomKey.self)
        id = try container.decode(String.self, forKey: CustomKey(stringValue: "Attribute\(index)ID"))
        value1 = try container.decode(String.self, forKey: CustomKey(stringValue: "Attribute\(index)Value1"))
        value2 = try container.decode(String.self, forKey: CustomKey(stringValue: "Attribute\(index)Value2"))
        diamondType = try container.decode(String.self, forKey: CustomKey(stringValue: "DiamondType\(index)"))
        compare = try container.decode(String.self, forKey: CustomKey(stringValue: "Compare\(index)"))
        diamondCount = try container.decode(String.self, forKey: CustomKey(stringValue: "DiamondCount\(index)"))
        diamondIntensity = try container.decode(String.self, forKey: CustomKey(stringValue: "DiamondIntensity\(index)"))
    }
}

extension ColorStoneAttribute {
    var briefLabel: String {
        return AssetJsonDataManager.shared.attrBriefDescMap[id, default: id]
    }
    
    var remark: String {
        return AssetJsonDataManager.shared.attrDescMap[id, default: id]
    }
    
    /// 判断是属性是否激活
    /// - Parameters:
    ///   - count: 配装五行石总数
    ///   - level: 配装五行石等级
    /// - Returns: 给定的等级和总数是否可以激活该属性
    func actived(count: Int, level: Int) -> Bool {
        return (count >= Int(diamondCount) ?? 0) && (level >= Int(diamondIntensity) ?? 0)
    }
}

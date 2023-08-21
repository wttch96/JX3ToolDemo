//
//  Enchant.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/6.
//

import Foundation

//"ID": 11864,
//"Name": "天堑奇瑛·伤·腰",
//"UIID": "腰带限时大附魔",
//"AttriName": null,
//"Attribute1ID": "atSkillEventHandler",
//"Attribute1Value1": "2478",
//"Attribute1Value2": null,
//"Score": 1575,
//"DiamondType1": null,
//"Compare1": null,
//"DiamondCount1": null,
//"DiamondIntensity1": null,
//"Attribute2ID": null,
//"Attribute2Value1": null,
//"Attribute2Value2": null,
//"DiamondType2": null,
//"Compare2": null,
//"DiamondCount2": null,
//"DiamondIntensity2": null,
//"Attribute3ID": null,
//"Attribute3Value1": null,
//"Attribute3Value2": null,
//"DiamondType3": null,
//"Compare3": null,
//"DiamondCount3": null,
//"DiamondIntensity3": null,
//"ScriptName": null,
//"Attribute4ID": null,
//"Attribute4Value1": null,
//"Attribute4Value2": null,
//"RepresentIndex": null,
//"RepresentID": null,
//"Time": "60",
//"DestItemSubType": "6",
//"TabType": null,
//"TabIndex": null,
//"PackageSize": null,
//"MapInvalidMask": "3",
//"BelongKungfuID": "0",
//"is_stone": null,
//"stone_level": null,
//"icon": null,
//"subtype": "2",
//"_AttriName": "<Text>text=\"释放招式命中目标有20%几率使自身短时间内伤害获得不稳定的增幅（最终伤害有30%几率提高1%，有70%几率提高5%），该效果每30秒最多触发一次，并持续8秒。不在名剑大会中生效。\" font=12 </text>",
//"_Attrs": null,
//"_quality": null,
//"_latest_enhance": null
struct EnchantDTO: Decodable {
    let id: Int
    let name: String
    private let _quality: Int?
    let attriName: String?
    let boxAttriName: String?
    let score: Int
    let attrs: [[String?]]?
    
    let attribute1: String?
    let value1: String?
    let value2: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case _quality = "_quality"
        case attriName = "AttriName"
        case boxAttriName = "_AttriName"
        case score = "Score"
        case attrs = "_Attrs"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self._quality = try container.decodeIfPresent(Int.self, forKey: ._quality)
        self.attriName = try container.decodeIfPresent(String.self, forKey: .attriName)
        self.boxAttriName = try container.decodeIfPresent(String.self, forKey: .boxAttriName)
        self.score = try container.decode(Int.self, forKey: .score)
        self.attrs = try container.decodeIfPresent([[String?]].self, forKey: .attrs)
        
        
        
        let container1 = try decoder.container(keyedBy: CustomKey.self)
        attribute1 = try container1.decodeIfPresent(String.self, forKey: CustomKey(stringValue: "Attribute1ID"))
        value1 = try container1.decodeIfPresent(String.self, forKey: CustomKey(stringValue: "Attribute1Value1"))
        value2 = try container1.decodeIfPresent(String.self, forKey: CustomKey(stringValue: "Attribute1Value2"))
    }
    
    
    func toEntity() -> Enchant {
        var eq: EquipQuality? = nil
        if let quality = _quality {
            eq =  EquipQuality.allCases.first(where: { $0.rawValue == "\(quality)"})
        }
        
        return Enchant(id: id, name: name, quality: eq, attriName: attriName, boxAttriName: boxAttriName, score: score, attrs: attrs, attribute1: attribute1, value1: value1, value2: value2)
    }
    
}

struct Enchant {
    let id: Int
    let name: String
    let quality: EquipQuality?
    let attriName: String?
    let boxAttriName: String?
    let score: Int
    let attrs: [[String?]]?
    
    let attribute1: String?
    let value1: String?
    let value2: String?
}

extension Enchant: Hashable, Identifiable, Codable {
    
    var hashValue: Int {
        return id.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// 将属性转换为属性 Map，属性-值的映射。可以直接在配装属性统计时进行遍历添加。
    var attrMap: [String: Float] {
        var ret: [String: Float] = [:]
        for attr in attrs ?? [] {
            if attr.count == 3, let type = attr[0], let valueStr = attr[1], let value = Float(valueStr) {
                ret[type] = value
            }
        }
        
        // 小附魔
        if let attr = attribute1, let value1 = value1, let intValue = Int(value1) {
            ret[attr] = Float(intValue)
        }
        
        return ret
    }
}

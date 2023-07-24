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
struct Enchant: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    private let _quality: Int?
    let attriName: String?
    let boxAttriName: String?
    let score: Int
    
    var quality: EquipQuality? {
        if let quality = _quality {
            return EquipQuality.allCases.first(where: { $0.rawValue == "\(quality)"})
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case _quality = "_quality"
        case attriName = "AttriName"
        case boxAttriName = "_AttriName"
        case score = "Score"
    }
    
    var hashValue: Int {
        return id.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

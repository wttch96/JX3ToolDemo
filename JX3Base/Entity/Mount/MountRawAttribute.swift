//
//  MountRawAttribute.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/30.
//

import Foundation

/// 心法固定属性
struct MountRawAttribute: Decodable {
    let szSkillName: String
    let filePath: String
    let dwMaxLevel: Int
    let dwLevel: Int
    let bUseAdditionalAttribute: Bool?
    let skillAttributes: [MountSkillAttribute]
}


struct MountSkillAttribute: Decodable {
    let effectMode: String
    let type: String?
    let param1: MixValue?
    let param2: MixValue?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.effectMode = try container.decode(String.self, forKey: .effectMode)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.param1 = MixValue(container: container, forKey: .param1)
        self.param2 = MixValue(container: container, forKey: .param2)
    }
    
    enum CodingKeys: String, CodingKey {
        case effectMode = "ATTRIBUTE_EFFECT_MODE"
        case type = "ATTRIBUTE_TYPE"
        case param1
        case param2
    }
    
    /// 获取转换后的属性
    var convertAttr: LuaConvertValue? {
        if let type = type {
            return AssetJsonDataManager.shared.luaConvertMapping[type]
        } else {
            return nil
        }
    }
}

struct MountSkillAttributeValue {
    let intValue: Int?
    let floatValue: Float?
    
    init(intValue: Int?) {
        self.intValue = intValue
        self.floatValue = nil
    }
    
    init(floatValue: Float?) {
        self.intValue = nil
        self.floatValue = floatValue
    }
}


/// 心法扩展属性
struct MountExtraAttribute: Decodable {
    let slot: String
    let value: Int
    
    
    /// 获取转换后的属性
    var convertAttr: LuaConvertValue? {
        return AssetJsonDataManager.shared.luaConvertMapping[slot]
    }
}

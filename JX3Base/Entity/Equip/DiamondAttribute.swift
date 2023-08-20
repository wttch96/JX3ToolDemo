//
//  DiamondAttribute.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/25.
//

import Foundation

// MARK: DTO

/// 五行石镶嵌属性
/// "_DiamondAttributeID1": [
///     "atPhysicsOvercomeBase",
///     "161",
///     "161",
///     "0",
///     "0"
/// ],
struct DiamondAttributeDTO: Decodable {
    /// 孔位索引
    let index: Int
    /// 原始数据
    let values: [String?]
    
    
    /// 使用 decoder 和 孔位索引 构造 DTO 对象
    /// - Parameters:
    ///   - decoder: 解码器
    ///   - index: 孔位索引
    init?(from decoder: Decoder, index: Int) throws {
        let container = try decoder.container(keyedBy: CustomKey.self)
        let values: [String?]? = try container.decodeIfPresent([String?].self, forKey: CustomKey(stringValue: "_DiamondAttributeID\(index)"))
        if let values = values {
            self.values = values
            self.index = index
        } else {
            return nil
        }
    }
    
    
    /// 转换为对应的实体对象
    /// - Returns: 对应的实体对象
    func toEntity() -> DiamondAttribute {
        return DiamondAttribute(index: index, type: values[0]!, baseValue:  Float(values[1]!) ?? 0)
    }
}

// MARK: 实体

/// 五行石镶嵌属性
struct DiamondAttribute: Codable, Identifiable, Hashable {
    /// 孔位索引
    let index: Int
    /// 属性类型
    let type: String
    /// 基础数值
    let baseValue: Float
    var id: Int { return index }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var hashValue: Int {
        return id.hashValue
    }
}


extension DiamondAttribute {
    /// 属性描述
    var label: String {
        return AssetJsonDataManager.shared.attrDescMap[type, default: type]
    }
    
    /// 简短的属性描述
    var briefLabel: String {
        return AssetJsonDataManager.shared.attrBriefDescMap[type, default: type]
    }
    
    
    /// 计算镶嵌的属性加成
    ///
    /// /**
    ///  * 镶嵌激活属性加成值
    ///  * @param {Number} base 属性基数
    ///  * @param {Number} level 镶嵌的五行石等级
    ///  * @param {Number} client 所属客户端版本
    ///  * @returns {Number} 镶嵌激活属性加成值
    ///  */
    /// function getAttributEmbedValue(base, level, client = 'std') {
    ///     let coefficients = 0;
    ///     if (client === "std") {
    ///         if (level > 6) {
    ///             coefficients = (level * 0.65 - 3.2) * 1.3;
    ///         } else {
    ///             coefficients = level * 0.195;
    ///         }
    ///     } else {
    ///         if (level > 6) {
    ///             coefficients = level * 0.55 - 2.48;
    ///         } else {
    ///             coefficients = level * 0.15;
    ///         }
    ///         coefficients *= 2.4;
    ///         // 怀旧服两个赛季均对 coefficients 通过一个统一的系数修正，对应反编译函数为 KGItemInfoList::AttribMountDiamond
    ///         // v13 = v12 * 2.4;
    ///     }
    ///
    ///     return Math.floor(Math.floor(base) * coefficients);
    /// }
    func embedValue(stoneLevel: Int) -> Float {
        var coefficients: Float = 0.0
        let level = Float(stoneLevel)
        if level > 6 {
            coefficients = (level * 0.65 - 3.2) * 1.3
        } else {
            coefficients = level * 0.195
        }
        
        return floor(floor(baseValue) * coefficients);
    }

}

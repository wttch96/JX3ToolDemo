//
//  DiamondAttribute.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/25.
//

import Foundation
// /**
// * 镶嵌激活属性加成值
// * @param {Number} base 属性基数
// * @param {Number} level 镶嵌的五行石等级
// * @param {Number} client 所属客户端版本
// * @returns {Number} 镶嵌激活属性加成值
// */
//function getAttributEmbedValue(base, level, client = 'std') {
//    let coefficients = 0;
//    if (client === "std") {
//        if (level > 6) {
//            coefficients = (level * 0.65 - 3.2) * 1.3;
//        } else {
//            coefficients = level * 0.195;
//        }
//    } else {
//        if (level > 6) {
//            coefficients = level * 0.55 - 2.48;
//        } else {
//            coefficients = level * 0.15;
//        }
//        coefficients *= 2.4;
//        // 怀旧服两个赛季均对 coefficients 通过一个统一的系数修正，对应反编译函数为 KGItemInfoList::AttribMountDiamond
//        // v13 = v12 * 2.4;
//    }
//
//    return Math.floor(Math.floor(base) * coefficients);
//}

struct DiamondAttribute: Decodable, Identifiable, Hashable {
    let attr: String
    let base: Float
    let id: Int
    
    init?(from decoder: Decoder, index: Int) throws {
        let container = try decoder.container(keyedBy: CustomKey.self)
        let values: [String?]? = try container.decodeIfPresent([String?].self, forKey: CustomKey(stringValue: "_DiamondAttributeID\(index)"))
        if let values = values {
            self.attr = values[0]!
            self.base = Float(values[1]!) ?? 0
            self.id = index
        } else {
            return nil
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var hashValue: Int {
        return id.hashValue
    }
}


extension DiamondAttribute {
    var label: String {
        return AssetJsonDataManager.shared.attrDescMap[attr] ?? ""
    }
    
    var briefLabel: String {
        return AssetJsonDataManager.shared.attrBriefDescMap[attr] ?? ""
    }
    
    func embedValue(level: Int, client: String = "std") -> Float {
        var coefficients: Float = 0.0
        let level = Float(level)
        if client == "std" {
          if level > 6 {
              coefficients = (level * 0.65 - 3.2) * 1.3
          } else {
              coefficients = level * 0.195;
          }
      } else {
          if level > 6 {
              coefficients = level * 0.55 - 2.48
          } else {
              coefficients = level * 0.15
          }
          coefficients *= 2.4
      }

      return floor(floor(base) * coefficients);
    }

}

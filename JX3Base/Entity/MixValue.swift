//
//  MixValue.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/30.
//

import Foundation

/// 混合 Float 和 Int 的数据类型
struct MixValue {
    let intValue: Int?
    let floatValue: Float?
    
    init?<K: CodingKey>(container: KeyedDecodingContainer<K>, forKey: KeyedDecodingContainer<K>.Key) {
        if let floatValue = try? container.decodeIfPresent(Float.self, forKey: forKey) {
            self.floatValue = floatValue
            self.intValue = nil
        } else if let intValue = try? container.decodeIfPresent(Int.self, forKey: forKey) {
            self.floatValue = nil
            self.intValue = intValue
        } else {
            return nil
        }
    }
    
    var value: Float {
        if let intValue = intValue, intValue != 0 {
            return Float(intValue)
        }
        if let floatValue = floatValue, floatValue != 0 {
            return floatValue
        }
        return 0
    }
}

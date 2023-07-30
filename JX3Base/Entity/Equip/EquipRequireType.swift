//
//  RequireType.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/26.
//

import Foundation

// 穿装备的需求
struct EquipRequireType {
    let type: String
    let value: String
    
    init?(from decoder: Decoder, index: Int) throws {
        let container = try decoder.container(keyedBy: CustomKey.self)
        if let type = try container.decodeIfPresent(String.self, forKey: CustomKey(stringValue: "Require\(index)Type")),
           let value = try container.decodeIfPresent(String.self, forKey: CustomKey(stringValue: "Require\(index)Value")) {
            self.type = type
            self.value = value
        } else {
            return nil
        }
    }
}

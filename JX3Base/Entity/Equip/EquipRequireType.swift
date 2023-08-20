//
//  RequireType.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/26.
//

import Foundation

/// 穿装备的需求
struct EquipRequireType {
    /// 需求类型
    let type: String
    /// 需求值
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

extension EquipRequireType: Codable {
    
}

extension Array where Element == EquipRequireType {
    
    /// 需求等级
    var requireLevel: Int? {
        if let rt = first( where: { $0.type == "5" }) {
            return Int(rt.value)
        }
        return nil
    }
    
    /// 需求门派
    var requireSchool: School? {
        if let rt = first( where: { $0.type == "6" }) {
            return School(forceId: Int(rt.value))
        }
        return nil
    }
    
    /// 需求性别
    var requireGender: Bool? {
        if let rt = first( where: { $0.type == "7" }) {
            return rt.value == "1"
        }
        return nil
    }
    
    /// 需求阵营
    var requireCamp: String? {
        if let rt = first(where: { $0.type == "100" }) {
            switch rt.value {
            case "1": return "中立";
            case "2": fallthrough
            case "3": return "浩气盟";
            case "4": fallthrough
            case "5": return "恶人谷"
            case "6": return "浩气盟，或恶人谷"
            default: return nil
            }
        }
        return nil
    }
}

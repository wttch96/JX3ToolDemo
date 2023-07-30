//
//  Talent.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/31.
//

import Foundation



/// "name": "封侯",
/// "icon": 4558,
/// "desc": "“穿云”伤害提高10%。",
/// "order": "1",
/// "pos": 1,
/// "is_skill": 0,
/// "meta": null,
/// "extend": null,
/// "id": "5656"
struct Talent: Identifiable, Codable, Comparable, Equatable {
    let id: String?
    let name: String
    let icon: Int?
    let desc: String?
    let order: String?
    let pos: Int?
    let skill: Int?
    let meta: String?
    let extend: String?
    
    var isSkill: Bool { return skill == 1 }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case icon
        case desc
        case order
        case pos
        case skill = "is_skill"
        case meta
        case extend
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        // 先比对重数，重数相等比较相同重数的位置
        if lhs.order == rhs.order {
            guard let lp = lhs.pos, let rp = rhs.pos else { return false }
            return lp < rp
        }
        
        guard let lo = lhs.order, let ro = rhs.order else { return false }
        return lo < ro
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    /// 解析所有的被动属性
    var passiveAttributes: [String: Int] {
        var ret: [String: Int] = [:]
        AssetJsonDataManager.shared.talnetPassive.values.flatMap { $0 }.forEach { passive in
            if String(passive.skillId) == self.id {
                passive.value.forEach { values in
                    values.forEach { (key: String, value: Int) in
                        ret[key] = value
                    }
                }
            }
        }
        return ret
    }
}

/// 奇穴重数
struct TalentLevel: Identifiable, Comparable {
    let id: String
    let talents: [Talent]
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return Int(lhs.id) ?? 0 < Int(rhs.id) ?? 0
    }
}


// 奇穴被动属性加成
struct TalnetPassive: Decodable {
    let skillId: Int
    let remark: String
    let value: [[String: Int]]
    
    enum CodingKeys: String, CodingKey {
        case skillId = "skill_id"
        case remark
        case value
    }
}

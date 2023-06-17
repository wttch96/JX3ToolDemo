//
//  MountEquip.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/17.
//

import Foundation

//    "name": "孤锋诀",
//    "school_name": "刀宗",
//    "client": ["all", "std"],
//    "duty": "外功",
//    "share_school": ["天策", "丐帮", "唐门", "霸刀"],
//    "primary_weapon_type": "21",
//    "primary_attribute": "力道"
struct MountEquip: Decodable {
    let name: String
    let schoolName: String
    let client: [String]
    let duty: DutyType
    let shareSchool: [String]
    let primaryWeaponType: String
    let primaryAttribute: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case schoolName = "school_name"
        case client
        case duty
        case shareSchool = "share_school"
        case primaryWeaponType = "primary_weapon_type"
        case primaryAttribute = "primary_attribute"
    }
}

//
//  AssetJsonDataService.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import Foundation
import SwiftUI

class AssetJsonDataService {
    
    static let shared = AssetJsonDataService()
    
    private var schools: [SchoolDTO] = []
    private var kungfus: [KungfuDTO] = []
    
    private var kungfuAttrsMap: [String: [EquipAttribute]] = [:]
    
    private let KEY_COLORS_BY_SCHOOL_NAME = "colors_by_school_name"
    private let KEY_COLORS_BY_MOUNT_NAME = "colors_by_mount_name"
    private var schoolColorMap: [String: Color] = [:]
    private var mountColorMap: [String: Color] = [:]
    // kungfu.id -> MountEquip
    private var mountEquipMap: [String: MountEquipDTO] = [:]

    var schoolData: [School] = []
    var kungfuData: [Kungfu] = []
    
    private init() {
        loadSchool()
        loadKungfu()
        loadKungfuAttribute()
        loadColors()
        loadMountEquip()
        
        self.kungfuData = kungfus.map { kungfu in
            let attrs = kungfuAttrsMap["\(kungfu.id)", default: []]
            let kungfuColor = mountColorMap[kungfu.name, default: .accentColor]
            let mountEquip = mountEquipMap["\(kungfu.id)"]
            
            return Kungfu(
                id: kungfu.id,
                name: kungfu.name,
                force: kungfu.force,
                kungfuId: kungfu.kungfuId,
                school: kungfu.school,
                client: kungfu.client,
                attrs: attrs,
                color: kungfuColor,
                schoolName: mountEquip?.schoolName ?? "",
                shareSchool: mountEquip?.shareSchool ?? [],
                duty: mountEquip?.duty,
                primaryAttribute: mountEquip?.primaryAttribute ?? ""
            )
        }
        
        self.schoolData = schools.map { school in
            let kungfuModels = self.kungfuData.filter { $0.school == school.id }
            let color = schoolColorMap[school.name!, default: .accentColor]
            
            return School(id: school.id, name: school.name, kungfus: kungfuModels, color: color)
        }
    }
    
    
    private func loadSchool() {
        guard let schoolMap =  BundleUtil.loadJson("school.json", type: [String: SchoolDTO].self)
        else { return }
        
        schools = schoolMap.map { (key: String, value: SchoolDTO) in
            return SchoolDTO(id: value.id, name: key)
        }
        .sorted(by: { s1, s2 in
            s1.id < s2.id
        })
        logger("加载 school.json 成功！")
    }
    
    private func loadKungfu() {
        guard let kungfuMap = BundleUtil.loadJson("xf.json", type: [String: KungfuDTO].self)
        else { return }
        // 过滤掉 山居剑意
        kungfus = kungfuMap.values.map { $0 }.filter { $0.name != "山居剑意" }.sorted(by: { k1, k2 in
            k1.id < k2.id
        })
        logger("加载 xf.json 成功！")
    }
    
    
    private func loadKungfuAttribute() {
        guard let kungfuIdAttrsMap = BundleUtil.loadJson("xfAttrs.json", type: [String: [EquipAttribute]].self)
        else { return }
        self.kungfuAttrsMap = kungfuIdAttrsMap
        
        logger("加载 xfAttrs.json 成功!")
    }
    
    private func loadColors() {
        guard let colorsMap = BundleUtil.loadJson("colors.json", type: [String: [String: String]].self)
        else { return }
        
        if let schoolColorMap = colorsMap[KEY_COLORS_BY_SCHOOL_NAME] {
            self.schoolColorMap = schoolColorMap.mapValues { Color(hex: $0) }
        }
        if let kungfuColorMap = colorsMap[KEY_COLORS_BY_MOUNT_NAME] {
            self.mountColorMap = kungfuColorMap.mapValues { Color(hex: $0) }
            
        }
        
        logger("加载 colors.json 成功!")
    }
    
    private func loadMountEquip() {
        guard let mountEquipMap = BundleUtil.loadJson("mountEquip.json", type: [String: MountEquipDTO].self)
        else { return }
    
        self.mountEquipMap = mountEquipMap
        
        logger("加载 mountEquip.json 成功!")
    }
}

/// 心法
private struct KungfuDTO: Decodable {
    let id: Int
    let name: String
    let force: Int
    let kungfuId: Int
    let school: Int
    let client: [String]
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case force
        case kungfuId
        case school
        case client
    }
}

struct SchoolDTO: Decodable {
    let id: Int
    let name: String?
    
    init(id: Int, name: String?) {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "school_id"
        case name
    }
    
}


//    "name": "孤锋诀",
//    "school_name": "刀宗",
//    "client": ["all", "std"],
//    "duty": "外功",
//    "share_school": ["天策", "丐帮", "唐门", "霸刀"],
//    "primary_weapon_type": "21",
//    "primary_attribute": "力道"
struct MountEquipDTO: Decodable {
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


//
//  AssetJsonDataService.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import Foundation
import SwiftUI


/// 一些静态的 json 资源文件加载管理器
class AssetJsonDataManager {
    
    static let shared = AssetJsonDataManager()
    
    /// 所有门派
    public let schools: [School]
    /// 所有心法
    public let mounts: [Mount]
    
    private let KEY_COLORS_BY_SCHOOL_NAME = "colors_by_school_name"
    private let KEY_COLORS_BY_MOUNT_NAME = "colors_by_mount_name"
    
    // 门派名字 -> 门派颜色
    public let schoolColorMap: [String: Color]
    // 心法名字 -> 心法颜色
    public let mountColorMap: [String: Color]
    // mount.id -> MountEquip
    public let mountId2EquipMap: [String: MountEquip]
    // mount.id -> EquipAttribute
    public let mountId2AttrsMap: [String: [EquipAttribute]]
    // 装备属性 -> 对应的描述
    public let equipAttrMap: [String: String]
    // 装备属性 -> 对应的简短描述
    public let attrBriefDescMap: [String: String]
    // 装备属性 -> 对应的描述
    public let attrDescMap: [String: String]
    // 武器类型编号 -> 武器类型描述
    public let weaponType: [String: String]

    
    private init() {
        self.mountId2EquipMap = BundleUtil.loadJson("mountEquip.json", type: [String: MountEquip].self, defaultValue: [:])
        let colorMap = AssetJsonDataManager.loadColors()
        self.schoolColorMap = colorMap[KEY_COLORS_BY_SCHOOL_NAME, default: [:]]
        self.mountColorMap = colorMap[KEY_COLORS_BY_MOUNT_NAME, default: [:]]
        self.mountId2AttrsMap = BundleUtil.loadJson("xfAttrs.json", type: [String: [EquipAttribute]].self, defaultValue: [:])
        self.mounts = AssetJsonDataManager.loadMounts()
        self.schools = AssetJsonDataManager.loadSchool()
        self.equipAttrMap = BundleUtil.loadJson("equipAttrDesc.json", type: [String: String].self, defaultValue: [:])
        self.attrBriefDescMap = BundleUtil.loadJson("attrBriefDesc.json", type: [String: String].self, defaultValue: [:])
        self.attrDescMap = BundleUtil.loadJson("attrDesc.json", type: [String: String].self, defaultValue: [:])
        self.weaponType = BundleUtil.loadJson("weaponType.json", type: [String: String].self, defaultValue: [:])
    }
    
    
    private static func loadSchool() -> [School] {
        guard let schoolMap =  BundleUtil.loadJson("school.json", type: [String: School].self)
        else { return [] }
        
        logger("加载 school.json 成功！")
        return schoolMap.map { (key: String, value: School) in
            return School(id: value.id, name: key)
        }
        .sorted(by: { s1, s2 in
            s1.id < s2.id
        })
    }
    
    /// 从 xf.json 中加载心法
    /// - Returns: 从 xf.json 中加载的所有心法
    private static func loadMounts() -> [Mount] {
        guard let kungfuMap = BundleUtil.loadJson("xf.json", type: [String: Mount].self)
        else { return [] }
        // 过滤掉 山居剑意
        logger("加载 xf.json 成功！")
        return kungfuMap.values.map { $0 }.filter { $0.name != "山居剑意" }.sorted(by: { k1, k2 in
            k1.id < k2.id
        })
    }
    
    
    /// 加载 color.json 文件
    /// 文件中包含门派和心法的颜色
    /// - Returns: 文件中的门派和心法的颜色
    private static func loadColors() -> [String: [String: Color]]  {
        let colorsMap = BundleUtil.loadJson("colors.json", type: [String: [String: String]].self, defaultValue: [:])
        return colorsMap.mapValues({ values in values.mapValues({ Color(hex: $0) }) })
    }
}

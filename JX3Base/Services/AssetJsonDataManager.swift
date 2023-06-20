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
    
    public let attrMap: [String: String]

    
    private init() {
        self.mountId2EquipMap = AssetJsonDataManager.loadMountEquip()
        let colorMap = AssetJsonDataManager.loadColors()
        self.schoolColorMap = colorMap[KEY_COLORS_BY_SCHOOL_NAME, default: [:]]
        self.mountColorMap = colorMap[KEY_COLORS_BY_MOUNT_NAME, default: [:]]
        self.mountId2AttrsMap = AssetJsonDataManager.loadMountAttribute()
        self.mounts = AssetJsonDataManager.loadMounts()
        self.schools = AssetJsonDataManager.loadSchool()
        self.attrMap = AssetJsonDataManager.loadAttr()
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
    
    
    /// 加载 xfAttrs.json 心法对应的装备检索的属性
    /// - Returns: 心法对应的装备检索的属性
    private static func loadMountAttribute() -> [String: [EquipAttribute]] {
        if let kungfuIdAttrsMap = BundleUtil.loadJson("xfAttrs.json", type: [String: [EquipAttribute]].self) {
            logger("加载 xfAttrs.json 成功!")
            return kungfuIdAttrsMap
        } else {
            logger("加载 xfAttrs.json 失败!")
            return [:]
        }
    }
    
    
    /// 加载 color.json 文件
    /// 文件中包含门派和心法的颜色
    /// - Returns: 文件中的门派和心法的颜色
    private static func loadColors() -> [String: [String: Color]]  {
        if let colorsMap = BundleUtil.loadJson("colors.json", type: [String: [String: String]].self) {
            logger("加载 colors.json 成功!")
            return colorsMap.mapValues({ values in values.mapValues({ Color(hex: $0) }) })
        } else {
            logger("加载 colors.json 失败!")
            return [:]
        }
        
    }
    
    /// 加载 mountEquip.json 文件
    /// - Returns: mountId -> MountEquip 的映射关系
    private static func loadMountEquip() -> [String: MountEquip] {
        if let mountEquipMap = BundleUtil.loadJson("mountEquip.json", type: [String: MountEquip].self) {
            logger("加载 mountEquip.json 成功!")
            return mountEquipMap
        } else {
            logger("加载 mountEquip.json 失败!")
            return [:]
        }
    }
    
    /// 加载 attr.json 文件
    /// - Returns: <#description#>
    private static func loadAttr() -> [String: String] {
        if let attrMap = BundleUtil.loadJson("attr.json", type: [String: String].self) {
            logger("加载 attr.json 成功!")
            return attrMap
        } else {
            logger("加载 attr.json 失败!")
            return [:]
        }
    }
}

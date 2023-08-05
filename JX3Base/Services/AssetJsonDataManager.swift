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
    // 大附魔可以附魔的装备品质
    public let enchantLevelLimit: [String: [String: Int]]
    // 五彩石筛选选项
    public let colorStoneOptions: ColorStoneOptions
    // 可以强化的属性
    public let strengthableAttributes: [String]
    // 心法固定属性
    public let mountId2MountRawAttribute: [String: MountRawAttribute]
    // 心法扩展属性
    public let mountId2MountExtraAttribute: [String: [String: [MountExtraAttribute]]]
    // lua 属性转换为 通用属性转换的 map
    public let luaConvertMapping: [String: LuaConvertValue]
    // 奇穴被动属性加成
    public let talnetPassive: [String: [TalnetPassive]]
    // 系统属性，主要用于主属性的转换
    public let systemAttributes: [String: Float]
    // levelData
    public let levelData: [String: Int]
    // levelConst
    public let levelConst: [String: Float]

    
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
        self.enchantLevelLimit = BundleUtil.loadJson("enchant_level_limit.json", type: [String: [String: Int]].self, defaultValue: [:])
        self.colorStoneOptions = BundleUtil.loadJson("std_color_stone_option.json", type: ColorStoneOptions.self, defaultValue: ColorStoneOptions(t1box: [], t2box: [], t3box: []))
        self.strengthableAttributes = BundleUtil.loadJson("strengthableAttributes.json", type: [String].self, defaultValue: [])
        self.mountId2MountRawAttribute = BundleUtil.loadJson("mountRawAttributes.json", type: [String: MountRawAttribute].self, defaultValue: [:])
        self.mountId2MountExtraAttribute = BundleUtil.loadJson("mountExtraAttributes.json", type: [String: [String: [MountExtraAttribute]]].self, defaultValue: [:])
        self.luaConvertMapping = BundleUtil.loadJson("luaConvertMapping.json", type: [String: LuaConvertValue].self, defaultValue: [:])
        self.talnetPassive = BundleUtil.loadJson("talnetPassive.json", type: [String: [TalnetPassive]].self, defaultValue: [:])
        self.systemAttributes = BundleUtil.loadJson("systemAttributes.json", type: [String: Float].self, defaultValue: [:])
        self.levelData = BundleUtil.loadJson("levelData.json", type: [String: Int].self, defaultValue: [:])
        self.levelConst = BundleUtil.loadJson("levelConst.json", type: [String: Float].self, defaultValue: [:])
    }
    
    
    private static func loadSchool() -> [School] {
        guard let schoolMap =  BundleUtil.loadJson("school.json", type: [String: School].self)
        else { return [] }
        
        logger("加载 school.json 成功！")
        return schoolMap.map { (key: String, value: School) in
            return School(id: value.id, name: key, forceId: value.forceId)
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

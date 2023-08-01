//
//  EquipProgrammeAttributeSet.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/30.
//

import Foundation

// 配装方案属性计算
class EquipProgrammeAttributeSet: Identifiable, Equatable {
    let id = UUID().uuidString
    let equipProgramme: EquipProgramme
    // 使用重剑
    let useHeavy: Bool
    
    // 计算属性结果
    var attributes: [String: EquipProgrammeAttributeValue] = [:]
    
    init(equipProgramme: EquipProgramme, useHeavy: Bool = false) {
        self.equipProgramme = equipProgramme
        self.useHeavy = useHeavy
        calc()
    }
    
    static func == (lhs: EquipProgrammeAttributeSet, rhs: EquipProgrammeAttributeSet) -> Bool {
        return lhs.id == rhs.id
    }
    
    private func calc() {
        attributes = [:]
        /// TODO ⚠️： 一些技能的处理，武器会导致不停刷新
        /// TODO 藏剑武器判断
        for position in equipProgramme.equips.keys {
            if let strengthedEquip = equipProgramme.equips[position] {
                if !((!useHeavy && position == .meleeWeapon2) || (useHeavy && position == .meleeWeapon)) {
                    addEquipBaseAttribute(strengthedEquip)
                    addEquipEmbeddingAttributes(strengthedEquip)
                    addEquipEnchantAttributes(strengthedEquip)
                    addEquipEnchanceAttributes(strengthedEquip)
                }
            }
        }
        addEquipSetAttributes()
        addColorStoneAttribute()
        addSystemAttributes()
        addMountAttribute()
        addAdditionalAttributes()
        addTalentAttributes()
        addBaseAttributes()
    }
    
    /// 添加套装属性
    private func addEquipSetAttributes() {
        for equipSet in self.equipProgramme.equipSet {
            // 统计
            let activeEquips = self.equipProgramme.equips.values.filter { strengthedEquip in
                if let equip = strengthedEquip.equip {
                    return equip.setId == "\(equipSet.id)"
                }
                return false
            }
            let activeCount = activeEquips.count
            // 找一个装备获取套装的属性
            if let equip = activeEquips.first?.equip {
                for i in 1...6 {
                    if activeCount >= i {
                        for attribute in equip.setData[i, default: []] {
                            if let type = attribute.type {
                                if AssetJsonDataManager.shared.equipAttrMap[type] != nil {
                                    addAttribute(type, Float(attribute.min))
                                    logger.info("添加套装属性: \(equipSet.name ?? "未知套")，激活数量：\(activeCount): \(type) \(attribute.min)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// 五行石镶嵌属性
    private func addEquipEmbeddingAttributes(_ strengthedEquip: StrengthedEquip) {
        for attr in strengthedEquip.embeddingStone.keys {
            if let level = strengthedEquip.embeddingStone[attr] {
                let type = attr.attr
                let value = attr.embedValue(level: level)
                addAttribute(type, value)
                logger.debug("\(strengthedEquip.equip?.name ?? "nil") 五行石属性: \(type) \(value)")
            }
        }
    }
    
    /// 添加装备小附魔属性
    private func addEquipEnchanceAttributes(_ strengthedEquip: StrengthedEquip) {
        if let enchant = strengthedEquip.enchance {
            for attr in enchant.attrMap.keys {
                if let value = enchant.attrMap[attr] {
                    addAttribute(attr, value)
                    logger.debug("\(strengthedEquip.equip?.name ?? "未知装备") 小附魔属性: \(attr) \(value)")
                }
            }
        }
    }
    
    /// 添加装备大附魔属性
    private func addEquipEnchantAttributes(_ strengthedEquip: StrengthedEquip) {
        if let enchant = strengthedEquip.enchant {
            for attr in enchant.attrMap.keys {
                if let value = enchant.attrMap[attr] {
                    addAttribute(attr, value)
                    logger.debug("\(strengthedEquip.equip?.name ?? "未知装备") 大附魔属性: \(attr) \(value)")
                }
            }
        }
    }
    
    /// 计算心法属性
    private func addMountAttribute() {
        // 不直接修改 mount 进行获取(山居没有心法, 已经过滤了)
        let mount = equipProgramme.mount
        var mountId = mount.idStr
        if mount.isWenShui && useHeavy {
            mountId = "10145"
        }
        let mountRawAttribute = AssetJsonDataManager.shared.mountId2MountRawAttribute[mountId]
        mountRawAttribute?.skillAttributes.forEach({ attr in
            if let convertAttr = attr.convertAttr {
                if convertAttr.isValue == 1 {
                    let param1Value = attr.param1?.value ?? 0.0
                    let param2Value = attr.param2?.value ?? 0.0
                    let value = param1Value != 0.0 ? param1Value : param2Value
                    addAttribute(convertAttr.slot, value)
                }
            }
        })
        
        // 心法扩展属性计算
        if let mountExtraAttribute = AssetJsonDataManager.shared.mountId2MountExtraAttribute[mountId] {
            for key in mountExtraAttribute.keys {
                if let values = mountExtraAttribute[key] {
                    for extraAttr in values {
                        if let convertAttr = extraAttr.convertAttr {
                            if convertAttr.isValue == 1 {
                                let value = Float(extraAttr.value)
                                addAttribute(convertAttr.slot, value)
                            }
                        }
                    }
                    logger.info("计算心法扩展属性[\(key)]")
                }
            }
        }
    }
    
    /// 属性基础属性
    private func addEquipBaseAttribute(_ strengthedEquip: StrengthedEquip) {
        if let equip = strengthedEquip.equip {
            equip.baseTypes.forEach { baseType in
                addAttribute(baseType.rawValue, Float(baseType.baseMin))
                logger.debug("\(equip.name) 基础属性: \(baseType.rawValue) \(baseType.baseMin)")
            }
            equip.magicTypes.forEach { magicType in
                if let type = magicType.attr[0] {
                    let value = Float(magicType.min + magicType.score(level: strengthedEquip.strengthLevel, maxLevel: equip.maxStrengthLevel))
                    addAttribute(type, value)
                    logger.debug("\(equip.name) 基础属性: \(type) \(value)")
                }
            }
        }
    }
    
    /// 添加五彩石属性
    private func addColorStoneAttribute() {
        if let  equip = useHeavy ? equipProgramme.equips[.meleeWeapon2] : equipProgramme.equips[.meleeWeapon] {
            if let colorStone = equip.colorStone {
                let activeStoneCount = equipProgramme.stoneCount(useHeavy)
                let activeStoneLevel = equipProgramme.stoneTotalLevel(useHeavy)
                for attr in colorStone.attributes {
                    if attr.actived(count: activeStoneCount, level: activeStoneLevel) {
                        addAttribute(attr.id, Float(attr.value1) ?? 0.0)
                    }
                }
            }
        }
    }
    
    /// 添加系统属性
    private func addSystemAttributes() {
        for key in AssetJsonDataManager.shared.systemAttributes.keys {
            if let value = AssetJsonDataManager.shared.systemAttributes[key] {
                addAttribute(key, value)
            }
        }
    }
    
    /// 添加公共额外属性
    private func addAdditionalAttributes() {
        let mountNoAdditionalAttrs = ["10002", "10062", "10243", "10389"]
        let additionalAttrs: [String: Float] = ["atDecriticalDamagePowerBaseKiloNumRate": 100]
        if !mountNoAdditionalAttrs.contains(equipProgramme.mount.idStr) {
            additionalAttrs.forEach { (key: String, value: Float) in
                addAttribute(key, value)
            }
        }
    }
    
    /// 添加奇穴属性
    private func addTalentAttributes() {
        for talent in equipProgramme.talents {
            talent.passiveAttributes.forEach { (key: String, value: Int) in
                addAttribute(key, Float(value))
            }
        }
    }
    
    /// 添加120等级基础属性?
    private func addBaseAttributes() {
        AssetJsonDataManager.shared.levelData.forEach { (key: String, value: Int) in
            addAttribute(key, Float(value))
        }
    }
    
    private func addAttribute(_ type: String, _ value: Float) {
        let attributeValue = attributes[type, default: EquipProgrammeAttributeValue(value: 0.0)]
        let newValue = attributeValue.value + value
        self.attributes[type] = EquipProgrammeAttributeValue(value: newValue)
    }
}

// 属性值
struct EquipProgrammeAttributeValue {
    var value: Float
}

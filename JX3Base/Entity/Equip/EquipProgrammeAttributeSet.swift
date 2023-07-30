//
//  EquipProgrammeAttributeSet.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/30.
//

import Foundation

// 配装方案属性计算
class EquipProgrammeAttributeSet {
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
    
    
    private func calc() {
        attributes = [:]
        /// TODO ⚠️： 一些技能的处理，武器会导致不停刷新
        /// TODO 藏剑武器判断
        addMountAttribute()
        addBaseAttr()
        addMagicAttr()
    }
    
    
    /// 计算心法属性
    private func addMountAttribute() {
        var mount = equipProgramme.mount
        if mount.id == 10144 && useHeavy {
            if let newMount = Mount(id: 10145) {
                mount = newMount
            } else {
                logger.warning("⚠️：无法加载重剑心法:\(10145), 停止计算心法属性！")
                return
            }
        }
        mount.rawAttribute?.skillAttributes.forEach({ attr in
            if let convertAttr = attr.convertAttr {
                if convertAttr.isValue == 1 {
                    let param1Value = attr.param1?.value ?? 0.0
                    let param2Value = attr.param2?.value ?? 0.0
                    let value = param1Value != 0.0 ? param1Value : param2Value
                    addAttribute(convertAttr.slot, value)
                }
            }
        })
    }
    
    private func addBaseAttr() {
        equipProgramme.equips.values.forEach { strengthedEquip in
            if let equip = strengthedEquip.equip {
                equip.baseTypes.forEach { baseType in
                    addAttribute(baseType.rawValue, Float(baseType.baseMin))
                }
            }
        }
    }
    
    private func addMagicAttr() {
        equipProgramme.equips.values.forEach { strengthedEquip in
            if let equip = strengthedEquip.equip {
                equip.magicTypes.forEach { magicType in
                    addAttribute(magicType.attr[0] ?? "", Float(magicType.min + magicType.score(level: strengthedEquip.strengthLevel, maxLevel: equip.maxStrengthLevel)))
                }
            }
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

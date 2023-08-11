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
    // 面板展示的属性
    var panelAttrs: [String: Float] = [:]
    
    var panelAttributes: [PannelAttributeType: Float] = [:]
    // 最终计算的属性
    var finalAttrs: [String: Float] = [:]
    // 所有可以进行 cof 转换的属性
    var convertCofs: [ConvertCofKey: Float] = [:]
    // 所有伤害类型
    let primaryTypes = ["Physics", "Lunar", "Solar", "Neutral", "Poison"]
    
    private let levelConst = AssetJsonDataManager.shared.levelConst
    
    init(equipProgramme: EquipProgramme, useHeavy: Bool = false) {
        self.equipProgramme = equipProgramme
        self.useHeavy = useHeavy
        statistics()
        calc()
    }
    
    static func == (lhs: EquipProgrammeAttributeSet, rhs: EquipProgrammeAttributeSet) -> Bool {
        return lhs.id == rhs.id
    }
    
    // 统计
    private func statistics() {
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
    
    // MARK: 计算面板属性
    private func calc() {
        panelAttrs = [:]
        finalAttrs = [:]
        // 提取所有的 cof 属性
        initConvertCofAttribute()
        
        // 体质
        calcVitality()
        // 根骨
        let spirit = calcPrimaryAttribute("Spirit")
        panelAttributes.add(.spirit, spirit)
        panelAttributes.add(.spiritToMagicCriticalStrike, calcAllCofValue(dest: "NeutralCriticalStrike", isSystem: true)) // 没有内功会心使用 Neutral 代替
        // 力道
        let strength = calcPrimaryAttribute("Strength")
        panelAttributes.add(.strength, strength)
        panelAttributes.add(.strengthToAttack, calcAllCofValue(dest: "PhysicsAttackPower", isSystem: true))
        panelAttributes.add(.strengthToOvercome, calcAllCofValue(dest: "PhysicsOvercome", isSystem: true))
        // 身法
        let agility = calcPrimaryAttribute("Agility")
        panelAttributes.add(.agility, agility)
        panelAttributes.add(.agilityToCriticalStrike, calcAllCofValue(dest: "PhysicsCriticalStrike", isSystem: true))
        // 元气
        let spunk = calcPrimaryAttribute("Spunk")
        panelAttributes.add(.spunk, spunk)
        panelAttributes.add(.spunkToAttack, calcAllCofValue(dest: "NeutralAttackPower", isSystem: true))
        panelAttributes.add(.spunkToOvercome, calcAllCofValue(dest: "NeutralOvercome", isSystem: true))
        
        calcAttackPower()
        calcTherapyPower()
        calcCriticalStrike()
        calcCriticalDamagePower()
        calcOvercome()
        calcHaste()
        calcStrain()
        calcSurplusValue()
        calcPhysicsShield()
        calcMagicShield()
        calcDodge()
        calcParry()
        calcParryValue()
        calcToughness()
        calcDecriticalDamage()
        
        panelAttrs.add("MeleeWeaponAttackSpeed", getAttribute("atMeleeWeaponAttackSpeedBase"))
        panelAttrs.add("MeleeWeaponDamage", getAttribute("atMeleeWeaponDamageBase"))
        panelAttrs.add("MeleeWeaponDamageRand", getAttribute("atMeleeWeaponDamageRand"))
        panelAttrs.add("ActiveThreatCoefficient", getAttribute("atActiveThreatCoefficient"))
    }
    
    // MARK: 添加属性
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
    
    private func getAttribute(_ type: String, isFloat: Bool = false) -> Float {
        let ret = attributes[type]?.value ?? 0.0
        return isFloat ? ret : Float(Int(ret))
    }

    /// 获取最终数值中的属性
    /// - Parameter type: 属性的键值
    /// - Returns: 最终属性中的值
    private func getFinalAttribute(_ type: String) -> Float {
        return finalAttrs[type, default: 0]
    }
    
    // MARK: 计算数值
    
    private func calcPrimaryAttribute(_ primary: String) -> Float {
        // 全属性增加
        let basePotential = getAttribute("atBasePotentialAdd")
        let primaryValue = getAttribute("at\(primary)Base")
        let primaryAddPercent = getAttribute("at\(primary)BasePercentAdd")
        let ret = (basePotential + primaryValue).mul(primaryAddPercent)
        let label = AssetJsonDataManager.shared.attrBriefDescMap["at\(primary)Base", default: primary]
        logger.debug("主属性[\(label)]:\(ret) = (\(basePotential) + \(primaryValue)) * \(1 + primaryAddPercent)")
        panelAttrs.add(primary, ret)
        finalAttrs.add("at\(primary)", ret)
        return ret
    }
    
    /// 计算气血值
    private func calcVitality() {
        // 体质(面板体质 最终体质)
        let vitality = calcPrimaryAttribute("Vitality")
        // 气血值提高
        let atPanelVitalityAddMaxHealth = vitality * 10
        logger.debug("气血值提高[\(atPanelVitalityAddMaxHealth)] = \(vitality) * 10")
        // 基础气血最大值
        let maxLifeBase = getAttribute("atMaxLifeBase")
        let atPanelMaxHealthBase = atPanelVitalityAddMaxHealth + maxLifeBase
        logger.debug("基础气血最大值[\(atPanelMaxHealthBase)] = \(atPanelVitalityAddMaxHealth) + \(maxLifeBase)")
        // 最终气血最大值
        let maxLifePercentAdd = getAttribute("atMaxLifePercentAdd")
        let maxLife = atPanelMaxHealthBase.mul(maxLifePercentAdd)
        logger.debug("最终气血基础值[\(maxLife)] = \(atPanelMaxHealthBase) * (1 + \(maxLifePercentAdd))")
        let maxLifeAdditional = getAttribute("atMaxLifeAdditional")
        let maxLifeAddPercent = getAttribute("atFinalMaxLifeAddPercent")
        let maxAdditionalBaseHealth = (maxLife + maxLifeAdditional).mul(maxLifeAddPercent)
        logger.debug("最终气血最大值[\(maxAdditionalBaseHealth)] = (\(maxLife) + \(maxLifeAdditional)) * (1 + \(maxLifeAddPercent))")
        let vitalityToMaxLife = getCofValue(from: "Vitality", to: "MaxLife")
        logger.debug("体质转换气血[\(vitalityToMaxLife)] cof = \(getAttribute("atVitalityToMaxLifeCof"))")
        let ret = maxAdditionalBaseHealth + vitalityToMaxLife
        logger.debug("最终气血[\(ret)]")
        panelAttrs.add("MaxHealth", ret)
        
        panelAttributes.add(.vitality, vitality)
        panelAttributes.add(.vitalityToHealth, floor(atPanelVitalityAddMaxHealth))
        panelAttributes.add(.vitalityToMaxHealth, floor(atPanelMaxHealthBase))
        panelAttributes.add(.vitalityToFinalMaxHealth, floor(maxAdditionalBaseHealth))
    }
    
    // MARK: 计算攻击力/奶量
    
    /// 计算攻击力/奶量
    /// - Parameters:
    ///   - type: 计算的攻击力/奶量类型
    private func calcPower(_ type: String, isTherapy: Bool = false) {
        let additionType = "\(isTherapy ? "" : "Attack")Power"
        let base = allCalcType(type).reduce(into: 0) { partialResult, calcType in
            partialResult += getAttribute("at\(calcType)\(additionType)Base")
        } + calcAllCofValue(dest: "\(type)\(additionType)", isSystem: true)
        
        panelAttrs.add("\(type)\(additionType)Base", base)
        
        let mountAddConvert = calcAllCofValue(dest: "\(type)\(additionType)")
        let baseWithPercent = base.mul(getAttribute("at\(type)\(additionType)Percent"))
        let final = baseWithPercent + mountAddConvert
        
        panelAttrs.add("\(type)\(additionType)", final)
        finalAttrs.add("at\(type)\(additionType)", final)
        
        let typeDesc = "\(typeDesc(type))\(isTherapy ? "" : "攻击")"
        logger.debug("🗡️基础\(typeDesc): \(base) 最终\(typeDesc): \(final)")
        
        if !isTherapy {
            panelAttributes.add(.init(rawValue: "\(type)Attack")!, base)
            panelAttributes.add(.init(rawValue: "\(type)FinalAttack")!, final)
            
            // TODO 最大值攻击力作为面板显示的值
            let attackMax = max(panelAttributes[.attack, default: 0], final)
            panelAttributes[.attack] = attackMax
        } else {
            panelAttributes.add(.therapyBase, base)
            panelAttributes.add(.therapy, final)
        }
    }
    
    private func calcAttackPower() {
        for type in primaryTypes {
            calcPower(type)
        }
    }
    
    // MARK: 计算治疗
    private func calcTherapyPower() {
        calcPower("Therapy", isTherapy: true)
    }
    
    // MARK: 计算会心
    private func calcCriticalStrike(_ type:String) {
        let base: Float = allCalcType(type).reduce(into: 0.0) { partialResult, calcType in
            partialResult += getAttribute("at\(calcType)CriticalStrike")
        }
        let criticalStrikeLevel = base + calcAllCofValue(dest: "\(type)CriticalStrike") + calcAllCofValue(dest: "\(type)CriticalStrike", isSystem: true)
        
        panelAttrs.add("\(type)CriticalStrike", criticalStrikeLevel)
        finalAttrs.add("at\(type)CriticalStrike", criticalStrikeLevel)
        
        let criticalStrikePercent = criticalStrikeLevel / (levelConst.fCriticalStrikeParam * levelConst.nLevelCoefficient) + getAttribute("at\(type)CriticalStrikeBaseRate") / 10000
        panelAttrs.add("\(type)CriticalStrikeRate", criticalStrikePercent)
        logger.debug("\(typeDesc(type))会心等级: \(criticalStrikeLevel) 会心百分比: \(String(format: "%.02f", criticalStrikePercent * 100))")
        
        panelAttributes.add(.init(rawValue: "\(type)CriticalStrike")!, criticalStrikeLevel)
        panelAttributes.add(.init(rawValue: "\(type)CriticalStrikeRate")!, criticalStrikePercent)
        
        panelAttributes[.CriticalStrike] = max(panelAttributes[.CriticalStrike, default: 0], criticalStrikeLevel)
        panelAttributes[.CriticalStrikeRate] = max(panelAttributes[.CriticalStrikeRate, default: 0], criticalStrikePercent)
    }
    
    private func calcCriticalStrike() {
        for type in primaryTypes {
            calcCriticalStrike(type)
        }
    }
    
    // MARK: 会心效果
    private func calcCriticalDamagePower(_ type: String) {
        // 全属性会效
        let base = allCalcType(type).reduce(into: 0, { partialResult, newType in
            partialResult += getAttribute("at\(type)CriticalDamagePowerBase")
        }) + calcAllCofValue(dest: "\(type)CriticalDamagePower")
        panelAttrs.add("\(type)CriticalDamagePower", base)
        
        
        let percentWithKiloBase = base.mul(getAttribute("at\(type)CriticalDamagePowerPercent"))
        let percent = percentWithKiloBase.mul(getAttribute("at\(type)CriticalDamagePowerBaseKiloNumRate"), base: 1000)
        
        // 额外百分比
        let baseKiloNumRate = type == "Physics" ? 0 : getAttribute("atMagicCriticalDamagePowerBaseKiloNumRate")
        let panelPercent = (levelConst.fPlayerCriticalCof + 1) + percent / (levelConst.fCriticalStrikePowerParam * levelConst.nLevelCoefficient) + baseKiloNumRate / 10000
        panelAttrs.add("\(type)CriticalDamagePowerPercent", panelPercent)
        finalAttrs.add("at\(type)CriticalDamagePowerPercent", panelPercent)
        logger.debug("\(typeDesc(type))会效等级: \(base) 会效百分比: \(String(format: "%.02f%%", panelPercent * 100))")
        
        panelAttributes.storeMax(.CriticalDamagePowerPercent, panelPercent)
        panelAttributes.add(.init(rawValue: "\(type)CriticalDamagePower")!, base)
        panelAttributes.add(.init(rawValue: "\(type)CriticalDamagePowerPercent")!, panelPercent)
    }
    
    private func calcCriticalDamagePower() {
        for type in primaryTypes {
            calcCriticalDamagePower(type)
        }
    }
    
    // MARK: 破防
    private func calcOvercome(_ type: String) {
        // 基础破防
        let base = allCalcType(type).reduce(into: 0) { partialResult, calcType in
            partialResult += getAttribute("at\(calcType)OvercomeBase")
        } + calcAllCofValue(dest: "\(type)Overcome", isSystem: true)
        panelAttrs.add("\(type)OvercomeBase", base)
        
        let panelOvercome = base + calcAllCofValue(dest: "\(type)Overcome")
        panelAttrs.add("\(type)Overcome", panelOvercome)
        
        let overcomePercent = panelOvercome.mul(getAttribute("at\(type)OvercomePercent")) / (levelConst.fOvercomeParam * levelConst.nLevelCoefficient)
        panelAttrs.add("\(type)OvercomePercent", overcomePercent)
        finalAttrs.add("at\(type)OvercomePercent", overcomePercent)
         
        logger.debug("\(typeDesc(type))基础破防: \(base) 破防等级: \(panelOvercome) 破防百分比: \(String(format: "%.02f%%", overcomePercent * 100))")
        
        panelAttributes.storeMax(.init(rawValue: "OvercomePercent")!, overcomePercent)
        panelAttributes.add(.init(rawValue: "\(type)Overcome")!, panelOvercome)
        panelAttributes.add(.init(rawValue: "\(type)OvercomePercent")!, overcomePercent)
    }
    
    private func calcOvercome() {
        for type in primaryTypes {
            calcOvercome(type)
        }
    }
    
    // MARK: 加速
    private func calcHaste() {
        let hasteBase = getAttribute("atHasteBase")
        panelAttrs.add("Haste", hasteBase)
        finalAttrs.add("atHaste", hasteBase)
        
        let hastePercent = hasteBase / (levelConst.fHasteRate * levelConst.nLevelCoefficient) + getAttribute("atHasteBasePercentAdd") / 1024
        panelAttrs.add("HastePercent", hastePercent)
        
        logger.debug("加速等级: \(hasteBase) 加速百分比:\(String(format: "%.02f%%", hastePercent * 100))")
        
        panelAttributes.add(.Haste, hasteBase)
        panelAttributes.add(.HastePercent, hastePercent)
    }
    
    // MARK: 无双
    private func calcStrain() {
        let strainBase = getAttribute("atStrainBase").mul(getAttribute("atStrainPercent"))
        panelAttrs.add("Strain", strainBase)
        
        let strainPercent = strainBase / (levelConst.fInsightParam * levelConst.nLevelCoefficient) + getAttribute("atStrainRate")
        panelAttrs.add("StrainPercent", strainPercent)
        finalAttrs.add("atStrain", strainPercent)
        
        logger.debug("无双等级: \(strainBase) 无双百分比: \(String(format: "%.02f%%", strainPercent * 100))")
        
        panelAttributes.add(.Strain, strainBase)
        panelAttributes.add(.StrainPercent, strainPercent)
    }
    
    // MARK: 破招
    private func calcSurplusValue() {
        let surplusValueBase = getAttribute("atSurplusValueBase").mul(getAttribute("atSurplusValuePercent"))
        panelAttrs.add("SurplusValue", surplusValueBase)
        
        let surplusValuePercent = surplusValueBase / (levelConst.fInsightParam * levelConst.nLevelCoefficient)
        panelAttrs.add("SurplusValuePercent", surplusValuePercent)
        finalAttrs.add("atSurplusValue", surplusValuePercent)
        
        logger.debug("破招等级: \(surplusValueBase) 破招百分比: \(String(format: "%.02f%%", surplusValuePercent * 100))")
        
        panelAttributes.add(.SurplusValue, surplusValueBase)
    }
    
    // MARK: 外防
    private func calcPhysicsShield() {
        let base = getAttribute("atPhysicsShieldBase")
        panelAttrs.add("PhysicsShieldBase", base)
        
        let final = base.mul(getAttribute("atPhysicsShieldPercent")) + getAttribute("atPhysicsShieldAdditional") + calcAllCofValue(dest: "PhysicsShield")
        panelAttrs.add("PhysicsShield", final)
        let finalPercent = final / (final + levelConst.fPhysicsShieldParam * levelConst.nLevelCoefficient)
        panelAttrs.add("PhysicsShieldPercent", finalPercent)
        
        logger.debug("基础外防: \(base) 最终外防等级: \(final) 最终外防百分比: \(String(format: "%.02f%%", finalPercent * 100))")
    }
    
    // MARK: 内防
    private func calcMagicShield(_ type: String) {
        let base = getAttribute("atMagicShield") + getAttribute("at\(type)MagicShieldBase")
        panelAttrs.add("\(type)ShieldBase", base)
        
        let final = base.mul(getAttribute("at\(type)MagicShieldPercent")) + calcAllCofValue(dest: "MagicShield") + calcAllCofValue(dest: "\(type)MagicShield")
        panelAttrs.add("\(type)Shield", final)
        let finalPercent = final / (final + levelConst.fMagicShieldParam * levelConst.nLevelCoefficient)
        panelAttrs.add("\(type)ShieldPercent", finalPercent)
        
        let typeDesc = typeDesc(type)
        logger.debug("基础\(typeDesc)防御: \(base) 最终\(typeDesc)防御: \(final) 最终\(typeDesc)防御: \(String(format: "%.02f%%", finalPercent * 100))")
    }
    
    private func calcMagicShield() {
        for type in primaryTypes {
            if type != "Physics" {
                calcMagicShield(type)
            }
        }
    }
    
    // MARK: 闪避
    private func calcDodge() {
        let base = getAttribute("atDodge") + calcAllCofValue(dest: "Dodge")
        let panelDodge = base.mul(0, base: 1000)
        panelAttrs.add("Dodge", panelDodge)
        let dodgePercent = panelDodge / (panelDodge + levelConst.fDodgeParam * levelConst.nLevelCoefficient) + getAttribute("atDodgeBaseRate") / 10000
        panelAttrs.add("DodgePercent", dodgePercent)
        
        logger.debug("闪避等级: \(panelDodge) 闪避百分比: \(String(format: "%.02f%%", dodgePercent * 100))")
    }
    
    // MARK: 招架
    private func calcParry() {
        let base = getAttribute("atParryBase") + calcAllCofValue(dest: "Parry")
        let pannelParry = base.mul(0, base: 1000)
        panelAttrs.add("Parry", pannelParry)
        let parryPercent = pannelParry / (pannelParry + levelConst.fParryParam * levelConst.nLevelCoefficient) + getAttribute("atDodgeBaseRate") / 10000
        panelAttrs.add("ParryPercent", parryPercent)
        
        logger.debug("招架等级: \(pannelParry) 招架百分比: \(String(format: "%.02f%%", parryPercent * 100))")
    }
    
    // MARK: 拆招
    private func calcParryValue() {
        let base = getAttribute("atParryValueBase") + calcAllCofValue(dest: "ParryValue")
        let pannelParryValue = base.mul(getAttribute("atParryValuePercent"))
        
        panelAttrs.add("ParryValue", pannelParryValue)
        
        logger.debug("拆招等级: \(pannelParryValue)")
    }
    
    // MARK: 御劲
    private func calcToughness() {
        let toughness = getAttribute("atToughnessBase").mul(getAttribute("atToughnessBaseRate"), base: 1000).mul(getAttribute("atToughnessPercent"))
        panelAttrs.add("Toughness", toughness)
        
        // 减会心
        let toughnessDefCriticalPercent = toughness / (levelConst.fDefCriticalStrikeParam * levelConst.nLevelCoefficient)
        panelAttrs.add("ToughnessDefCriticalPercent", toughnessDefCriticalPercent)
        
        // 减会伤
        let toughnessDecirDamagePercent = toughness / (levelConst.fToughnessDecirDamageCof * levelConst.nLevelCoefficient)
        panelAttrs.add("ToughnessDecirDamagePercent", toughnessDecirDamagePercent)
        
        logger.debug("御劲等级: \(toughness) 御劲减会心百分比: \(String(format: "%.02f%%", toughnessDefCriticalPercent * 100)) 御劲减会伤百分比: \(String(format: "%.02f%%", toughnessDecirDamagePercent * 100))")
    }
    
    // MARK: 化劲
    private func calcDecriticalDamage() {
        let base = getAttribute("atDecriticalDamagePowerBase").mul(getAttribute("atDecriticalDamagePowerPercent"))
        panelAttrs.add("DecriticalDamage", base)
        
        let percent = base / (levelConst.fDecriticalStrikePowerParam * levelConst.nLevelCoefficient + base) + getAttribute("atDecriticalDamagePowerBaseKiloNumRate") / 1000
        panelAttrs.add("DecriticalDamagePercent", percent)
        
        logger.debug("化劲等级: \(base) 化劲百分比: \(String(format: "%.02f%%", percent * 100))")
    }
    
    // MARK: 属性转换
    // 此处定义两种属性转化：
    // 系统转化节点 - 即系统固定的属性转化，同一版本固定持久存在，命名为atSystem{Base}To{Dest}Cof
    // 常规转化节点 - 即其他属性转化，动态存在，可能来源心法或奇穴等，命名为at{Base}To{Dest}Cof
    
    /// 提取所有的可以进行属性转换和数值
    private func initConvertCofAttribute() {
        self.convertCofs = [:]
        for key in attributes.keys {
            if key.hasSuffix("Cof") {
                let regex = /at(.*?)To(.*?)Cof/
                if let match = try? regex.wholeMatch(in: key) {
                    let cofKey = ConvertCofKey(from: String(match.1), cof: String(match.2))
                    self.convertCofs[cofKey] = getAttribute(key, isFloat: true)
                }
            }
        }
    }
    
    /// 获取 cof 转换后的值
    /// from 从 finalAttrs 中获取
    /// - Parameters:
    ///   - from: 数据来源键
    ///   - to: 要转换成的数据键
    ///   - isSystem: 是否是 System 的转换, 例如: atSystemSpiritToSolarCriticalStrikeCof
    /// - Returns: cof 转换后的数值
    private func getCofValue(from: String, to: String, isSystem: Bool = false) -> Float {
        let key = ConvertCofKey(from: "\(isSystem ? "System" : "")\(from)", cof: to)
        if let cofValue = convertCofs[key] {
            let fromValue = getFinalAttribute("at\(from)")
            let ret = floor(fromValue * cofValue / 1024)
            logger.debug("🔄属性转换\(isSystem ? "[⚠️:System]" : "")[\(from)➡️\(to)] : \(fromValue)➡️\(ret)")
            return ret
        }
        
        return 0
    }
    
    /// 获取所有可以转换为指定属性的转换后的数值。
    /// 从 convertCofs 中获取所有可以转换为 dest 的属性，并从 finalAttrs 获取原属性的值进行计算后求和。
    /// - Parameter dest: 要转换的属性名称
    /// - Parameter isSystem: 原属性是否包含为 system 开头的属性
    /// - Returns: 所有可以转换为该属性的值转换后的值的和
    private func calcAllCofValue(dest: String, isSystem: Bool = false) -> Float {
        let keys = convertCofs.keys.filter { $0.cof == dest }
        var ret: Float = 0
        for key in keys {
            if key.from.hasPrefix("System") && isSystem {
                ret += getCofValue(from: key.from.replacingOccurrences(of: "System", with: ""), to: key.cof, isSystem: true)
            }
            if !key.from.hasPrefix("System") && !isSystem {
                ret += getCofValue(from: key.from, to: key.cof)
            }
        }
        return ret
    }
    
    
    
    // 类型可以用来计算的附加属性。比如
    // Physics -> Physics, AllType
    // Lunar -> Lunar, Magic, AllType, SolarAndLunar
    private func allCalcType(_ type: String) -> [String] {
        switch type {
        case "Physics": return [type, "AllType"]
        case "Lunar": return [type, "AllType", "SolarAndLunar", "Magic"]
        case "Solar": return [type, "AllType", "SolarAndLunar", "Magic"]
        case "Neutral": return [type, "AllType", "Magic"]
        case "Poison": return [type, "AllType", "Magic"]
        default: return [type]
        }
    }
    
    // 伤害类型描述
    private func typeDesc(_ type: String) -> String {
        switch type {
        case "Physics": return "外功"
        case "Lunar": return "阴性"
        case "Solar": return "阳性"
        case "Neutral": return "混元"
        case "Poison": return "毒性"
        case "Therapy": return "治疗"
        default: return type
        }
    }
}

// 属性值
struct EquipProgrammeAttributeValue {
    var value: Float
}


fileprivate extension Float {
    func mul(_ addPercent: Float, base: Float = 1024) -> Float {
        return self * (1 + addPercent / base)
    }
    
    func mulKiloBase(_ addPercent: Float) -> Float {
        return mul(addPercent, base: 1000)
    }
}

fileprivate extension Dictionary where Key: Hashable, Value == Float {
    mutating func add(_ key: Key, _ addValue: Float) {
        self[key] = self[key, default: 0] + addValue
    }
    
    mutating func storeMax(_ key: Key, _ value: Float) {
        let oldValue = self[key, default: 0]
        self[key] = oldValue > value ? oldValue : value
    }
}

struct ConvertCofKey: Equatable, Hashable {
    let from: String
    let cof: String
    
    static func ==(lhs: ConvertCofKey, rhs: ConvertCofKey) -> Bool {
        return lhs.cof == rhs.cof
        && lhs.from == rhs.from
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(cof)
    }
    
    var hashValue: Int {
        return from.hashValue + cof.hashValue
    }
}

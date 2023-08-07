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
    // 最终计算的属性
    var finalAttrs: [String: Float] = [:]
    // 所有可以进行 cof 转换的属性
    var convertCofs: [ConvertCofKey: Float] = [:]
    // 所有伤害类型
    let primaryTypes = ["Physics", "Lunar", "Solar", "Neutral", "Poison"]
    
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
    
    private func calc() {
        panelAttrs = [:]
        finalAttrs = [:]
        // 提取所有的 cof 属性
        initConvertCofAttribute()
        
        // 体质
        calcVitality()
        // 身法
        let _ = calcPrimaryAttribute("Agility")
        // 根骨
        let _ = calcPrimaryAttribute("Spirit")
        // 元气
        let _ = calcPrimaryAttribute("Spunk")
        // 力道
        let _ = calcPrimaryAttribute("Strength")
        
        calcAttackPower()
        calcTherapyPower()
        calcCriticalStrike()
        calcCriticalDamagePower()
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
    }
    
    // MARK: 计算攻击力
    
    /// 计算攻击力
    /// - Parameters:
    ///   - type: 计算的攻击力类型
    ///   - additional: 附加的基础攻击力
    ///   - typeDesc: logger 描述
    private func calcAttackPower(_ type: String, _ additional: Float..., typeDesc: String) {
        let base = getAttribute("at\(type)Base")
        let cofConvert = calcAllCofValue(dest: type, isSystem: true)
        let panalBase = base + cofConvert + additional.reduce(into: 0, { partialResult, value in
            partialResult += value
        })
        logger.debug("🗡️基础\(typeDesc): \(panalBase)")
        panelAttrs.add("\(type)Base", panalBase)
        
        let mountAddConvert = calcAllCofValue(dest: type)
        let baseWithPercent = panalBase.mul(getAttribute("at\(type)Percent"))
        let final = baseWithPercent + mountAddConvert
        logger.debug("🗡️最终\(typeDesc): \(final)")
        panelAttrs.add(type, final)
        finalAttrs.add("at\(type)", final)
    }
    
    private func calcAttackPower() {
        // 外功攻击
        calcAttackPower("PhysicsAttackPower", typeDesc: "外功攻击")
        // 阴阳基础
        let atSolarAndLunarAttackPowerBase = getAttribute("atSolarAndLunarAttackPowerBase")
        // 魔法基础
        let atMagicAttackPowerBase = getAttribute("atMagicAttackPowerBase")
        // 阴性攻击
        calcAttackPower("LunarAttackPower", atSolarAndLunarAttackPowerBase, atMagicAttackPowerBase, typeDesc: "阴性攻击")
        // 阳性攻击
        calcAttackPower("SolarAttackPower", atSolarAndLunarAttackPowerBase, atMagicAttackPowerBase, typeDesc: "阳性攻击")
        // 混元攻击
        calcAttackPower("NeutralAttackPower", atMagicAttackPowerBase, typeDesc: "混元攻击")
        // 毒性攻击
        calcAttackPower("PoisonAttackPower", atMagicAttackPowerBase, typeDesc: "毒性攻击")
    }
    
    // MARK: 计算治疗
    private func calcTherapyPower() {
        calcAttackPower("TherapyPower", typeDesc: "治疗")
    }
    
    // MARK: 计算会心
    private func calcCriticalStrike(_ type:String, _ additional: Float..., typeDesc: String) {
        let base = getAttribute("at\(type)CriticalStrike")
        let all = getAttribute("atAllTypeCriticalStrike")
        let criticalStrikeLevel = base + all + additional.reduce(into: 0, { partialResult, value in
            partialResult += value
        }) + calcAllCofValue(dest: "\(type)CriticalStrike") + calcAllCofValue(dest: "\(type)CriticalStrike", isSystem: true)
        panelAttrs.add("\(type)CriticalStrike", criticalStrikeLevel)
        finalAttrs.add("at\(type)CriticalStrike", criticalStrikeLevel)
        
        let levelConst = AssetJsonDataManager.shared.levelConst
        let fCriticalStrikeParam = levelConst["fCriticalStrikeParam", default: 0]
        let nLevelCoefficient = levelConst["nLevelCoefficient", default: 0]
        
        let criticalStrikePercent = criticalStrikeLevel / (fCriticalStrikeParam * nLevelCoefficient) + getAttribute("at\(type)CriticalStrikeBaseRate") / 10000
        panelAttrs.add("\(type)CriticalStrikeRate", criticalStrikePercent)
        logger.debug("\(typeDesc)会心等级: \(criticalStrikeLevel) 会心百分比: \(String(format: "%.02f", criticalStrikePercent * 100))")
    }
    
    private func calcCriticalStrike() {
        // 外功会心
        calcCriticalStrike("Physics", typeDesc: "外功")
        let atMagicCriticalStrike = getAttribute("atMagicCriticalStrike")
        let atSolarAndLunarCriticalStrike = getAttribute("atSolarAndLunarCriticalStrike")
        
        calcCriticalStrike("Lunar", atMagicCriticalStrike, atSolarAndLunarCriticalStrike, typeDesc: "阴性")
        
        calcCriticalStrike("Solar", atMagicCriticalStrike, atSolarAndLunarCriticalStrike, typeDesc: "阳性")
        
        calcCriticalStrike("Neutral", atMagicCriticalStrike, typeDesc: "混元")
        
        calcCriticalStrike("Poison", atMagicCriticalStrike, typeDesc: "毒性")
        
    }
    
    // MARK: 会心效果
    private func calcCriticalDamagePower(_ type: String) {
        // 全属性会效
        let base = type.typeExtensions.reduce(into: 0, { partialResult, newType in
            partialResult += getAttribute("at\(type)CriticalDamagePowerBase")
        }) + calcAllCofValue(dest: "\(type)CriticalDamagePower")
        panelAttrs.add("\(type)CriticalDamagePower", base)
        logger.debug("\(type.typeDesc)会效等级: \(base)")
        
        let levelConst = AssetJsonDataManager.shared.levelConst
        let fPlayerCriticalCof = levelConst["fPlayerCriticalCof", default: 0]
        let fCriticalStrikePowerParam = levelConst["fCriticalStrikePowerParam", default: 0]
        let nLevelCoefficient = levelConst["nLevelCoefficient", default: 0]
        
        let percentWithKiloBase = base.mul(getAttribute("at\(type)CriticalDamagePowerPercent"))
        let percent = percentWithKiloBase.mul(getAttribute("at\(type)CriticalDamagePowerBaseKiloNumRate"), base: 1000)
        
        // 额外百分比
        let baseKiloNumRate = type == "Physics" ? 0 : getAttribute("atMagicCriticalDamagePowerBaseKiloNumRate")
        
        let panelPercent = (fPlayerCriticalCof + 1) + percent / (fCriticalStrikePowerParam * nLevelCoefficient) + baseKiloNumRate / 10000
        panelAttrs.add("\(type)CriticalDamagePowerPercent", panelPercent)
        finalAttrs.add("at\(type)CriticalDamagePowerPercent", panelPercent)
        logger.debug("\(type.typeDesc)会效百分比: \(String(format: "%.02f%%", panelPercent * 100))")
    }
    
    private func calcCriticalDamagePower() {
        for type in primaryTypes {
            calcCriticalDamagePower(type)
        }
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

fileprivate extension Dictionary where Key == String, Value == Float {
    mutating func add(_ key: String, _ addValue: Float) {
        self[key] = self[key, default: 0] + addValue
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


fileprivate extension String {
    // 类型描述
    var typeDesc: String {
        switch self {
        case "Physics": return "外功"
        case "Lunar": return "阴性"
        case "Solar": return "阳性"
        case "Neutral": return "混元"
        case "Poison": return "毒性"
        default: return self
        }
    }
    
    // 类型可以用来计算的附加属性。比如
    // Physics -> Physics, AllType
    // Lunar -> Lunar, Magic, AllType, SolarAndLunar
    var typeExtensions: [String] {
        switch self {
        case "Physics": return [self, "AllType"]
        case "Lunar": return [self, "AllType", "SolarAndLunar", "Magic"]
        case "Solar": return [self, "AllType", "SolarAndLunar", "Magic"]
        case "Neutral": return [self, "AllType", "Magic"]
        case "Poison": return [self, "AllType", "Magic"]
        default: return [self]
        }
    }
}

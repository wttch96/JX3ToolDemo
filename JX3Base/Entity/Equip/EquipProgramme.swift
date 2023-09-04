//
//  EquipProgramme.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/29.
//

import Foundation
import Combine

// MARK: Entity
/// 配装方案
struct EquipProgramme: Codable {
    let mount: Mount
    let equips: [EquipPosition: StrengthedEquip]
    let talents: [Talent]
    let useHeary: Bool
}

// MARK: DAO 扩展
extension EquipProgrammeRecord {
    
    /// 将 CoreData 存储的实体对象转换为 ViewModel
    /// - Parameter mount: 心法
    /// - Returns: CoreData 保存的json 反序列化后转换的 ViewModel
    func toViewModel(mount: Mount) -> EquipProgrammeViewModel {
        let ep = EquipProgrammeViewModel(mount: mount)
        
        if let jsonData = self.jsonData, !jsonData.isEmpty,
            let jsonData = jsonData.data(using: .utf8) {
            // 解析附加的 json 数据，配装信息就保存在这里
            if let equipProgramme = try? JSONDecoder().decode(EquipProgramme.self, from: jsonData) {
                ep.equips = equipProgramme.equips.mapValues({ StrengthedEquipViewModel(entity: $0) })
                ep.talents = equipProgramme.talents
                ep.useHeary = equipProgramme.useHeary
            }
        }
        
        return ep
    }
}

// MARK: ViewModel
/// 配装方案 ViewModel
class EquipProgrammeViewModel: ObservableObject {
    @Published var mount: Mount
    @Published var equips: [EquipPosition: StrengthedEquipViewModel] = [:]
    @Published var talents: [Talent] = []
    
    @Published var useHeary: Bool = false
    
    var publisher = PassthroughSubject<EquipProgrammeAttributeSet, Never>()
    
    var equipSet: Set<EquipSet> = Set()
    
    init(mount: Mount) {
        self.mount = mount
    }
    
    func calcAttributes() {
        //  ⚠️：此处导致一直刷新 UI
        logger.info("⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️计算配装属性...")
        
        let attributes = EquipProgrammeAttributeSet(equipProgramme: self, useHeavy: useHeary)
        publisher.send(attributes)
        logger.info("⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️计算配装属性完成✅")
    }
    
    
    /// 将ViewModel转换为可以 Codable 的实体对象
    /// - Returns: 可以 Codable 的 Entity 实体对象
    func toEntity() -> EquipProgramme {
        return EquipProgramme(mount: mount, equips: equips.mapValues({ $0.toEntity() }), talents: talents, useHeary: useHeary)
    }
}

extension EquipProgrammeViewModel {
    
    // 配装方案总五行石数量
    var stoneCount: Int {
        return stoneCount(false)
    }
    // 配装方案总五行石等级
    var stoneTotalLevel: Int {
        return stoneTotalLevel(false)
    }
    // 配装方案总五行石数量
    func stoneCount(_ useHeary: Bool) -> Int {
        return equips(useHeary).reduce(into: 0) { partialResult, strengthedEquip in
            partialResult += strengthedEquip.embeddingStone.count
        }
    }
    
    // 配装方案总五行石等级
    func stoneTotalLevel(_ useHeary: Bool) -> Int {
        return equips(useHeary).reduce(into: 0) { partialResult, strengthedEquip in
            let totalLevel = strengthedEquip.embeddingStone.values.reduce(into: 0) { partialResult, level in
                partialResult += level
            }
            partialResult += totalLevel
        }
    }
    
    private func equips(_ useHeary: Bool) -> [StrengthedEquipViewModel] {
        if mount.isWenShui {
            var ret: [StrengthedEquipViewModel] = []
            for pos in equips.keys {
                if let strengthedEquip = equips[pos] {
                    // 处理藏剑
                    if pos == .meleeWeapon || pos == .meleeWeapon2 {
                        if (useHeary && pos == .meleeWeapon2) || (!useHeary && pos == .meleeWeapon) {
                            ret.append(strengthedEquip)
                        }
                    } else {
                        ret.append(strengthedEquip)
                    }
                }
            }
            return ret
        } else {
            return equips.values.shuffled()
        }
    }
    
    // 判断五彩石属性是否激活
    func actived(_ attr: ColorStoneAttribute, useHeary: Bool) -> Bool {
        return attr.actived(count: stoneCount(useHeary), level: stoneTotalLevel(useHeary))
    }
    
    // 配装总装分
    var totalScore: Int {
        var score = 0
        for pos in equips.keys {
            if let strengthedEquip = equips[pos] {
                if (pos == .meleeWeapon || pos == .meleeWeapon2) && mount.isWenShui {
                    // 藏剑
                    score += strengthedEquip.totalScore / 2
                } else {
                    score += strengthedEquip.totalScore
                }
            }
        }
        return score
    }
}

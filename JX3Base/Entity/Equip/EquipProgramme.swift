//
//  EquipProgramme.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/29.
//

import Foundation
import Combine

// 配装方案
class EquipProgramme: ObservableObject {
    @Published var mount: Mount
    @Published var equips: [EquipPosition: StrengthedEquip] = [:]
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
    
}

extension EquipProgramme {
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
    
    private func equips(_ useHeary: Bool) -> [StrengthedEquip] {
        if mount.isWenShui {
            var ret: [StrengthedEquip] = []
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

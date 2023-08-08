//
//  LevelConst.swift
//  JX3Demo
//
//  Created by Wttch on 2023/8/8.
//

import Foundation

struct LevelConst: Decodable {
    // 基础会效
    let fPlayerCriticalCof: Float
    // 会心
    let fCriticalStrikeParam: Float
    // 会效
    let fCriticalStrikePowerParam: Float
    // 御劲
    let fDefCriticalStrikeParam: Float
    // 化劲
    let fDecriticalStrikePowerParam: Float
    // 命中
    let fHitValueParam: Float
    // 闪避
    let fDodgeParam: Float
    // 招架
    let fParryParam: Float
    // 无双
    let fInsightParam: Float
    // 外防
    let fPhysicsShieldParam: Float
    // 内防
    let fMagicShieldParam: Float
    // 破防
    let fOvercomeParam: Float
    // 加速
    let fHasteRate: Float
    // 御劲减会伤
    let fToughnessDecirDamageCof: Float
    // 破招基础
    let fSurplusParam: Float
    // 凝神
    let nLevelCoefficient: Float
    let nMaxLevel: Float
    let nAttributeConst: Float
    
    static let shared = LevelConst(fPlayerCriticalCof: 0, fCriticalStrikeParam: 0, fCriticalStrikePowerParam: 0, fDefCriticalStrikeParam: 0, fDecriticalStrikePowerParam: 0, fHitValueParam: 0, fDodgeParam: 0, fParryParam: 0, fInsightParam: 0, fPhysicsShieldParam: 0, fMagicShieldParam: 0, fOvercomeParam: 0, fHasteRate: 0, fToughnessDecirDamageCof: 0, fSurplusParam: 0, nLevelCoefficient: 0, nMaxLevel: 0, nAttributeConst: 0)
}

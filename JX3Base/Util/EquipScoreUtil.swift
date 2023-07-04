//
//  EquipScoreUtil.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/23.
//

import Foundation


class ScoreUtil {
    
    // 品质系数
    private static let equipment_quality_coefficients = [
        "1": 0.8, //白
        "2": 1.4, //绿
        "3": 1.6, //蓝
        "4": 1.8, //紫
        "5": 2.5, //橙
    ]
    // 部位系数
    private static let equipment_position_coefficients = [
        "0": 1.2, //武器
        "1": 0.6, //暗器
        "2": 1, //衣服
        "3": 0.9, //帽子
        "4": 0.5, //项链
        "5": 0.5, //戒指
        "6": 0.7, //腰带
        "7": 0.5, //腰坠
        "8": 1, //裤子
        "9": 0.7, //鞋子
        "10": 0.7, //护腕
    ]
    
    
    // 怀旧服装备精炼分数随精炼等级系数表
    private static let originStrengthLookup = [0, 0.009, 0.0234, 0.0432, 0.0684, 0.10971, 0.15831, 0.2142, 0.27738, 0.34785, 0.42561]
    
    /// 3. 精炼成长
    /// 此处仅用作精炼对属性的成长值计算，不适用装分
    /// @param {*} base 原数值
    /// @param {*} strengthLevel 精炼强度1-8
    /// @param {*} client 客户端版本
    /// @param {*} equipLevel 装备品级
    ///
    /// - Parameters:
    /// - base: 原数值
    /// - strengthLevel: 精炼强度1-8
    /// - client: 客户端版本
    /// - equipLevel: 装备品级
    static func getStrengthScore(base : Int, strengthLevel : Int, client: String = "std", equipLevel: Int) -> Int {
        let fx = client == "std" ? Double(strengthLevel) * (0.7 + 0.3 * Double(strengthLevel)) / 200 : originStrengthLookup[strengthLevel]
        let gx = Double(strengthLevel) * (Double(strengthLevel) + 3) / 2;
        
        let z1 = round(Double(base) * fx);
        let z2 = round(Double(base) * 942 * gx / Double(942 * equipLevel - 7320))
        
        if client == "std" { return Int(z1) }
        if client == "origin" { return Int(max(z1, z2, 1)) }
        return 0
    }
    
    ///  4.装备原始分数
    ///  装备分数 = 装等 * 品质系数 * 部位系数
    /// - Parameters:
    ///   - level: 装等
    ///   - quality: 品质（颜色）
    ///   - position: 位置
    static func getEquipScore(level : Int, quality : String, position : String) -> Int {
        if let qualityCoefficient = equipment_quality_coefficients[quality],
           let positionCoefficient = equipment_position_coefficients[position] {
            return Int(round(Double(level) * qualityCoefficient * positionCoefficient))
        }
        
        return 0
    }
    
    
    ///**
    // * 装分和品质成长
    // * 缘起与重制一致
    // * @param {*} base 原装备品质或原装备分数
    // * @param {*} strengthLevel 精炼强度1-8
    // * @param {*} client 客户端分支
    // * @param {*} type 计算的数值类型(quality-品质等级 score-装分)
    // * @param {*} equipQuality 装备的品级(颜色)
    // * @param {*} equipPosition 装备部位id
    // * @param {*} equipLevel 装备等级 装备表内的
    // * @returns {number} 如`base`传入装备品质则为品质的精炼提升量，如传入装分则为装分提升量
    // */
    //const getGsStrengthScore = (base, strengthLevel, { client = "std", type, equipQuality, equipPosition, equipLevel } = {}) => {
    //    if (client === "origin") {
    //        if (type === "quality") {  // 缘起装备品质使用原有算法
    //            return Math.round(base * originStrengthLookup[strengthLevel]);
    //        }
    //        // 从装备分数计算装备品质 for 怀旧服新算法
    //        //const equipQualityLevel = Math.floor(base / equipment_quality_coefficients[equipQuality] / equipment_position_coefficients[equipPosition]);
    //        const equipQualityLevel = equipLevel;
    //        // 缘起装分先依据新旧算法取max
    //        const strengthCoefficientOld = equipQualityLevel * originStrengthLookup[strengthLevel];
    //        const strengthCoefficientNew = (strengthLevel * (strengthLevel + 3)) * 0.5;
    //
    //        const finalStrength =   // 根据装分转换表进行对应相乘将品质等级转化为装分
    //            Math.max(strengthCoefficientOld, strengthCoefficientNew)
    //            * equipment_quality_coefficients[equipQuality]
    //            * equipment_position_coefficients[equipPosition];
    //
    //        return Math.round(finalStrength);
    //    }
    //    const strengthCoefficient = strengthLevel * (0.7 + 0.3 * strengthLevel) / 200;
    //    return Math.round(base * strengthCoefficient);
    //}
    static func getGsStrengthScore(base: Int, strengthLevel: Int) -> Int {
        let strengthLevel = Float(strengthLevel)
        let strengthCoefficient = strengthLevel * (0.7 + 0.3 * strengthLevel) / 200
        return Int(round(Float(base) * strengthCoefficient))
    }
}

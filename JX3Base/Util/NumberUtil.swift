//
//  NumberUtil.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/4.
//

import Foundation


class NumberUtil {
    
}

extension Int {
    
    private static var chineseMap: [Int: String] {
        return [
            0: "〇",
            1: "一",
            2: "二",
            3: "三",
            4: "四",
            5: "五",
            6: "六",
            7: "七",
            8: "八",
            9: "九",
            10: "十",
            11: "十一",
            12: "十二",
        ]
    }
    
    private static var traditionalChineseMap: [Int: String] {
        return [
            1: "壹",
            2: "贰",
            3: "叁",
            4: "肆",
            5: "伍",
            6: "陆"
        ]
    }
    
    var chinese: String {
        return Int.chineseMap[self, default: "\(self)"]
    }
    
    var traditionalChinese: String {
        return Int.traditionalChineseMap[self, default: "\(self)"]
    }
}

extension Float {
    var tryIntFormat: String {
        let intValue = Int(self)
        if abs(self - Float(intValue)) > 0 {
            return "\(self)"
        }
        
        return "\(intValue)"
    }
}

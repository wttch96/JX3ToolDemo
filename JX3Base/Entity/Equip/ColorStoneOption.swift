//
//  ColorStoneOption.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/27.
//

import Foundation

struct ColorStoneOption: Decodable {
    let value: String
    let label: String
    let remark: String
    let mounts: [Int]
}

struct ColorStoneOptions: Decodable {
    let t1box: [ColorStoneOption]
    let t2box: [ColorStoneOption]
    let t3box: [ColorStoneOption]
}

extension ColorStoneOption: Hashable, Identifiable {
    var id: String {
        return value
    }
    
    var hashValue: Int {
        return value.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

//
//  DutyType.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/15.
//

import Foundation


enum DutyType: String, Decodable {
    case physics = "外功"
    case magic = "内功"
    case tank = "防御"
    case heal = "治疗"
    
    var value: Int {
        switch self {
        case .physics: return 1
        case .magic: return 2
        case .tank: return 3
        case .heal: return 4
        }
    }
}

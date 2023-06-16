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
}

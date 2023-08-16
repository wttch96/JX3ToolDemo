//
//  EquipQuality.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/18.
//

import Foundation
import SwiftUI

enum EquipQuality: String, Codable, CaseIterable {
    case _0 = "0"
    case _1 = "1"
    case _2 = "2"
    case _3 = "3"
    case _4 = "4"
    case _5 = "5"
    
    var color: Color {
        return Color("Quality\(rawValue)")
    }
}

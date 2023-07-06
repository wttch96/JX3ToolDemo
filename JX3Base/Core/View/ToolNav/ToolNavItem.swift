//
//  ToolNavItem.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/7.
//

import Foundation

enum ToolNavItem: Identifiable, Hashable {
    case equipEditor
    case talnetEditor
}


extension ToolNavItem {
    var id: ToolNavItem { return self }
    
    var title: String {
        switch self {
        case .equipEditor: return "配装器"
        case .talnetEditor: return "奇穴模拟"
        }
    }
    
    var iconImage: String {
        switch self {
        case .equipEditor: return "EquipEditor"
        case .talnetEditor: return "TalnetEditor"
        }
    }
}

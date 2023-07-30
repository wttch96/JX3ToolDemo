//
//  PvType.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/20.
//

import Foundation

enum PvType: String, CaseIterable {
    case all = ""
    case pve = "1"
    case pvp = "2"
}

extension PvType: Identifiable {
    var label: String {
        switch self {
        case .all: return "全部"
        case .pve: return "PVE"
        case .pvp: return "PVP"
        }
    }
    
    var id: String {
        return rawValue
    }
}

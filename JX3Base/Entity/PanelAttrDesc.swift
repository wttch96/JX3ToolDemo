//
//  PanelAttrDesc.swift
//  JX3Demo
//
//  Created by Wttch on 2023/8/8.
//

import Foundation

struct PanelAttrDesc: Decodable {
    let name: String
    let popName: String?
    let percentValue: Int
    let defaultValue: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case popName = "popname"
        case percentValue = "isPercent"
        case defaultValue = "default"
    }
    
    var isPercent: Bool {
        return percentValue == 1
    }
    
    var isDefault: Bool {
        return defaultValue == 1
    }
}

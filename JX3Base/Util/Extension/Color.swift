//
//  Color.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import Foundation
import SwiftUI


extension Color {
    static var theme: Theme { get {return Theme() } }
    
    init(serverState: ServerState) {
        switch serverState.heat {
        case "8": self = Color.theme.full
        case "7": self = Color.theme.busy
        case "6": self = Color.theme.open
        default: self = Color.theme.close
        }
    }
}


class Theme {
    let accent = Color("Accent")
    let background = Color("Background")
    let title = Color("Title")
    let secondaryText = Color("SecondaryText")
    
    let open = Color("Open")
    let close = Color("Close")
    let busy = Color("Busy")
    let full = Color("Full")
    
    let gold = Color("Gold")
    let red = Color("Red")
    
    // 心法
    let kungfuIconBackground = Color("KungfuIconBackground")
    
    // 奇穴
    let talentBackground = Color("TalentBackground")
    let talentLabelBackground = Color("TalentLabelBackground")
}


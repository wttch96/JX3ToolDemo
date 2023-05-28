//
//  ColorExtension.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import Foundation
import SwiftUI

extension Color {
    static var theme : DevColorTheme { return DevColorTheme() }
    
    init(serverState: ServerState) {
        switch serverState.heat {
        case "8": self = Color.theme.full
        case "7": self = Color.theme.busy
        case "6": self = Color.theme.open
        default: self = Color.theme.close
        }
    }
}


class DevColorTheme {
    let open = Color("Open")
    let close = Color("Close")
    let busy = Color("Busy")
    let full = Color("Full")
    let accent = Color("AccentColor")
}

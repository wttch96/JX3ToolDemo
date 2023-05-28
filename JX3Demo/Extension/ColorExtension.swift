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
}


class DevColorTheme {
    let open = Color("Open")
    let close = Color("Close")
    let busy = Color("Busy")
    let full = Color("Full")
    let accent = Color("AccentColor")
}

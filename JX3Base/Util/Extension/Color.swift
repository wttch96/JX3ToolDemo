//
//  Color.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import Foundation
import SwiftUI


extension Color {
    static var theme1: Theme { get {return Theme() } }
}

class Theme {
    let accent = Color("Accent")
    let background = Color("Background")
    let title = Color("Title")
    let secondaryText = Color("SecondaryText")
}


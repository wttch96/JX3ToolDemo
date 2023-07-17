//
//  TabBarPreferenceKey.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/7.
//

import Foundation
import SwiftUI

struct TabBarPreferenceKey: PreferenceKey {
    static var defaultValue: [TabBarItem] { return [] }
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}

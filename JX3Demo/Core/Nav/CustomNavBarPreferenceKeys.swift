//
//  CustomNavBarPreferenceKeys.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/7.
//

import Foundation
import SwiftUI

extension View {
    
    func navTitle(_ title: String) -> some View {
        self.preference(key: CustomNavBarTitlePreferenceKey.self, value: title)
    }
    
    func navSubtitle(_ subtitle: String) -> some View {
        self.preference(key: CustomNavBarSubTitlePreferenceKey.self, value: subtitle)
    }
    
    func showBackButton(_ showBackButton: Bool) -> some View {
        self.preference(key: CustomNavBarShowButtonPreferenceKey.self, value: showBackButton)
    }
}

struct CustomNavBarTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct CustomNavBarSubTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct CustomNavBarShowButtonPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = true
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

//
//  TabBarItemViewModifer.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/7.
//

import Foundation
import SwiftUI

struct TabBarItemViewModifer: ViewModifier {
    let tab: TabBarItem
    @Binding var selection: TabBarItem
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TabBarPreferenceKey.self, value: [tab])
    }
}


extension View {
    func tabBarItem(_ tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        self.modifier(TabBarItemViewModifer(tab: tab, selection: selection))
    }
}

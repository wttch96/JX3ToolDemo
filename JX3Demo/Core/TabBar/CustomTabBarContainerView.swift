//
//  CustomTabBarContainerView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/7.
//

import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
    @Binding var selection: TabBarItem
    let content: Content
    
    @State private var tabBars: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                CustomTabBarView(tabs: tabBars, selectedTabBar: $selection)
            }
        }
        .onPreferenceChange(TabBarPreferenceKey.self, perform: { value in
            self.tabBars = value
        })
    }
}

struct CustomTabBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarContainerView(selection: .constant(.home)) {
            Text("XXX")
        }
    }
}

//
//  CustomTabBarView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/7.
//

import SwiftUI


struct CustomTabBarView: View {
    let tabs: [TabBarItem]
    @Binding var selectedTabBar: TabBarItem
    @Namespace private var namespace
    
    var body: some View {
        HStack {
            ForEach(tabs) { tab in
                tabView(tab)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedTabBar = tab
                        }
                    }
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
        .shadow(color: .black.opacity(0.3), radius: 10 , x: 0, y: 5)
        .padding(.horizontal)
    }
}

extension CustomTabBarView {
    private func tabView(_ tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.icon)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundColor(selectedTabBar == tab ? tab.color : .gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                if selectedTabBar == tab {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "tab_bar_item_background", in: namespace)
                }
            }
        )
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBarView(tabs: TabBarItem.allCases, selectedTabBar: .constant(.home))
        }
    }
}

//
//  AppTabBarView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/7.
//

import SwiftUI

struct AppTabBarView: View {
    
    @State private var selectedTabBar: TabBarItem = .home
    
    var body: some View {
        NavigationStack {
            CustomTabBarContainerView(selection: $selectedTabBar, content: {
                HomeView()
                    .ignoresSafeArea()
                    .tabBarItem(.home, selection: $selectedTabBar)
                Color.red.ignoresSafeArea()
                    .tabBarItem(.profile, selection: $selectedTabBar)
                Color.green.ignoresSafeArea()
                    .tabBarItem(.favorites, selection: $selectedTabBar)
            })
        }
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabBarView()
    }
}


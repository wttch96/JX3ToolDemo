//
//  TabBarItem.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/7.
//

import Foundation
import SwiftUI

enum TabBarItem: Hashable, CaseIterable, Identifiable {
    case home, favorites, profile
}

extension TabBarItem {
    var id: String { return title }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .favorites: return "Favorites"
        case .profile: return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .favorites: return "heart"
        case .profile: return "person"
        }
    }
    
    var color: Color {
        switch self {
        case .home: return .red
        case .favorites: return .blue
        case .profile: return .green
        }
    }
}

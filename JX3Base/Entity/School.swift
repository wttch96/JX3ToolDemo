//
//  School.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import Foundation
import SwiftUI


struct School: Identifiable, Hashable, Equatable, Comparable, Decodable {
    let id: Int
    let name: String?
    
    
    var hashValue: Int {
        return id.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
    
    static func ==(lhs: School, rhs: School) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func <(lhs: School, rhs: School) -> Bool {
        return lhs.id < rhs.id
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "school_id"
        case name
    }
}

extension School {
    var color: Color {
        if let name = self.name {
            return AssetJsonDataManager.shared.schoolColorMap[name, default: .accentColor]
        }
        return .accentColor
    }
    
    
    var mounts: [Mount] {
        return AssetJsonDataManager.shared.mounts.filter { $0.school == self.id }
    }
}

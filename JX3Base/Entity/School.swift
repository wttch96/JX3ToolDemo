//
//  School.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import Foundation
import SwiftUI


struct School: Identifiable, Hashable, Equatable, Comparable {
    let id: Int
    let name: String?
    let kungfus: [Kungfu]
    let color: Color
    
    
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
}

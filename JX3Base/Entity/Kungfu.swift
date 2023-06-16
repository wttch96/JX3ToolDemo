//
//  Kungfu.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import Foundation
import SwiftUI

struct Kungfu: Identifiable {
    let id: Int
    let name: String
    let force: Int
    let kungfuId: Int
    let school: Int
    let client: [String]
    
    let attrs: [EquipAttribute]
    let color: Color
    
    let schoolName: String
    let shareSchool: [String]
    let duty: DutyType?
    let primaryAttribute: String
}

extension Kungfu: Comparable, Equatable, Hashable {
    static let common = Kungfu(id: 0, name: "通用", force: 0, kungfuId: 0, school: 0, client: [], attrs: [], color: .accentColor, schoolName: "通用", shareSchool: [], duty: .magic, primaryAttribute: "根骨")
    
    static func <(lhs: Kungfu, rhs: Kungfu) -> Bool {
        if lhs.school == rhs.school {
            return lhs.kungfuId < rhs.kungfuId
        }
        return lhs.school < rhs.school
    }
    
    static func ==(lhs: Kungfu, rhs: Kungfu) -> Bool {
        return lhs.id == rhs.id
    }
}


// MARK: 设置属性


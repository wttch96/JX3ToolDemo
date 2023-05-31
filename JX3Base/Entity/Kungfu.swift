//
//  Kungfu.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import Foundation

struct Kungfu: Identifiable, Decodable {
    let id: Int
    let name: String
    let force: Int
    let kungfuId: Int
    let school: Int
    let client: [String]
}

extension Kungfu: Comparable, Equatable, Hashable {
    static let common = Kungfu(id: 0, name: "通用", force: 0, kungfuId: 0, school: 0, client: [])
    
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

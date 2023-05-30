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

extension Kungfu {
    static let common = Kungfu(id: 0, name: "通用", force: 0, kungfuId: 0, school: 0, client: [])
}

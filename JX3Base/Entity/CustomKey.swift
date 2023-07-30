//
//  CustomKey.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/21.
//

import Foundation

struct CustomKey: CodingKey {
    var key : String
    var stringValue: String { return key }
    init(stringValue: String) { self.key = stringValue }
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
}

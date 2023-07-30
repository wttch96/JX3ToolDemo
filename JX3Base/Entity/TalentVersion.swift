//
//  JX3Version.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import Foundation

/// 奇穴版本
struct TalentVersion : Identifiable, Hashable, Decodable {
    typealias ID = String
    var id: String {
        get { return version}
    }
    
    var version: String
    var name: String
}

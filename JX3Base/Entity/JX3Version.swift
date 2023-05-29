//
//  JX3Version.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import Foundation

struct JX3Version : Identifiable, Decodable {
    typealias ID = String
    var id: String {
        get { return version}
    }
    
    init(dict: [String : String]) {
        self.version = dict["version"]!
        self.name = dict["name"]!
    }
    
    var version: String
    var name: String
}

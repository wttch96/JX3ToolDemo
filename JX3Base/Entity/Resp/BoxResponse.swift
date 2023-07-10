//
//  BoxResponse.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/8.
//

import Foundation



struct BoxResponse<T>: Decodable where T: Decodable {
    let total: Int
    let per: Int
    let pages: Int
    let page: Int
    let list: [T]
}

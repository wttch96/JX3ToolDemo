//
//  BoxWrapperResponse.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/9.
//

import Foundation

struct BoxWrapperResponse<T: Decodable>: Decodable {
    let code: Int
    let message: String?
    let data: BoxResponse<T>
}

//
//  BoxNew.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/9.
//

import Foundation

//"ID": 3870,
//"source_id": "57605",
//"source_type": "bps",
//"type": "slider",
//"subtype": null,
//"client": "std",
//"title": null,
//"desc": null,
//"author": "风雪入我怀",
//"remark": "7.6",
//"link": "https://www.jx3box.com/bps/57605",
//"img": "https://cdn.jx3box.com/upload/post/2023/7/6/6037_2717926.jpg",
//"color": null,
//"bgcolor": null,
//"status": 1,
//"power": 0,
//"created_at": "2023-07-06T11:53:38.000Z",
//"updated_at": "2023-07-08T01:19:37.000Z",
//"deleted_at": null
struct BoxNews: Decodable, Identifiable {
    let id: Int
    let sourceId: String
    let sourceType: String
    let type: String
    let subtype: String?
    let client: String
    let title: String?
    let desc: String?
    let author: String
    let remark: String
    let link: String
    let img: String
    let color: String?
    let bgColor: String?
    let status: Int
    let power: Int
    let createdAt: String
    let updatedAt: String
    let deletedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case sourceId = "source_id"
        case sourceType = "source_type"
        case type
        case subtype
        case client
        case title
        case desc
        case author
        case remark
        case link
        case img
        case color
        case bgColor = "bgcolor"
        case status
        case power
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}


extension BoxNews: Equatable {
    static func ==(lhs: BoxNews, rhs: BoxNews) -> Bool {
        return lhs.id == rhs.id
    }
}

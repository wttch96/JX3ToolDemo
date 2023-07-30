//
//  EquipSetDTO.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/25.
//

import Foundation
import CoreData

//"IdKey": 163529,
//"ItemID": 190663,
//"IconID": 1000000,
//"SoundID": null,
//"Name": "濯心·吟光",
//"Desc": null,
//"Requirement": null
struct EquipSetDTO: Decodable, Equatable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "IdKey"
        case name = "Name"
    }
    
    static func ==(lhs: EquipSetDTO, rhs: EquipSetDTO) -> Bool {
        return lhs.id == rhs.id
    }
}

//"id": 94234,
//"TabType": 7,
//"ID": 94234,
//"Level": 12300,
//"AucGenre": "3",
//"AucSubType": "6",
//"Name": "濯心·吟光护手",
//"BelongSchool": "6",
//"SetID": 5230,
//"MagicKind": "外功",
//"MagicType": "伤害,会心,破招",
//"GetType": "套装兑换,侠行点",
//"PVE_PVP": null,
//"Get_Force": null,
//"Get_Desc": "{兑换牌·藏剑},{侠行·高级套装,侠行·藏剑}",
//"BelongMapID": null,
//"PrestigeRequire": null,
//"_Position": "10"
struct EquipSetListDTO: Decodable, Equatable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "Name"
    }
    
    
    static func ==(lhs: EquipSetListDTO, rhs: EquipSetListDTO) -> Bool {
        return lhs.id == rhs.id
    }
}


struct EquipSetResp: Decodable {
    let info: EquipSetDTO
    let list: [EquipSetListDTO]
}

#if os(OSX)
extension EquipSetResp {
    // 将套装DTO转换为可以存储到 CoreData 中的数据类型
    func set(_ content: NSManagedObjectContext) -> EquipSet {
        let set = EquipSet(context: content)
        set.id = Int64(info.id)
        set.name = info.name
        return set
    }
    
    // 将套装DTO转换为可以存储 CoreData 中的数据类型
    func setList(_ content: NSManagedObjectContext) -> [EquipSetList] {
        var list: [EquipSetList] = []
        for item in self.list {
            let listItem = EquipSetList(context: content)
            listItem.id = Int64(item.id)
            listItem.name = item.name
            list.append(listItem)
        }
        return list
    }
}

#endif

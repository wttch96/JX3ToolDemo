//
//  EquipMagicType.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/23.
//

import Foundation


struct EquipMagicType : Decodable, Identifiable {
    typealias ID = String
    var id : String { return UUID().uuidString }
    var attr : [String?]
    var label: String
    
    var attrDesc : String {
        return AssetJsonDataManager.shared.attrDescMap[attr[0] ?? ""] ?? "nil" + "\(min)"
    }
    
    var briefDesc : String {
        return (AssetJsonDataManager.shared.attrBriefDescMap[attr[0] ?? ""] ?? "nil") + "+\(min)"
    }
    
    var min : Int { return attr[1].flatMap({ Int($0) }) ?? 0 }
    
    init?(decoder : Decoder, index: Int) throws {
        let container = try decoder.container(keyedBy: CustomKey.self)
        if let type = try container.decodeIfPresent(EquipMagicType.self, forKey: CustomKey(stringValue: "_Magic\(index)Type")) {
            self = type
        } else {
            return nil
        }
    }
}

extension EquipMagicType {
    func score(level: Int, maxLevel: Int) -> Int {
        return getStrengthScore(base: min, strengthLevel: maxLevel, equipLevel: level)
    }
}

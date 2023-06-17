//
//  Kungfu.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import Foundation
import SwiftUI


/// 心法
struct Mount: Identifiable {
    let id: Int
    let name: String
    let force: Int
    let kungfuId: Int
    let school: Int
    let client: [String]
}


// MARK: 扩展协议
extension Mount: Comparable, Equatable, Hashable, Decodable {
    static let common = Mount(id: 0)!
    
    static func <(lhs: Mount, rhs: Mount) -> Bool {
        if lhs.school == rhs.school {
            return lhs.kungfuId < rhs.kungfuId
        }
        return lhs.school < rhs.school
    }
    
    static func ==(lhs: Mount, rhs: Mount) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case force
        case kungfuId
        case school
        case client
    }
}


// MARK: 扩展一些 json 中加载的数据
extension Mount {
    
    public init?<T>(by: KeyPath<Mount, T>, value: T) where T: Equatable {
        if let mount = AssetJsonDataManager.shared.mounts.first(where: { $0[keyPath: by] == value }) {
            self =  mount
        } else {
            return nil
        }
    }
    
    init?(_ name: String) {
        self.init(by: \.name, value: name)
    }
    
    init?(id: Int) {
        self.init(by: \.id, value: id)
    }
    
    var idStr: String {
        return "\(id)"
    }
    
    /// 心法检索装备时要用到的附加属性
    var equip: MountEquip? {
        return AssetJsonDataManager.shared.mountId2EquipMap[idStr]
    }

    /// 心法颜色
    var color: Color {
        return AssetJsonDataManager.shared.mountColorMap[name, default: .accentColor]
    }
    
    /// 心法对应的装备检索的属性列表
    var attrs: [EquipAttribute] {
        return AssetJsonDataManager.shared.mountId2AttrsMap[idStr, default: []]
    }
}

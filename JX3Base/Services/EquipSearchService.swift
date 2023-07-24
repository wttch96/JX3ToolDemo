//
//  EquipSearchService.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/8.
//

import Foundation
import Combine


class EquipSearchService {
    
    @Published var equips: BoxResponse<EquipDTO>? = nil
    
    private var anyCancellable: AnyCancellable?

    init() {
        
    }
    
    func serachEquip(
        _ position: EquipPosition,
        name: String?,
        minLevel: Int,
        maxLevel: Int,
        pvType: PvType,
        attrs: [EquipAttribute],
        duty: DutyType?,
        belongSchool: [String],
        magicKind: [String],
        page: Int,
        pageSize: Int,
        client: String
    ) {
        logger("搜索装备:\(position.label) \(name ?? "nil") 品质:\(minLevel)-\(maxLevel) 属性:\(attrs)")
        var type = ""
        switch position.aucGenre {
        case 3: type = "armor"
        case 4: type = "trinket"
        default: type = "weapon"
        }
        let urlString = "https://node.jx3box.com/equip/\(type)"
        var request = URLComponents(string: urlString)
        if let name = name, !name.isEmpty {
            request?.queryItems = [
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "client", value: client),
                URLQueryItem(name: "position", value: "\(position.value)"),
                URLQueryItem(name: "pz", value: "1")
            ]
        } else {
            request?.queryItems = [
                URLQueryItem(name: "min_level", value: "\(minLevel)"),
                URLQueryItem(name: "max_level", value: "\(maxLevel)"),
                URLQueryItem(name: "client", value: client),
                URLQueryItem(name: "position", value: "\(position.value)"),
                URLQueryItem(name: "pz", value: "1"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(pageSize)")
            ]
            if pvType == .pve || pvType == .pvp {
                request?.queryItems?.append(
                    URLQueryItem(name: "pv_type", value: pvType.rawValue)
                )
            }
            if !attrs.isEmpty {
                request?.queryItems?.append(
                    URLQueryItem(name: "attr", value: attrs.map({ $0.rawValue }).joined(separator: ","))
                )
            }
            if position == .meleeWeapon || position == .meleeWeapon2 {
                request?.queryItems?.append(
                    URLQueryItem(name: "DetailType", value: position == .meleeWeapon ? "2" : "9")
                )
            } else {
                if !belongSchool.isEmpty {
                    request?.queryItems?.append(
                        URLQueryItem(name: "BelongSchool", value: belongSchool.joined(separator: ","))
                    )
                }
                if !magicKind.isEmpty {
                    request?.queryItems?.append(
                        URLQueryItem(name: "MagicKind", value: magicKind.joined(separator: ","))
                    )
                }
            }
            if let duty = duty {
                request?.queryItems?.append(
                    URLQueryItem(name: "duty", value: "\(duty.value)")
                )
            }
        }
        if let url = request?.url {
            anyCancellable = NetworkManager.downloadJsonData(url: url, type: BoxResponse<EquipDTO>.self)
                .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] resp in 
                    self?.equips = resp
                })
        }
    }
}

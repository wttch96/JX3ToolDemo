//
//  EquipSearchService.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/8.
//

import Foundation
import Combine


class EquipSearchService {
    
    @Published var equips: [EquipDTO] = []
    
    private var anyCancellable: AnyCancellable?

    init() {
        
    }
    
    func serachEquip(
        _ position: EquipPosition,
        minLevel: Int,
        maxLevel: Int,
        attrs: [EquipAttribute],
        page: Int = 1,
        pageSize: Int = 50,
        client: String = "std"
    ) {
        var type = ""
        switch position.aucGenre {
        case 3: type = "armor"
        case 4: type = "trinket"
        default: type = "weapon"
        }
        let urlString = "https://node.jx3box.com/equip/\(type)"
        
        var request = URLComponents(string: urlString)
        request?.queryItems = [
            URLQueryItem(name: "client", value: client),
            URLQueryItem(name: "position", value: "\(position.value)"),
            URLQueryItem(name: "pv_type", value: ""),
            URLQueryItem(name: "attr", value: attrs.map({ $0.rawValue }).joined(separator: ",")),
            URLQueryItem(name: "duty", value: "1"),
            URLQueryItem(name: "pz", value: "1"),
            URLQueryItem(name: "BelongSchool", value: "精简"),
            URLQueryItem(name: "MagicKind", value: "外功"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "\(pageSize)")
        ]
        if let url = request?.url {
            anyCancellable = NetworkManager.downloadJsonData(url: url, type: BoxResponse<EquipDTO>.self)
                .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] resp in
                    self?.equips = resp.list
                    self?.anyCancellable?.cancel()
                })
        }
    }
}

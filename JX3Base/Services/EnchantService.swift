//
//  EnchantService.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/6.
//

import Foundation
import Combine


//  https://node.jx3box.com/enchant/primary?client=std&position=2&search=&subtype=1&latest_enhance=1
class EnchantService {
    @Published var enchants: [Enchant] = []
    
    private var anyCancellable: AnyCancellable? = nil
    
    // subType = 1 小附魔
    // subType = 2 大附魔
    func loadEnchant(position: EquipPosition, searchText: String, subType: EnchantSubType, equip: Equip? = nil) {
        let urlString = "https://node.jx3box.com/enchant/primary"
        var url = URLComponents(string: urlString)
        
        logger("搜索附魔: position: \(position.label), searchText: \(searchText), subType: \(subType)")
        
        url?.queryItems = [
            URLQueryItem(name: "client", value: "std"),
            URLQueryItem(name: "position", value: "\(position.value)"),
            URLQueryItem(name: "subtype", value: "\(subType.rawValue)")
        ]
        
        if subType == .enchance {
            // 小附魔
            url?.queryItems?.append(URLQueryItem(name: "latest_enhance", value: "1"))
        }
        
        if !searchText.isEmpty {
            url?.queryItems?.append(URLQueryItem(name: "search", value: searchText))
        }
        
        if let url = url?.url {
            anyCancellable = NetworkManager.downloadJsonData(url: url, type: [EnchantDTO].self)
                .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] data in
                    if let self = self {
                        if subType == .enchant, let equip = equip {
                            self.enchants = data.map({ $0.toEntity() }).filter({ enchant in
                                if enchant.name.contains(self.equipDuty(equip)) {
                                    // 装备职责对应
                                    var name: String? = nil
                                    // 等级匹配
                                    for key in AssetJsonDataManager.shared.enchantLevelLimit.keys {
                                        if let value = AssetJsonDataManager.shared.enchantLevelLimit[key] {
                                            if equip.level > value["min"]! && equip.level < value["max"]! {
                                                name = key
                                            }
                                        }
                                    }
                                    if let name = name {
                                        return enchant.name.contains(name)
                                    }
                                }
                                
                                return false
                            })
                            // 大附魔过滤
                        } else {
                            self.enchants = data.map({ $0.toEntity() })
                        }
                        self.anyCancellable?.cancel()
                    }
                })
                    
        }
    }
    
    private func equipDuty(_ equip: Equip) -> String {
        if let equipDuty = equip.duty {
            switch equipDuty {
            case "1": fallthrough
            case "2": return "伤"
            case "3": return "御"
            case "4": return "疗"
            default: return ""
            }
        }
        return ""
    }
}

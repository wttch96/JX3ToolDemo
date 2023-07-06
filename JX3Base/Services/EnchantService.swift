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
    func loadEnchant(position: Int, searchText: String?, subType: Int) {
        let urlString = "https://node.jx3box.com/enchant/primary"
        var url = URLComponents(string: urlString)
        url?.queryItems = [
            URLQueryItem(name: "client", value: "std"),
            URLQueryItem(name: "position", value: "\(position)"),
            URLQueryItem(name: "subtype", value: "\(subType)")
        ]
        
        if subType == 1 {
            // 小附魔
            url?.queryItems?.append(URLQueryItem(name: "latest_enhance", value: "1"))
        }
        
        url?.queryItems?.append(URLQueryItem(name: "search", value: searchText))
        
        if let url = url?.url {
            anyCancellable = NetworkManager.downloadJsonData(url: url, type: [Enchant].self)
                .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] data in
                    self?.anyCancellable?.cancel()
                    self?.enchants = data
                })
        }
    }
}

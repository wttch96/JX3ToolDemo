//
//  ColorStoneService.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/28.
//

import Foundation
import Combine


class ColorStoneService {
    @Published var resp: BoxResponsePgaeStr<ColorStoneDTO>? = nil
    
    var loadSubscriber: AnyCancellable? = nil
    
    func loadColorStone(_ t1: ColorStoneOption?, _ t2: ColorStoneOption?, _ t3: ColorStoneOption?, level: Int) {
        var urlComponent = URLComponents(string: "https://node.jx3box.com/enchant/stone")
        urlComponent?.queryItems = [
            URLQueryItem(name: "t1", value: t1?.value),
            URLQueryItem(name: "t2", value: t2?.value),
            URLQueryItem(name: "t3", value: t3?.value),
            URLQueryItem(name: "search", value: nil),
            URLQueryItem(name: "level", value: "\(level)"),
            URLQueryItem(name: "client", value: "std"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per", value: "20")
        ]
        if let url = urlComponent?.url {
            loadSubscriber = NetworkManager.downloadJsonData(url: url, type: BoxResponsePgaeStr<ColorStoneDTO>?.self)
                .sink(receiveCompletion: NetworkManager.handleCompletion(completion:)) { newValue in
                    self.resp = newValue
                    logger("下载五彩石完成:\(newValue?.list.count ?? 0)")
                }
        }
    }
}

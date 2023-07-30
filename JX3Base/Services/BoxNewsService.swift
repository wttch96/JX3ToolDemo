//
//  BoxNewsService.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/10.
//

import Foundation
import Combine

enum BoxNewsType: String {
    // type: slider
    case slider = "slider"
    // type: common, subType: banner
    case common = "common"
}

class BoxNewsService {
    @Published var news: [BoxNews] = []
    
    private var cancellable: AnyCancellable? = nil
    
    func loadNews(type: BoxNewsType = .slider, per: Int = 8, status: Int = 1, client: String = "std") {
        cancellable?.cancel()
        
        var urlComponent = URLComponents(string: "https://cms.jx3box.com/api/cms/news/v2")
        urlComponent?.queryItems = [
            URLQueryItem(name: "client", value: client),
            URLQueryItem(name: "type", value: type.rawValue),
            URLQueryItem(name: "status", value: "\(status)"),
            URLQueryItem(name: "per", value: "\(per)")
        ]
        
        if type == .common {
            urlComponent?.queryItems?.append(URLQueryItem(name: "subtype", value: "banner"))
        }
        
        if let url = urlComponent?.url {
            cancellable = NetworkManager.downloadJsonData(url: url, type: BoxWrapperResponse<BoxNews>.self)
                .sink(receiveCompletion: NetworkManager.handleCompletion(completion:)) { [weak self] resp in
                    if resp.code == 0 {
                        self?.news = resp.data.list
                    } else {
                        logger("下载news失败, code: \(resp.code), \(resp.message)")
                    }
                }
        }
    }
}

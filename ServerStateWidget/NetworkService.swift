//
//  NetworkService.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import Foundation

class NetworkService {
    
    static func loadServerStates(completion: @escaping ([ServerState]) -> Void ) {
        
        let urlString = "https://spider2.jx3box.com/api/spider/server/server_state"
        let url = URL(string: urlString)
        if let url = url {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "get"
            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
            URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode([ServerState].self, from: data)
                        completion(result)
                        return
                    } catch let error {
                        print("Load server state error:\(error.localizedDescription)")
                    }
                }
                completion([])
            }
            .resume()
        }
    }
}

//
//  NetworkManager.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import Foundation
import Combine

class NetworkManager {
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(let url):
                return "[🔥] Bad response from URL. \(url)"
            case .unknown:
                return "[⚠️] Unknown error occured."
            }
        }
    }
    
    static func loadJson<T>(url: URL, type: T.Type, method: String = "POST") -> AnyPublisher<T, Error> where T: Codable {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap {
                try handleURLResponse(output: $0, url: url)
            }
            .decode(type: type, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        // 检验请求状态
        guard let resp = output.response as? HTTPURLResponse,
              resp.statusCode >= 200 && resp.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print("Download coins error : \(error)")
        }
    }
}

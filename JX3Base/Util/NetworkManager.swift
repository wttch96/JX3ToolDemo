//
//  NetworkManager.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import Foundation
import Combine
import SwiftUI

// 网络数据下来管理类
class NetworkManager {
    
    // 枚举网络请求错误
    enum NetworkingError: LocalizedError {
        // 错误的 url 请求
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
    
    
    /// 生成利用 api 从网络加载 Codable 的实体数据的 Publisher，后序可以使用该 Publisher 更新数据等操作
    /// - Parameters:
    ///   - url: 请求 url
    ///   - type: 请求到的 Json 反序列化的实体类型
    ///   - method: 请求方法
    /// - Returns: api 从网络加载 Codable 的 Json 数据并进行序列化的 Publisher
    static func loadJson<T>(url: URL, type: T.Type, method: String = "POST") -> AnyPublisher<T, Error> where T: Codable {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            // http 请求执行所在的线程
            .subscribe(on: DispatchQueue.global(qos: .default))
            // 默认的 stateCode 错误处理
            .tryMap {
                try handleURLResponse(output: $0, url: url)
            }
            .decode(type: type, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    #if os(iOS)
    /// 生成一个从网络 ur l 下载图片的 Publisher
    /// - Parameter url: 网络 url
    /// - Returns: 可以从 url 下载图片的 Publisher
    static func downloadImage(url: URL, httpMethod: String? = nil) -> AnyPublisher<UIImage?, Error> {
        return downloadData(url: url, httpMethod: httpMethod, transform: { UIImage(data: $0) })
    }
    #endif
    
    #if os(OSX)
    /// 生成一个从网络 ur l 下载图片的 Publisher
    /// - Parameter url: 网络 url
    /// - Returns: 可以从 url 下载图片的 Publisher
    static func downloadImage(url: URL, httpMethod: String? = nil) -> AnyPublisher<NSImage?, Error> {
        return downloadData(url: url, httpMethod: httpMethod, transform: { NSImage(data: $0) })
    }
    #endif
    
    
    /// 生成一个从网络 ur l 下载数据的 Publisher
    /// - Parameter url: 网络 url
    /// - Returns: 可以从 url 下载数据的 Publisher
    static func downloadData<T>(url: URL, httpMethod: String? = nil, transform: @escaping (Data) throws -> T) -> AnyPublisher<T, Error> {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            // 执行线程
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap{
                try handleURLResponse(output: $0, url: url)
            }
            .tryMap(transform)
            // 接收线程
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // 默认的 stateCode 错误处理器
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        // 检验响应状态
        guard let resp = output.response as? HTTPURLResponse,
              resp.statusCode >= 200 && resp.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    // 默认的接受数据完成的处理器
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            // 接收数据完成
            break
        case .failure(let error):
            // 接收数据出现异常，或者响应状态不为成功(状态码为: 200..<300)
            print("Download coins error : \(error)")
        }
    }
}

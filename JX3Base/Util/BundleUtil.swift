//
//  AssetUtil.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import Foundation


class BundleUtil {
    
    /// 从资源文件中读取 json 串， 并转换为给定的类型
    /// - Parameters:
    ///   - name: 文件名字
    ///   - type: 要转换的实体类型
    /// - Returns: json 数据转换成的实体，可能为 nil
    static func loadJson<T>(_ name: String, type: T.Type) -> T? where T: Decodable {
        guard let file = Bundle.main.url(forResource: name, withExtension: nil) else { return nil }
        
        do {
            return try JSONDecoder().decode(type, from: Data(contentsOf: file))
        } catch let error {
            logger("Error load asset, name: \(name); reason: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    /// 从资源文件中读取 json 串， 并转换为给定的类型
    /// - Parameters:
    ///   - name: 文件名字
    ///   - type: 要转换的实体类型
    /// - Returns: json 数据转换成的实体，可能为 nil
    static func loadJson<T>(_ name: String, type: T.Type, defaultValue: T) -> T where T: Decodable {
        guard let file = Bundle.main.url(forResource: name, withExtension: nil)
        else {
            logger("Error load asset, name: \(name); reason: url error!")
            return defaultValue
        }
        
        do {
            return try JSONDecoder().decode(type, from: Data(contentsOf: file))
        } catch let error {
            logger("Error load asset, name: \(name); reason: \(error.localizedDescription)")
        }
        
        return defaultValue
    }
}

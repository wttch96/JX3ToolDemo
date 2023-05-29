//
//  LocalFileManager.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import Foundation
import SwiftUI


/// 本地文件读取和保存的管理类
class LocalFileManager {
    static let shared = LocalFileManager()
    private let fm = FileManager.default
    
    private init() { }
    
    // MARK: UIKit
    #if os(iOS)
    /// 以 PNG 格式保存图片到指定路径
    /// - Parameters:
    ///   - image: 要保存的图片
    ///   - imageName: 保存的文件名称
    ///   - folderName: 保存的文件夹位置
    func savePNGImage(_ image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        
        guard
            let data = image.pngData(),
            let url = getURLForFile(imageName, folderName: folderName)
        else { return }
        
        do {
            try data.write(to: url)
            logger("Save png image ---> \(url.path)")
        } catch let error {
            logger("Error save image, image name : [\(url.path)], \(error.localizedDescription)")
        }
    }
    
    /// 根据文件名和文件夹名称加载png类型的图片
    /// - Parameters:
    ///   - imageName: 文件名
    ///   - folderName: 文件夹名称
    /// - Returns: 指定文件夹下的指定名字的图片
    func loadPNGImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLForFile(imageName, fileNameExtension: "png", folderName: folderName),
            fm.fileExists(atPath: url.path)
        else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    #endif
    
    // MARK: AppKit
    #if os(OSX)
    /// 以 PNG 格式保存图片到指定路径
    /// - Parameters:
    ///   - image: 要保存的图片
    ///   - imageName: 保存的文件名称
    ///   - folderName: 保存的文件夹位置
    func savePNGImage(_ image: NSImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        
        guard
            let imageData = image.tiffRepresentation,
            let imageResp = NSBitmapImageRep(data: imageData),
            let url = getURLForFile(imageName, fileNameExtension: "png", folderName: folderName)
        else { return }
        
        if let imageData = imageResp.representation(using: .png, properties: [:]) {
            do {
                try imageData.write(to: url)
            } catch let error {
                logger("Error save image, image name : [\(url.path)], \(error.localizedDescription)")
            }
        }
        
    }
    
    /// 根据文件名和文件夹名称加载png类型的图片
    /// - Parameters:
    ///   - imageName: 文件名
    ///   - folderName: 文件夹名称
    /// - Returns: 指定文件夹下的指定名字的图片
    func loadPNGImage(imageName: String, folderName: String) -> NSImage? {
        guard
            let url = getURLForFile(imageName, fileNameExtension: "png", folderName: folderName),
            fm.fileExists(atPath: url.path)
        else { return nil }
        return NSImage(contentsOf: url)
    }
    
    #endif
    
    // MARK: 通用
    /// 根据给定文件夹名字获取其在 documentDirectory 下的 url 路径
    /// - Parameter folderName: 文件夹名称
    /// - Returns: 给定文件夹名字其在 downloadsDircetory 下的 url
    func getURLForFolder(folderName: String) -> URL? {
        guard
            let url = fm.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }
        
        return url.appendingPathComponent(folderName)
    }
    
    /// 根据给定的文件名、文件扩展名、文件夹名获取其在 documentDirectory 下的 url 路径
    /// - Parameters:
    ///   - fileName: 文件名
    ///   - fileNameExtension: 文件后缀，可以为空；如果不为空则拼接在文件名后面，⚠️不需要 "."
    ///   - folderName: 文件夹名
    /// - Returns: 给定的文件名、文件扩展名、文件夹名拼接的在 documentDirectory 下的 url 路径
    func getURLForFile(_ fileName: String, fileNameExtension: String? = nil, folderName: String) -> URL? {
        guard
            let folderURL = getURLForFolder(folderName: folderName)
        else { return nil }
        
        var fullFileName = fileName
        
        // 如果存在后缀名则添加在后面
        if let fileNameExtension = fileNameExtension {
            fullFileName = fullFileName + "." + fileNameExtension
        }
        return folderURL.appendingPathComponent(fullFileName)
    }
    
    /// 如果文件夹不存在则创建
    /// - Parameter folderName: 文件夹名字
    func createFolderIfNeeded(folderName: String) {
        guard
            let url = getURLForFolder(folderName: folderName)
        else { return }
        
        if !fm.fileExists(atPath: url.path) {
            do {
                // withIntermediateDirectories 自动创建多级别父文件夹
                try fm.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                logger("Error creating directory. FloderName: \(folderName), \(error.localizedDescription)")
            }
        }
    }
}

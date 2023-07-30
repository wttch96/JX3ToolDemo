//
//  ImageDownloadService.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import Foundation
import SwiftUI
import Combine

/// 图片下载、缓存服务
/// 目前保存在 Documents 文件夹下，保存在 Downloads 文件夹下暂时好像不行（后面再修改）
/// 根据文件名查看是否有缓存图片，如果有则加载，否则从网络下载并保存
class ImageDownloadService {
    #if os(iOS)
    @Published var image: UIImage?
    #endif
    #if os(OSX)
    @Published var image: NSImage?
    #endif
    
    private let fm = LocalFileManager.shared
    
    var imageSubscriber: AnyCancellable?
    
    /// 加载图片
    /// 如果本次存在，则读取，否则则从网上下载
    /// - Parameters:
    ///   - urlString: 下载路径
    ///   - imageName: 保存用的文件名
    ///   - folderName: 保存的路径位置
    ///   - httpMethod: 下载文件的请求方式
    public func loadImage(_ urlString: String, imageName: String, folderName: String, httpMethod: String? = nil) {
        if let savedImage = fm.loadPNGImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            // logger("Retrived image(\(urlString) from FM!")
        } else {
            downloadImage(urlString, imageName: imageName, folderName: folderName, httpMethod: httpMethod)
            logger("Download image \(urlString).")
        }
    }
    
    /// 从网络下载图片并保存
    private func downloadImage(_ urlString: String, imageName: String, folderName: String, httpMethod: String? = nil) {
        guard let url = URL(string: urlString) else { return }
        imageSubscriber = NetworkManager.downloadImage(url: url, httpMethod: httpMethod)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard
                    let self = self,
                    let downloadedImage = returnedImage
                else { return }
                
                image = downloadedImage
                self.imageSubscriber?.cancel()
                self.fm.savePNGImage(downloadedImage, imageName: imageName, folderName: folderName)
            })
            
    }
}

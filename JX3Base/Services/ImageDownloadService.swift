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
/// 根据文件名查看是否有缓存图片，如果有则加载，否则从网络下载并保存
class ImageDownloadService {
    #if os(iOS)
    @Published var image: UIImage?
    #endif
    #if os(OSX)
    @Published var image: NSImage?
    #endif
    
    private let fm = LocalFileManager.shared
    
    private let urlString: String
    private let imageName: String
    private let folderName: String
    
    var imageSubscriber: AnyCancellable?
    
    /// 构造服务
    /// - Parameters:
    ///   - urlString: 网络图片的 url
    ///   - imageName: 保存的文件名
    ///   - folderName: 保存文件名所在的文件夹
    init(_ urlString: String, imageName: String, folderName: String) {
        self.urlString = urlString
        self.imageName = imageName
        self.folderName = folderName
    }
    
    /// 加载图片
    /// 如果本次存在，则读取，否则则从网上下载
    private func loadImage() {
        if let savedImage = fm.loadPNGImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            logger("Retrived image(\(urlString) from FM!")
        } else {
            downloadImage()
            logger("Download image\(urlString).")
        }
    }
    
    /// 从网络下载图片并保存
    private func downloadImage() {
        guard let url = URL(string: urlString) else { return }
        imageSubscriber = NetworkManager.downloadImage(url: url)
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

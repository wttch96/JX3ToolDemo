//
//  JX3BoxIconViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import Foundation
import SwiftUI
import Combine

/// 网络图片（自动Cache）的 ViewModel
class WebCacheableImageViewModel : ObservableObject {
    
    /// 适配 ios 和 osx 的图片
    #if os(iOS)
    @Published var image: UIImage?
    #endif
    #if os(OSX)
    @Published var image: NSImage?
    #endif
    /// 加载ing
    @Published var isLoading: Bool = false
    
    // 图片下载服务
    private let imageService: ImageDownloadService
    // 图标 url
    private let imageUrl: String
    // 图片名称
    private let imageName: String
    // 保存位置
    private let folderName: String
    
    private var cancellables = Set<AnyCancellable>()

    init(url: String, folderName: String, imageName: String) {
        self.folderName =  "images/caches/" + folderName
        self.imageUrl = url
        self.imageName = imageName
        
        imageService = ImageDownloadService(imageUrl, imageName: imageName, folderName: self.folderName)
        isLoading = true
        addSubscriber()
    }
    
    /// 添加订阅，将下载器的 Publisher 和当前 ViewModel Publisher 结合
    private func addSubscriber() {
        imageService.$image
            .sink { [weak self] returnedImage in
                self?.image = returnedImage
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}

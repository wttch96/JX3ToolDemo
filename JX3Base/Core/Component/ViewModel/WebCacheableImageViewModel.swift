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
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        imageService = ImageDownloadService()
        addSubscriber()
    }
    
    
    /// 加载网络图片
    /// - Parameters:
    ///   - urlString: 网络图片的 url
    ///   - imageName: 保存的文件名称
    ///   - folderName: 保存的路径位置
    ///   - httpMethod: 请求方式
    public func loadImage(_ urlString: String, imageName: String, folderName: String, httpMethod: String? = nil) {
        isLoading = true
        
        let folderName = "images/caches/" + folderName
        imageService.loadImage(urlString, imageName: imageName, folderName: folderName, httpMethod: httpMethod)
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

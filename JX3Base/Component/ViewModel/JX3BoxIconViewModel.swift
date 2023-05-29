//
//  JX3BoxIconViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import Foundation
import SwiftUI
import Combine

/// 魔盒图标的 ViewModel
class JX3BoxIconViewModel : ObservableObject, Identifiable {
    
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
    // id
    let id: Int
    // 图标 url
    private let imageUrl: String
    // 图片名称
    private let imageName: String
    // 保存位置
    private let folderName = "images/icons"
    
    private var cancellables = Set<AnyCancellable>()
    
    init(_ id: Int) {
        self.id = id
        self.imageUrl = "https://icon.jx3box.com/icon/\(id).png"
        self.imageName = "\(id)"
        
        imageService = ImageDownloadService(imageUrl, imageName: imageName, folderName: folderName)
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

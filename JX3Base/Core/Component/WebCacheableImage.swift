//
//  WebCacheImage.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import SwiftUI

/// 通用的可以进行缓存的图片视图
struct WebCacheableImage<T>: View where T: Equatable {
    // ⚠️慎用 StateObject(wrappedValue: T) 形式的构造函数。
    // 数值的更新可能并不会为 StateObjcet 创建新的对象导致视图无法刷线。
    // 暂未找到解决方案。
    @StateObject private var vm = WebCacheableImageViewModel()

    private let item: T
    private let folderName: String
    private let urlFormat: (T) -> String
    private let imageNameFormat: (T) -> String
    
    /// 构造视图
    /// - Parameters:
    ///   - item: 要渲染的实体（可范型）
    ///   - folderName: 图片保存的文件夹名称
    ///   - urlFormat: 从 item 获取 url 的函数
    ///   - fileNameFormat: 从 item 获取保存文件名的函数
    init(_ item: T, folderName: String, urlFormat: @escaping (T) -> String, fileNameFormat: @escaping (T) -> String) {
        self.item = item
        self.folderName = folderName
        self.urlFormat = urlFormat
        self.imageNameFormat = fileNameFormat
    }
    
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                // 图片已经下载
                imageView(image)
                    .resizable()
                    .scaledToFit()
            } else {
                if vm.isLoading {
                    // 下载图片中
                    ProgressView()
                } else {
                    // 下载失败
                    Image(systemName: "icloud.and.arrow.down")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .onAppear { startLoadImage(item) }
        .onChange(of: item, perform: self.startLoadImage)
    }
    
    /// 开始加载图片
    /// - Parameter item: 监听 State 的对象，从而使数值改变时可以启动/重新加载图片
    private func startLoadImage(_ item: T) {
        vm.loadImage(urlFormat(item), imageName: imageNameFormat(item), folderName: folderName)
    }
    
    // MARK: 适配图片
    #if os(iOS)
    private func imageView(_ image: UIImage) -> Image {
        Image(uiImage: image)
    }
    #endif
    #if os(OSX)
    private func imageView(_ image: NSImage) -> Image {
        Image(nsImage: image)
    }
    #endif
}
//
//struct WebCacheImage_Previews: PreviewProvider {
//    static var previews: some View {
//        WebCacheableImage()
//    }
//}

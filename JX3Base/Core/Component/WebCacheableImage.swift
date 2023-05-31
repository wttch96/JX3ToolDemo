//
//  WebCacheImage.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import SwiftUI

/// 通用的可以进行缓存的图片视图
struct WebCacheableImage: View {
    @StateObject private var vm: WebCacheableImageViewModel
    
    /// 构造视图
    /// - Parameters:
    ///   - item: 要渲染的实体（可范型）
    ///   - folderName: 图片保存的文件夹名称
    ///   - urlFormat: 从 item 获取 url 的函数
    ///   - fileNameFormat: 从 item 获取保存文件名的函数
    init<T>(_ item: T, folderName: String, urlFormat: @escaping (T) -> String, fileNameFormat: @escaping (T) -> String) {
        self._vm = StateObject(
            wrappedValue: WebCacheableImageViewModel(
                url: urlFormat(item),
                folderName: folderName,
                imageName: fileNameFormat(item)
            )
        )
    }
    
    var body: some View {
        VStack {
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

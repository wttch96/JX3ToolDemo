//
//  WebCacheImage.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import SwiftUI

struct WebCacheableImage: View {
    @StateObject private var vm: WebCacheableImageViewModel
    
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
                imageView(image)
                    .resizable()
                    .scaledToFit()
            } else {
                if vm.isLoading {
                    ProgressView()
                } else {
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

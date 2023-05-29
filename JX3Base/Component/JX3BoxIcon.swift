//
//  JX3BoxIcon.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import SwiftUI

/// 剑三魔盒的图标
struct JX3BoxIcon: View {
    @StateObject var vm : JX3BoxIconViewModel
    // 图标 id
    let id: Int
    
    init(id: Int) {
        self.id = id
        self._vm = StateObject(wrappedValue: JX3BoxIconViewModel(id))
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

struct JX3BoxIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach(0..<10) { id in
                JX3BoxIcon(id: id)
                    .frame(width: 48, height: 48)
            }
        }
    }
}

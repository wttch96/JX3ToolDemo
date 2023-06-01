//
//  KungfuIcon.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/31.
//

import SwiftUI

/// 心法图标
struct KungfuIcon: View {
    let kungfu: Kungfu
    let selected: Bool
    
    var body: some View {
        GeometryReader { proxy in
            WebCacheableImage(
                kungfu,
                folderName: "kungfu",
                urlFormat: { "https://img.jx3box.com/image/xf/\($0.id).png" },
                fileNameFormat: { $0.name }
            )
            .padding(borderWidth(proxy))
            .opacity(selected ? 1 : 0.4)
            .scaleEffect(selected ? 1.0 : 0.8)
            .border(.blue, width: borderWidth(proxy))
            .animation(.spring(), value: selected)
            .background(Color.theme.kungfuIconBackground)
            .cornerRadius(borderWidth(proxy) * 1.5)
        }
    }
    
    private func borderWidth(_ proxy: GeometryProxy) -> CGFloat {
        let width = proxy.size.width / 24
        return selected ? width : 0
    }
}

struct KungfuIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            KungfuIcon(kungfu: .common, selected: true)
            KungfuIcon(kungfu: .common, selected: false)
        }
    }
}

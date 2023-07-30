//
//  KungfuIcon.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/31.
//

import SwiftUI

/// 心法图标
struct KungfuIcon: View {
    let kungfu: Mount
    let selected: Bool
    let borderWidth: CGFloat
    
    
    var body: some View {
        WebCacheableImage(
            kungfu,
            folderName: "kungfu",
            urlFormat: { "https://img.jx3box.com/image/xf/\($0.id).png" },
            fileNameFormat: { $0.name }
        )
        .padding(borderWidth)
        .scaleEffect(selected ? 1.0 : 0.8)
        .opacity(selected ? 1 : 0.4)
        .animation(.spring(), value: selected)
        .background(Color.theme.kungfuIconBackground)
        .cornerRadius(borderWidth)
    }
}

struct KungfuIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            KungfuIcon(kungfu: .common, selected: true, borderWidth: 4)
                .frame(width: 240, height: 240)
            KungfuIcon(kungfu: .common, selected: false, borderWidth: 4)
                .frame(width: 240, height: 240)
        }
    }
}

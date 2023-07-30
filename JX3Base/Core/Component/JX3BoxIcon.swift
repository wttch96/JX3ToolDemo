//
//  JX3BoxIcon.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import SwiftUI

/// 剑三魔盒的图标
struct JX3BoxIcon: View {
    // 图标 id
    let id: Int
    
    var body: some View {
        
        WebCacheableImage(id, folderName: "jx3boxIcon", urlFormat: { "https://icon.jx3box.com/icon/\($0).png" }, fileNameFormat: { "\($0)" })
    }
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

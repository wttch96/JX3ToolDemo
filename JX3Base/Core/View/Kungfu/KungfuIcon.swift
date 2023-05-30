//
//  KungfuIcon.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/31.
//

import SwiftUI

struct KungfuIcon: View {
    let kungfu: Kungfu
    
    init(kungfu: Kungfu) {
        self.kungfu = kungfu
    }
    
    var body: some View {
        WebCacheableImage(
            kungfu,
            folderName: "kungfu",
            urlFormat: { "https://img.jx3box.com/image/xf/\($0.id).png" },
            fileNameFormat: { $0.name }
        )
    }
}

struct KungfuIcon_Previews: PreviewProvider {
    static var previews: some View {
        KungfuIcon(kungfu: Kungfu.common)
    }
}

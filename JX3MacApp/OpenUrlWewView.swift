//
//  OpenUrlWewView.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/15.
//

import SwiftUI

struct OpenUrlWewView: View {
    
    @State private var url: String? = nil
    
    var body: some View {
        VStack {
            if let url = url {
                WebView(url: url)
            } else {
                EmptyView()
            }
        }
        .onOpenURL { url in
            if let component = URLComponents(string: url.absoluteString),
               let realUrl = component.queryItems?.first(where: { $0.name == "realUrl" }) {
                self.url = realUrl.value
            }
        }
    }
}

struct OpenUrlWewView_Previews: PreviewProvider {
    static var previews: some View {
        Button("跳转", action: {
            if let url = URL(string: "JX3MacApp://WebViewGroup?realUrl=http://baidu.com") {
                NSWorkspace.shared.open(url)
            }
        })
    }
}

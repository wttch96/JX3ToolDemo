//
//  WebView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/10.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url =  URL(string: url) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: "https://baidu.com")
    }
}

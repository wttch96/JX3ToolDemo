//
//  WebView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/10.
//

import SwiftUI
import WebKit

struct WebView {
    let url: URL?
    
    init(url: String) {
        self.url = URL(string: url)
    }
    
    init(url: URL) {
        self.url = url
    }
    
    private func loadWebView(_ view: WKWebView) {
        if let url = url {
            let request = URLRequest(url: url)
            view.load(request)
        }
    }
}

#if os(iOS)
extension WebView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        self.loadWebView(uiView)
    }
}
#endif

#if os(OSX)
extension WebView: NSViewRepresentable {
    
    func makeNSView(context: Context) -> WKWebView{
        return WKWebView()
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        self.loadWebView(nsView)
    }
}
#endif

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: "https://baidu.com")
    }
}

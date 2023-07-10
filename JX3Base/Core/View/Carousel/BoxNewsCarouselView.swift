//
//  BoxNewsCarouselView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/10.
//

import SwiftUI

struct BoxNewsCarouselView: View {
    
    @StateObject private var vm = BoxNewsCarouselViewModel()
    
    var body: some View {
        CarouselView(vm.news) { new in
            NavigationLink(destination: {
                WebView(url: new.link)
            }, label: {
                WebCacheableImage(new, folderName: "news", urlFormat: { $0.img }, fileNameFormat: { "\($0.id)" })
            })
        }
        .frame(width: 400, height: 200)
        .cornerRadius(16)
    }
}

struct BoxNewsCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BoxNewsCarouselView()
        }
    }
}

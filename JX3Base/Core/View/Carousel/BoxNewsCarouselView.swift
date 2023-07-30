//
//  BoxNewsCarouselView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/10.
//

import SwiftUI
import WttchUI

struct BoxNewsCarouselView: View {
    let boxNewsType: BoxNewsType
    
    init(type boxNewsType: BoxNewsType = .slider) {
        self.boxNewsType = boxNewsType
    }
    
    @StateObject private var vm = BoxNewsCarouselViewModel()
    
    var body: some View {
        CarouselView(vm.news) { new in
            carouseView(new)
        }
        .onAppear {
            vm.loadNews(boxNewsType)
        }
    }
    
    #if os(OSX)
    private func carouseView(_ new: BoxNews) -> some View {
        
        WebCacheableImage(new, folderName: "news", urlFormat: { "\($0.img)?x-oss-process=style/index_banner" }, fileNameFormat: { "\($0.id)" })
            .onTapGesture {
                if let url = URL(string: "JX3MacApp://WebWindowGroup?realUrl=\(new.link)") {
                    NSWorkspace.shared.open(url)
                }
            }
    }
    #endif
    
    #if os(iOS)
    private func carouseView(_ new: BoxNews) -> some View {
        NavigationLink(destination: {
            WebView(url: new.link)
        }, label: {
            WebCacheableImage(new, folderName: "news", urlFormat: { "\($0.img)?x-oss-process=style/index_banner" }, fileNameFormat: { "\($0.id)" })
        })
    }
    #endif
    
    
}

struct BoxNewsCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VStack {
                BoxNewsCarouselView()
                BoxNewsCarouselView(type: .common)
            }
        }
    }
}

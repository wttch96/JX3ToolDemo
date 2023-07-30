//
//  BoxNewsCarouselViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/10.
//

import Foundation
import Combine

class BoxNewsCarouselViewModel: ObservableObject {
    @Published var news: [BoxNews] = []
    
    private let service = BoxNewsService()
    private var anyCancellables: Set<AnyCancellable> = Set()
    
    init() {
        service.$news.sink { [weak self] data in
            self?.news = data
        }
        .store(in: &anyCancellables)
    }
    
    func loadNews(_ type: BoxNewsType) {
        service.loadNews(type: type)
    }
}

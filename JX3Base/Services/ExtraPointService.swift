//
//  JX3ExtraPointService.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import Foundation
import Combine

/// 奇穴 服务
class ExtraPointService {
    // 版本
    @Published var versions: [TalentVersion] = []
    
    // 所有版本
    private let versionIndexUrl = "https://data.jx3box.com/talent/index.json"
    // 版本详情
    private let versionDetailUrlFormmat = "https://console.cnyixun.com/data/qixue/%@.json"
    
    private var anySubcriber: AnyCancellable?
    
    init() {
        loadVersions()
    }
    
    func loadVersions() {
        if let url = URL(string: versionIndexUrl) {
            anySubcriber = NetworkManager.downloadJsonData(url: url, type: [TalentVersion].self)
                .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] versions in
                    self?.versions = versions
                    self?.anySubcriber?.cancel()
                })
        }
    }
}

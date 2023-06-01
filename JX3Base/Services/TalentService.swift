//
//  JX3ExtraPointService.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import Foundation
import Combine

/// 奇穴 服务
class TalentService {
    // 版本
    @Published var versions: [TalentVersion] = []
    @Published var talents: [String: [TalentLevel]] = [:]
    
    // 所有版本
    private let versionIndexUrl = "https://data.jx3box.com/talent/index.json"
    // 版本详情
    private let versionDetailUrlFormmat = "https://data.jx3box.com/talent/%@.json"
    
    private var talentVersionSubscriber: AnyCancellable?
    private var talentSubscriber: AnyCancellable?
    
    init() {
        loadVersions()
    }
    
    func loadVersions() {
        if let url = URL(string: versionIndexUrl) {
            talentVersionSubscriber = NetworkManager.downloadJsonData(url: url, type: [TalentVersion].self)
                .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] versions in
                    self?.versions = versions
                    self?.talentVersionSubscriber?.cancel()
                })
        }
    }
    
    func loadTalents(_ version: TalentVersion) {
        logger("Loading talents. Version: \(version.name)")
        guard
            let url = URL(string: String(format: versionDetailUrlFormmat, version.version))
        else { return }
        
        talentSubscriber = NetworkManager.downloadJsonData(url: url, type: [String: [String: [String: Talent]]].self)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] talentMap in
                self?.talents = talentMap.compactMapValues({ level in
                    level.compactMap { key, talents in
                        TalentLevel(id: key, talents: talents.compactMap { $1 })
                    }
                    .sorted { $0.id < $1.id }
                })
                self?.talentSubscriber?.cancel()
            })
    }
}

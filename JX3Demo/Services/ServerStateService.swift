//
//  ServerStateService.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import Foundation
import Combine

class ServerStateService {
    @Published var serverStates : [ServerState] = []
    private var anyCancellable: AnyCancellable?
    
    init() {
        getServerStates()
    }
    
    private func getServerStates() {
        let urlString = "https://spider2.jx3box.com/api/spider/server/server_state"
        let url = URL(string: urlString)
        if let url = url {
            anyCancellable = NetworkManager.loadJson(url: url, type: [ServerState].self, method: "get")
                .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] serverStates in
                    self?.serverStates = serverStates
                })
        }
    }
}

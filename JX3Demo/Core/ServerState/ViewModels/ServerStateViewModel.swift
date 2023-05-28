//
//  ServerStateViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import Foundation
import Combine

class ServerStateViewModel : ObservableObject {
    // 按区域划分的大区状态
    @Published var zoneServerStates: [String: [ServerState]] = [:]
    
    private let serverStateService = ServerStateService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
        serverStateService.$serverStates
            .sink { [weak self] serverStates in
                self?.zoneServerStates = Dictionary(grouping: serverStates, by: { $0.zoneName })
            }
            .store(in: &cancellables)
    }
}

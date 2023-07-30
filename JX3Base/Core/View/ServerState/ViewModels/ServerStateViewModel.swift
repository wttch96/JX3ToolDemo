//
//  ServerStateViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import Foundation
import Combine

/// 区服状态的视图实体, 主要是调用 ServerStateService 中的数据和方法
class ServerStateViewModel : ObservableObject {
    /// 按区域划分的大区状态
    @Published var zoneServerStates: [String: [ServerState]] = [:]
    /// 关注的区服状态
    @Published var pinServerStates: [ServerState] = []
    
    @Published var allMainServerState: [ServerState] = []
    // 区服状态服务
    private let serverStateService = ServerStateService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    /// 重新加载区服状态
    func loadServerStates() {
        serverStateService.loadServerStates()
    }
    
    /// 关注区服
    func savePin(_ serverState: ServerState) {
        serverStateService.savePin(serverState.serverName)
    }
    
    /// 取消关注区服
    func removePin(_ serverState: ServerState) {
        serverStateService.removePin(name: serverState.serverName)
    }
    
    /// 联合两个 Published 的属性，从而在两者之一更新的时候通过处理来分组（关注的、大区等）
    private func addSubscriber() {
        serverStateService.$serverStates
            .combineLatest(serverStateService.$pinServerStates)
            .sink { [weak self] (serverStates, pinServerStates) in
                self?.pinServerStates = []
                self?.zoneServerStates = [:]
                self?.allMainServerState = []
                for var serverState in serverStates {
                    // 区服是否是已关注
                    serverState.isPin = pinServerStates.contains(where: { pinServerState in
                        return pinServerState.name == serverState.serverName
                    })
                    if serverState.isPined {
                        // 关注的区服列表
                        self?.pinServerStates.append(serverState)
                    } else {
                        // 未关注的区服列表，同时按大区进行分组
                        var states = self?.zoneServerStates[serverState.zoneName] ?? []
                        states.append(serverState)
                        self?.zoneServerStates[serverState.zoneName] = states
                    }
                    // 主要大区
                    let zoneType = ZoneType.zone(serverState.zoneName)
                    if zoneType == .doule || zoneType == .telecom {
                        self?.allMainServerState.append(serverState)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

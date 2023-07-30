//
//  ServerStateService.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import Foundation
import Combine
import CoreData

/// 区服状态服务
/// 1. 利用 api 加载区服状态
/// 2. 利用 core data 加载关注的区服
/// 3. 联合上述两个过程更新的数据的 Publisher，通过联合的 Publisher 接收数据
class ServerStateService {
    // 所有区服的开服状态，利用 api 获取
    @Published var serverStates : [ServerState] = []
    // 关注的区服的开服状态，从 CoreData 中加载
    @Published var pinServerStates: [PinServerState] = []
    
    private var anyCancellable: AnyCancellable?
    private let coreDataManage = CoreDataManager.instance
    
    init() {
        loadServerStates()
        loadPinServerStates()
    }
    
    /// 利用 core data 获取已经关注的区服
    func loadPinServerStates() {
        do {
            self.pinServerStates = try coreDataManage.context.fetch(NSFetchRequest<PinServerState>(entityName: "PinServerState"))
            print("Load core date successful.")
        } catch let error {
            print("Fetch core data error: \(error.localizedDescription)")
        }
    }
    
    /// 判断给定的区服是否在关注列表
    func pinContains(_ name: String) -> Bool {
        return self.pinServerStates.contains(where: { pinServerState in
            return pinServerState.name == name
        })
    }
    
    /// 保存关注的区服名称, 并刷新关注的区服列表, 从而使联合的 Publisher 可以重新发送数据
    func savePin(_ name: String) {
        if !pinContains(name) {
            let pinServerState = PinServerState(context: coreDataManage.context)
            pinServerState.name = name
            coreDataManage.save()
            loadPinServerStates()
            print("Save pin server state:\(name)")
        }
    }
    
    /// 取消关注给定的区服, 并刷新关注的区服列表, 从而使联合的 Publisher 可以重新发送数据
    func removePin(name: String) {
        // 关注的区服已经被加载了，从中找出第一个符合条件的删除即可
        if let pin = pinServerStates.first(where: { $0.name == name }) {
            coreDataManage.context.delete(pin)
            coreDataManage.save()
            loadPinServerStates()
            print("Remove pin server state: \(pin.name ?? "<none>")")
        }
    }
    
    /// 利用 api 加载区服状态, 更新属性数据, 从而使联合的 Publisher 可以重新发送数据
    func loadServerStates() {
        print("Loading server states...")
        let urlString = "https://spider2.jx3box.com/api/spider/server/server_state"
        let url = URL(string: urlString)
        if let url = url {
            anyCancellable = NetworkManager.loadJson(url: url, type: [ServerState].self, method: "get")
                .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] serverStates in
                    if let self = self {
                        self.serverStates = serverStates
                        print("Loaded server states!")
                    }
                })
        }
    }
}

//
//  EquipSetService.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/25.
//

import Foundation
import Combine
import CoreData

class EquipSetService {
    @Published var set: EquipSet? = nil
    @Published var setList: [EquipSetList] = []
    
    private var downloadSubcriber: AnyCancellable? = nil
    private let coreDataManager = CoreDataManager.instance
    
    func loadEquipSet(_ setId: String) {
        // 判断 CoreData 是否存在
        if let setId = Int(setId) {
            let fetch = NSFetchRequest<EquipSet>(entityName: "EquipSet")
            fetch.predicate = NSPredicate(format: "id == %ld", setId)

            do {
                let equipSet = try coreDataManager.context.fetch(fetch)
                if !equipSet.isEmpty {
                    self.set = equipSet.first
                    self.setList = self.set?.list?.allObjects as? [EquipSetList] ?? []
                    logger("Load core data [EquipSet] successful. \(self.set?.name ?? "nil"):\(self.setList.count)")
                    return
                }
            } catch let error {
                logger("Fetch core data [EquipSet] error: \(error.localizedDescription)")
            }
        } else {
            logger("⚠️: Equip set id is not number!")
        }
        // 下载
        downloadEquipSet(setId)
    }
    
    private func downloadEquipSet(_ setId: String) {
        logger("从网络加载[EquipSet]...")
        var urlComponent = URLComponents(string: "https://node.jx3box.com/equip/set/\(setId)")
        urlComponent?.queryItems?.append(URLQueryItem(name: "client", value: "std"))
        if let url = urlComponent?.url {
            downloadSubcriber = NetworkManager.downloadJsonData(url: url, type: EquipSetResp.self)
                .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] resp in
                    if let setId = Int64(setId),
                        let self = self {
                        let set = resp.set(self.coreDataManager.context)
                        set.id = setId
                        let setList = resp.setList(self.coreDataManager.context)
                        setList.forEach { set.addToList($0) }
                        
                        self.set = set
                        self.setList = setList
                        
                        self.coreDataManager.save()
                        logger("从网络加载[EquipSet]成功!")
                    }
                })
        } else {
            logger("⚠️：从网络加载[EquipSet]失败!")
        }
    }
}


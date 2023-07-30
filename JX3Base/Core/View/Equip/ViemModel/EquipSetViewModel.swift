//
//  EquipSetViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/25.
//

import Foundation
import Combine


class EquipSetViewModel: ObservableObject {
    @Published var set: EquipSet? = nil
    @Published var setList: [EquipSetList] = []
    
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let service: EquipSetService = EquipSetService()
    
    init() {
        service.$set.sink(receiveValue: { set in
            self.set = set
        })
        .store(in: &cancellable)
        
        service.$setList.sink { setList in
            self.setList = setList
        }
        .store(in: &cancellable)
    }
    
    func loadEquipSet(_ setId: String) {
        service.loadEquipSet(setId)
    }
}

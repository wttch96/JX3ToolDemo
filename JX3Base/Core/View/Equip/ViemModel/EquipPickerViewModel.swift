//
//  EquipPickerViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/8.
//

import Foundation
import Combine

class EquipPickerViewModel: ObservableObject {
    @Published var equips: [EquipDTO] = []
    
    private var service = EquipSearchService()
    private var cancellables = Set<AnyCancellable>()
    
    init () {
        service.$equips.sink(receiveValue: { [weak self] equips in
            self?.equips = equips
        })
        .store(in: &cancellables)
    }
    
    func searchEquip(_ position: EquipPosition, minLevel: Int, maxLevel: Int, attrs: [EquipAttribute] = []) {
        service.serachEquip(position, minLevel: minLevel, maxLevel: maxLevel, attrs: attrs)
    }
}

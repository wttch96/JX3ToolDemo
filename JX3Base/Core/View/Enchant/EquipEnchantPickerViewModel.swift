//
//  EquipEnchantPickerViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/6.
//

import Foundation
import Combine

class EquipEnchantPickerViewModel: ObservableObject {
    // 加载结果
    @Published var enchants: [Enchant] = []
    // 搜索
    @Published var searchText: String = ""
    
    private var service = EnchantService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        service.$enchants.sink(receiveValue: { [weak self] data in
            self?.enchants = data
        })
        .store(in: &cancellables)
        
        $searchText.debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] value in
                // self?.loadEnchant(.enchance, position: <#T##EquipPosition#>)
            }
            .store(in: &cancellables)
    }
    
    func loadEnchant(_ subType: EnchantSubType, position: EquipPosition) {
        service.loadEnchant(position: position, searchText: searchText, subType: subType)
    }
    
    func loadEnchant(_ text: String, position: EquipPosition, subType: EnchantSubType, equip: EquipDTO?) {
        service.loadEnchant(position: position, searchText: text, subType: subType, equip: equip)
    }
}

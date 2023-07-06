//
//  EquipEnchantPickerViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/6.
//

import Foundation
import Combine

class EquipEnchantPickerViewModel: ObservableObject {
    let position: EquipPosition
    
    // 加载结果
    @Published var enchants: [Enchant] = []
    // 搜索
    @Published var searchText: String = ""
    
    private var service = EnchantService()
    private var cancellables = Set<AnyCancellable>()
    
    
    init(position: EquipPosition) {
        self.position = position
        
        service.$enchants.sink(receiveValue: { [weak self] data in
            self?.enchants = data
        })
        .store(in: &cancellables)
        
        $searchText.debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] value in
                self?.loadEnchant()
            }
            .store(in: &cancellables)
    }
    
    func loadEnchant(subType: Int = 1) {
        service.loadEnchant(position: position.value, searchText: searchText, subType: subType)
    }
}

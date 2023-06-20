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
    
    func searchEquip(
        _ position: EquipPosition,
        minLevel: Int,
        maxLevel: Int,
        pvType: PvType = .all,
        attrs: [EquipAttribute] = [],
        duty: DutyType?,
        belongSchool: [String] = [],
        magicKind: [String] = []
    ) {
        service.serachEquip(position, minLevel: minLevel, maxLevel: maxLevel, pvType: pvType, attrs: attrs, duty: duty, belongSchool: belongSchool, magicKind: magicKind, page: 1, pageSize: 50, client: "std")
    }
}

//
//  EquipPickerViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/8.
//

import Foundation
import Combine

class EquipPickerViewModel: ObservableObject {
    let mount: Mount
    let position: EquipPosition
    let attrItems: [EquipAttribute]
    let level: ClosedRange<CGFloat>
    let otherFilters: [OtherFilter]
    let pvType: PvType
    
    
    @Published var equips: [Equip] = []
    @Published var searchText: String = ""
    
    private var service = EquipSearchService()
    private var cancellables = Set<AnyCancellable>()
    
    init(mount: Mount, position: EquipPosition, attrItems: [EquipAttribute], level: ClosedRange<CGFloat>, otherFilters: [OtherFilter], pvType: PvType) {
        self.mount = mount
        self.position = position
        self.attrItems = attrItems
        self.level = level
        self.otherFilters = otherFilters
        self.pvType = pvType
        
        service.$equips
            .sink(receiveValue: { [weak self] equips in
                // self?.equips = equips
            })
            .store(in: &cancellables)
        
        $searchText.debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadEquip()
            }
            .store(in: &cancellables)
    }
    
    func searchEquip(
        _ position: EquipPosition,
        name: String?,
        minLevel: Int,
        maxLevel: Int,
        pvType: PvType = .all,
        attrs: [EquipAttribute] = [],
        duty: DutyType?,
        belongSchool: [String] = [],
        magicKind: [String] = []
    ) {
        service.serachEquip(mount, position, name: name, minLevel: minLevel, maxLevel: maxLevel, pvType: pvType, attrs: attrs, duty: duty, belongSchool: belongSchool, magicKind: magicKind, page: 1, pageSize: 50, client: "std")
    }
    
    func loadEquip() {
        var schools: [String] = []
        var kinds: [String] = []
        
        if otherFilters.contains(.spareParts) {
            schools.append("通用")
            if let primaryAttr = mount.equip?.primaryAttribute {
                kinds.append(primaryAttr)
            }
        }
        if otherFilters.contains(.simplify) {
            schools.append("精简")
            if let duty = mount.equip?.duty.rawValue {
                kinds.append(duty)
            }
        }
        if otherFilters.contains(.school),
           let schoolName = mount.equip?.schoolName{
            schools.append(schoolName)
            if let duty = mount.equip?.duty.rawValue,
               !schools.contains(duty){
                schools.append(duty)
            }
        }
        
        searchEquip(
            position,
            name: searchText,
            minLevel: Int(level.lowerBound),
            maxLevel: Int(level.upperBound),
            pvType: pvType,
            attrs: attrItems,
            duty: mount.equip?.duty,
            belongSchool: schools, magicKind: kinds
        )
    }
}

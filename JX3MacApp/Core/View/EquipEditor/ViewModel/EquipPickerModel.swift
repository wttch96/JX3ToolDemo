//
//  EquipPickerModel.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/20.
//

import Foundation
import Combine

class EquipPickerModel: ObservableObject {
    @Published var attrItems: [EquipAttribute] = []
    @Published var level: ClosedRange<CGFloat> = 9000...12000
    @Published var otherFilters: [OtherFilter] = [.spareParts, .simplify, .school]
    @Published var pvType: PvType = .all
    @Published var searchText: String = ""
    
    
    @Published var equips: [EquipDTO] = []
    
    private var service = EquipSearchService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        service.$equips
            .sink(receiveValue: { [weak self] equips in
                self?.equips = equips
            })
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
        service.serachEquip(position, name: name, minLevel: minLevel, maxLevel: maxLevel, pvType: pvType, attrs: attrs, duty: duty, belongSchool: belongSchool, magicKind: magicKind, page: 1, pageSize: 50, client: "std")
    }
    
    func loadEquip(mount: Mount, position: EquipPosition) {
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

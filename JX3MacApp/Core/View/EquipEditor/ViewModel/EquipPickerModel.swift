//
//  EquipPickerModel.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/20.
//

import Foundation
import Combine

class EquipPickerModel: ObservableObject {
    // 检索位置
    @Published var position: EquipPosition = .amulet
    // 属性搜索
    @Published var attrItems: [EquipAttribute] = []
    // 装备品质
    @Published var level: ClosedRange<CGFloat> = 9000...12000
    // 其他过滤
    @Published var otherFilters: [OtherFilter] = [.spareParts, .simplify, .school]
    // pv 类型
    @Published var pvType: PvType = .all
    // 装备名称搜索
    @Published var searchText: String = ""
    // 页
    @Published var page: Int = 1
    // 页大小
    @Published var pageSize: Int = 50
    // loading
    @Published var loading: Bool = false
    
    // 搜索结果
    @Published var equips: [EquipDTO] = []
    // 是否有更多数据
    @Published var haveMoreEquip: Bool = false
    
    private var service = EquipSearchService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        service.$equips
            .sink(receiveValue: { [weak self] ret in
                if let ret = ret {
                    self?.loading = false
                    if self?.haveMoreEquip ?? false {
                        self?.equips.append(contentsOf: ret.list)
                    } else {
                        self?.equips = ret.list
                    }
                    self?.haveMoreEquip = ret.page < ret.pages
                    print("搜索结果:\(self?.equips.count ?? 0)条装备")
                }
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
        service.serachEquip(position, name: name, minLevel: minLevel, maxLevel: maxLevel, pvType: pvType, attrs: attrs, duty: duty, belongSchool: belongSchool, magicKind: magicKind, page: page, pageSize: pageSize, client: "std")
    }
    
    func loadEquip(mount: Mount) {
        loading = true
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
            self.position,
            name: searchText,
            minLevel: Int(level.lowerBound),
            maxLevel: Int(level.upperBound),
            pvType: pvType,
            attrs: attrItems,
            duty: mount.equip?.duty,
            belongSchool: schools,
            magicKind: kinds
        )
    }
    
    func reset() {
        page = 1
        haveMoreEquip = false
    }
}

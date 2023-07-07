//
//  EquipSelectlListView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/7.
//

import SwiftUI

struct EquipSelectlListView: View {
    let kungfu: Mount
    let position: EquipPosition
    let attrItems: [EquipAttribute]
    let level: ClosedRange<CGFloat>
    let otherFilters: [OtherFilter]
    let pvType: PvType
    
    @Binding var selection: EquipDTO?
    
    @State private var searchText: String = ""
    @StateObject private var vm = EquipPickerViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section {
                HStack {
                    TextField("搜索", text: $searchText)
                        .onSubmit {
                            loadEquip()
                        }
                    
                    Button(action: {
                        loadEquip()
                    }, label: {
                        Image(systemName: "magnifyingglass")
                    })
                }
            }
            ForEach(vm.equips) { equip in
                EquipPickerOptionView(equip: equip)
                    .background()
                    .onTapGesture(perform: {
                        selection = equip
                        dismiss.callAsFunction()
                    })
            }
        }
        .navigationTitle("选择装备")
        .onAppear {
            loadEquip()
        }
    }
    
    //
    private func loadEquip() {
        var schools: [String] = []
        var kinds: [String] = []
        
        if otherFilters.contains(.spareParts) {
            schools.append("通用")
            if let primaryAttr = kungfu.equip?.primaryAttribute {
                kinds.append(primaryAttr)
            }
        }
        if otherFilters.contains(.simplify) {
            schools.append("精简")
            if let duty = kungfu.equip?.duty.rawValue {
                kinds.append(duty)
            }
        }
        if otherFilters.contains(.school),
           let schoolName = kungfu.equip?.schoolName{
            schools.append(schoolName)
            if let duty = kungfu.equip?.duty.rawValue,
               !schools.contains(duty){
                schools.append(duty)
            }
        }
        
        vm.searchEquip(
            position,
            name: searchText,
            minLevel: Int(level.lowerBound),
            maxLevel: Int(level.upperBound),
            pvType: pvType,
            attrs: attrItems,
            duty: kungfu.equip?.duty,
            belongSchool: schools, magicKind: kinds
        )
    }
}

struct EquipSelectlListView_Previews: PreviewProvider {
    static var previews: some View {
        EquipSelectlListView(
            kungfu: Mount("问水诀")!,
            position: .amulet,
            attrItems: [],
            level: 10000...12000,
            otherFilters: [],
            pvType: .all,
            selection: .constant(dev.equip1)
        )
    }
}

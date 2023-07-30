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
    @StateObject private var vm: EquipPickerViewModel
    
    @Environment(\.dismiss) var dismiss
    
    init(kungfu: Mount, position: EquipPosition, attrItems: [EquipAttribute], level: ClosedRange<CGFloat>, otherFilters: [OtherFilter], pvType: PvType, selection: Binding<EquipDTO?>) {
        self.kungfu = kungfu
        self.position = position
        self.attrItems = attrItems
        self.level = level
        self.otherFilters = otherFilters
        self.pvType = pvType
        self._selection = selection
        self._vm = StateObject(wrappedValue: EquipPickerViewModel(mount: kungfu, position: position, attrItems: attrItems, level: level, otherFilters: otherFilters, pvType: pvType))
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    TextField("搜索", text: $searchText)
                        .onSubmit {
                            vm.loadEquip()
                        }
                    
                    Button(action: {
                        vm.loadEquip()
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
            vm.loadEquip()
        }
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

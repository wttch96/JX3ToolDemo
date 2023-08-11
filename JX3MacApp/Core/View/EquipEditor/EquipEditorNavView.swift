//
//  EquipEditorNavView.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/18.
//

import SwiftUI

struct EquipEditorNavView: View {
    let mount: Mount
    @Binding var selectedPosition: EquipPosition?
    
    @ObservedObject var equipProgramme: EquipProgramme
    
    @State private var attributes: EquipProgrammeAttributeSet
    
    init(mount: Mount, selectedPosition: Binding<EquipPosition?>, equipProgramme: EquipProgramme) {
        self.mount = mount
        self._selectedPosition = selectedPosition
        self._equipProgramme = ObservedObject(wrappedValue: equipProgramme)
        self._attributes = State(initialValue: EquipProgrammeAttributeSet(equipProgramme: equipProgramme))
    }
    
    private let base = ["Vitality", "Agility", "Spirit", "Spunk", "Strength"]
    private let attack = ["PoisonHitPercent", "Haste"]
    
    @State private var showPanelRows: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                
            }
            .frame(height: 60)
            ZStack {
                VStack{
                    if mount.isWenShui {
                        Toggle(equipProgramme.useHeary ? "重剑" : "轻剑", isOn: $equipProgramme.useHeary)
                            .toggleStyle(.switch)
                    }
                    Text("总装分:\(equipProgramme.totalScore)")
                        .bold()
                    ScrollView {
                        VStack(spacing: 4) {
                            ForEach(AssetJsonDataManager.shared.pannelAttributeGroup) { group in
                                PanelAttributeGroupView(group: group, attributes: attributes)
                            }
                        }
//
//                        ForEach(attributes.panelAttrs.keys.sorted(), id: \.self) { key in
//                            if let value = attributes.panelAttrs[key] {
//                                Text("\(AssetJsonDataManager.shared.panelAttrDescMap[key]?.name ?? key):\(value.tryIntFormat)")
//                            }
//                        }
                    }

                }
                .frame(maxWidth: 160)
                VStack(spacing: 10) {
                    HStack {
                        positionView(.helm)
                        Spacer()
                        positionView(.bangle)
                    }
                    HStack {
                        Spacer()
                        positionView(.pants)
                    }
                    HStack {
                        positionView(.chest)
                        Spacer()
                        positionView(.boots)
                    }
                    HStack {
                        Spacer()
                        positionView(.amulet)
                    }
                    HStack {
                        Spacer()
                        positionView(.pendant)
                    }
                    
                    HStack {
                        positionView(.waist)
                        Spacer()
                        positionView(.ring1)
                    }
                    HStack {
                        Spacer()
                        positionView(.ring2)
                    }
                    HStack() {
                        positionView(.meleeWeapon)
                        if mount.name.contains("问水") {
                            positionView(.meleeWeapon2)
                        }
                        positionView(.rangeWeapon)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationTitle("配装器")
        .onAppear {
            let _ = equipProgramme.publisher
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .sink { attributeSet in
                    self.attributes = attributeSet
                }
        }
    }
    
    private func positionView(_ position: EquipPosition) -> some View {
        EquipEditorPositionView(mount: mount, position: position, selectedEquip: positionBinding(position))
            .onTapGesture {
                selectedPosition = position
            }
    }
    
    private func positionBinding(_ position: EquipPosition) -> StrengthedEquip {
        return equipProgramme.equips[position, default: StrengthedEquip()]
    }
}

struct EquipEditorNavView_Previews: PreviewProvider {
    static var previews: some View {
        EquipEditorNavView(mount: dev.mount1, selectedPosition: .constant(.amulet), equipProgramme: EquipProgramme(mount: dev.mount1))
    }
}

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
    
    var body: some View {
        VStack {
            HStack {
                
            }
            .frame(height: 60)
            ZStack {
                VStack {
                    ForEach(equipProgramme.attributes?.attributes.keys.sorted() ?? [], id: \.self) { key in
                        if let value = equipProgramme.attributes?.attributes[key] {
                            Text("\(AssetJsonDataManager.shared.equipAttrMap[key, default: AssetJsonDataManager.shared.attrBriefDescMap[key, default: key]]):\(value.value.tryIntFormat)")
                        }
                    }
                }
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

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
    
    let selectedEquips: [EquipPosition: StrengthedEquip]
    
    var body: some View {
        VStack {
            HStack {
                
            }
            .frame(height: 60)
            ZStack {
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
        return selectedEquips[position, default: StrengthedEquip()]
    }
}

struct EquipEditorNavView_Previews: PreviewProvider {
    static var previews: some View {
        EquipEditorNavView(mount: dev.mount1, selectedPosition: .constant(.amulet), selectedEquips: [:])
    }
}

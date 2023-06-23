//
//  EquipSelectItemView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import SwiftUI

struct EquipSelectItemView: View {
    let kungfu: Mount
    let position: EquipPosition
    
    @Binding var selectedEquip: EquipDTO?
    
    var body: some View {
        NavigationLink(destination: {
            EquipPickerView(kungfu: kungfu, position: position, selected: $selectedEquip)
        }, label: {
            VStack {
                if let equip = self.selectedEquip,
                   let iconId = Int(equip.iconId ?? "0") {
                    VStack {
                        JX3BoxIcon(id: iconId)
                            .frame(width: 48, height: 48)
                    }
                    Text(equip.name)
                        .foregroundColor(.black)
                        .font(.caption)
                } else{
                    Image(position.label)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                    Text(position.label)
                        .foregroundColor(.black)
                        .font(.caption)
                }
            }
        })
    }
}

struct EquipSelectItemView_Previews: PreviewProvider {
    static var previews: some View {
        EquipSelectItemView(
            kungfu: .common,
            position: .amulet, selectedEquip: .constant(dev.equip1))
    }
}

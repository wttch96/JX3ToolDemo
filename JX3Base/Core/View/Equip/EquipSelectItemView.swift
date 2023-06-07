//
//  EquipSelectItemView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import SwiftUI

struct EquipSelectItemView: View {
    let kungfu: Kungfu
    let position: EquipPosition
    
    @Binding var selectedEquip: Int?
    
    var body: some View {
        NavigationLink(destination: {
            EquipPickerView(kungfu: kungfu, postion: position, selected: $selectedEquip)
        }, label: {
            VStack {
                ZStack {
                    Image(position.label)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                }
                if selectedEquip == nil {
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
            position: .amulet, selectedEquip: .constant(nil))
    }
}

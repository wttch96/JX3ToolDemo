//
//  EquipSelectItemView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import SwiftUI

struct EquipSelectPositionView: View {
    let kungfu: Mount
    let position: EquipPosition
    
    @Binding var selectedEquip: Equip?
    
    private let size: CGFloat = 54
    
    var body: some View {
        NavigationLink(destination: {
            EquipPickerView(kungfu: kungfu, position: position, selected: $selectedEquip)
        }, label: {
            VStack {
                if let equip = self.selectedEquip,
                   let iconId = Int(equip.iconId ?? "0") {
                    ZStack {
                        Color.black
                        JX3BoxIcon(id: iconId)
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(equip.quality.color.opacity(0.8), lineWidth: 3)
                            .padding(3)
                    }
                    .frame(width: size, height: size)
                    Text(equip.name)
                        .frame(maxWidth: 60)
                        .foregroundColor(.gray)
                        .font(.caption)
                } else{
                    Image(position.label)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                    Text(position.label)
                        .foregroundColor(.black)
                        .font(.caption)
                }
                Spacer()
            }
        })
        .buttonStyle(.plain)
    }
}

struct EquipSelectItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EquipSelectPositionView(
                kungfu: .common,
                position: .amulet, selectedEquip: .constant(dev.equip1))
        }
    }
}

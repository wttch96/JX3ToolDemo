//
//  EquipEditorPositionView.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/18.
//

import SwiftUI

struct EquipEditorPositionView: View {
    let mount: Mount
    let position: EquipPosition
    
    let selectedEquip: StrengthEquip?
    
    var equip: EquipDTO? {
        return selectedEquip?.equip
    }
    
    private let size: CGFloat = 54
    
    var body: some View {
        VStack {
            if let equip = self.equip,
               let iconId = Int(equip.iconId ?? "0") {
                ZStack {
                    Color.black
                    JX3BoxIcon(id: iconId)
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(equip.quality.color.opacity(0.8), lineWidth: 3)
                        .padding(3)
                }
                .frame(width: size, height: size)
                Text("\(equip.name) - \(selectedEquip?.strengthLevel ?? -1)")
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
        }
    }
}

struct EquipEditorPositionView_Previews: PreviewProvider {
    static var previews: some View {
        EquipEditorPositionView(
            mount: .common,
            position: .amulet, selectedEquip: StrengthEquip(equip: dev.equip1))
    }
}

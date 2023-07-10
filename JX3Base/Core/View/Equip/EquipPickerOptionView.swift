//
//  EquipPickerOptionView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/19.
//

import SwiftUI

struct EquipPickerOptionView: View {
    let equip: EquipDTO
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(equip.isSimp ? Color(hex: "#6f42c1") : Color.white.opacity(0))
                .frame(width: 4, height: 42)
            if let iconId = Int(equip.iconId ?? "0") {
                JX3BoxIcon(id: iconId)
                    .frame(width: 42, height: 42)
            }
            VStack(alignment: .leading) {
                Text(equip.name)
                    .foregroundColor(equip.quality.color)
                    .font(.headline)
                
                Text("(\(equip.attrs.map({ $0.label }).joined(separator: " ")))")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            Spacer()
            Text("\(equip.level)品")
        }
    }
}

struct EquipPickerOptionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EquipPickerOptionView(equip: dev.equip1)
            EquipPickerOptionView(equip: dev.equip2)
            
            Spacer()
        }
    }
}

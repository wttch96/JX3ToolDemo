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
    // 为了保证外围更新可以更新到改视图
    @ObservedObject var selectedEquip: StrengthedEquipViewModel
    
    var equip: Equip? {
        return selectedEquip.equip
    }
    
    private let size: CGFloat = 54
    
    var body: some View {
        VStack {
            if let equip = self.equip,
               let iconId = Int(equip.iconId ?? "0") {
                ZStack {
                    JX3BoxIcon(id: iconId)
                    Image("equip_border_level_\(selectedEquip.strengthLevel == selectedEquip.equip?.maxStrengthLevel ? "max" : "0")")
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: size, height: size)
                Text("\(equip.name)")
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
    
    static var equip: StrengthedEquipViewModel {
        let ret = StrengthedEquipViewModel()
        ret.equip = dev.equip1
        return ret
    }
    
    static var previews: some View {
        EquipEditorPositionView(
            mount: .common,
            position: .amulet, selectedEquip: equip)
    }
}

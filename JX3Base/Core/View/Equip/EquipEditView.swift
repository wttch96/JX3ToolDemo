//
//  EquipEditView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import SwiftUI
import Combine

struct EquipEditView: View {
    let kungfu: Mount
    @StateObject private var vm = EquipEditViewModel()
    
    var body: some View {
        VStack {
            HStack {
                
            }
            .frame(height: 60)
            ZStack {
                VStack(spacing: 10) {
                    HStack {
                        positionView1(.helm, selected: $vm.selectedEquip)
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
                        positionView(.waist)
                        Spacer()
                        positionView(.pendant)
                    }
                    
                    HStack {
                        Spacer()
                        positionView(.ring1)
                    }
                    HStack(spacing: 20) {
                        Spacer()
                        positionView(.meleeWeapon)
                        if kungfu.name.contains("问水") {
                            positionView(.meleeWeapon2)
                        }
                        positionView(.rangeWeapon)
                        positionView(.ring2)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationTitle("配装器")
    }
    
    private func positionView(_ position: EquipPosition) -> some View {
        EquipSelectItemView(kungfu: kungfu, position: position, selectedEquip: positionBinding(position))
    }
    private func positionView1(_ position: EquipPosition, selected: Binding<EquipDTO?>) -> some View {
        EquipSelectItemView(kungfu: kungfu, position: position, selectedEquip: selected)
    }
    
    private func positionBinding(_ position: EquipPosition) -> Binding<EquipDTO?> {
        return Binding(get: {
            if let value = vm.seletedEquip[position] {
                return value
            } else {
                return nil
            }
        }, set: { value in
            vm.seletedEquip[position] = value
        })
    }
}

struct EquipEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EquipEditView(kungfu: dev.mount1)
        }
    }
}

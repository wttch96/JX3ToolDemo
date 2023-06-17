//
//  EquipEditView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import SwiftUI

struct EquipEditView: View {
    let kungfu: Mount
    @State private var vm = EquipEditViewModel()
    
    var body: some View {
        VStack {
            HStack {
                
            }
            .frame(height: 100)
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
                .padding()
            }
        }
        .navigationTitle("配装器")
    }
    
    private func positionView(_ position: EquipPosition) -> some View {
        EquipSelectItemView(kungfu: kungfu, position: position, selectedEquip: positionBinding(position))
    }
    
    private func positionBinding(_ position: EquipPosition) -> Binding<Int?> {
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
        EquipEditView(kungfu: .common)
    }
}

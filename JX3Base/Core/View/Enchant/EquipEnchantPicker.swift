//
//  EquipEnchantPicker.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/6.
//

import SwiftUI

private struct EquipEnchantSelectList: View {
    let position: EquipPosition
    @Binding var enchant: Enchant?
    @StateObject private var vm: EquipEnchantPickerViewModel
    
    @Environment(\.dismiss) var dismiss
    
    init(position: EquipPosition, enchant: Binding<Enchant?>) {
        self.position = position
        self._enchant = enchant
        self._vm = StateObject(wrappedValue: EquipEnchantPickerViewModel(position: position))
    }
    
    var body: some View {
        List {
            Section("", content: {
                TextField("搜索", text: $vm.searchText)
            })
            ForEach(vm.enchants, content: { enchant in
                EnchantRowView(enchant: enchant)
                .onTapGesture {
                    self.enchant = enchant
                    self.dismiss.callAsFunction()
                }
            })
        }
        .onAppear {
            vm.loadEnchant()
        }
    }
}

struct EquipEnchantPicker: View {
    let position: EquipPosition
    @Binding var enchant: Enchant?
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: {
                EquipEnchantSelectList(position: position, enchant: $enchant)
            }, label: {
                HStack {
                    Text("小附魔")
                    Spacer()
                    if let enchant = enchant {
                        EnchantRowView(enchant: enchant, showAttri: false)
                    } else {
                        Text("选择小附魔")
                    }
                }
            })
        }
    }
}

struct EquipEnchantPicker_Previews: PreviewProvider {
    static var previews: some View {
        List {
            EquipEnchantPicker(position: EquipPosition.boots, enchant: .constant(nil))
        }
    }
}

//
//  EquipEnchantPicker.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/6.
//

import SwiftUI
import Combine

class EquipEnchantPickerViewModel: ObservableObject {
    @Published var enchants: [Enchant] = []
    
    private var service = EnchantService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        service.$enchants.sink(receiveValue: { [weak self] data in
            self?.enchants = data
        })
        .store(in: &cancellables)
    }
    
    func loadEnchant(position: Int, subType: Int = 1) {
        service.loadEnchant(position: position, subType: subType)
    }
}

struct EquipEnchantPicker: View {
    let position: Int
    @Binding var enchant: Enchant?
    @StateObject private var vm = EquipEnchantPickerViewModel()
    
    var body: some View {
        Picker("小附魔", selection: $enchant, content: {
            ForEach(vm.enchants, content: { enchant in
                HStack {
                    Text(enchant.name)
                        .bold()
                        .foregroundColor(enchant.quality?.color ?? .gray)
                    Text("XXX")
                    Text((enchant.quality ?? ._2).rawValue)
                }
                .tag(enchant)
            })
        })
        .pickerStyle(.navigationLink)
        .onAppear {
            vm.loadEnchant(position: 6)
        }
    }
}

struct EquipEnchantPicker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            List {
                EquipEnchantPicker(position: 6, enchant: .constant(nil))
            }
        }
    }
}

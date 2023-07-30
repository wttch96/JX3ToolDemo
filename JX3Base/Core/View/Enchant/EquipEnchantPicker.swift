//
//  EquipEnchantPicker.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/6.
//

import SwiftUI
import WttchUI

struct EquipEnchantPicker: View {
    let position: EquipPosition
    let subType: EnchantSubType
    @Binding var enchant: Enchant?
    let equip: EquipDTO?
    
    @StateObject private var vm = EquipEnchantPickerViewModel()
    @Environment(\.dismiss) private var dismiss
    
    init(position: EquipPosition, subType: EnchantSubType = .enchance, enchant: Binding<Enchant?>, equip: EquipDTO? = nil) {
        self.equip = equip
        self.position = position
        self.subType = subType
        self._enchant = enchant
    }
    
    #if os(iOS)
    var body: some View {
        NavigationLink(destination: {
            enchantListView()
        }, label: {
            HStack {
                Text(title)
                Spacer()
                if let enchant = enchant {
                    enchantView(enchant: enchant, showAttr: false)
                } else {
                    Text("选择\(title)")
                }
            }
        })
    }
    private func onListItemGesture(enchant: Enchant) {
        self.enchant = enchant
        self.dismiss.callAsFunction()
    }
    
    private func enchantListView() -> some View {
        List {
            Section("", content: {
                TextField("搜索", text: $vm.searchText)
            })
            Section {
                ForEach(vm.enchants, content: { enchant in
                    enchantView(enchant: enchant)
                        .onTapGesture {
                            onListItemGesture(enchant: enchant)
                        }
                })
            }
        }
        .onAppear {
            vm.loadEnchant(.enchance, position: position)
        }
    }
    #endif
    
    #if os(OSX)
    @State private var showPopover: Bool = false
    
    var body: some View {
        SearchablePicker(showPopover: $showPopover, content: {
            ScrollView {
                VStack {
                    Text("无")
                        .onTapGesture {
                            enchant = nil
                            showPopover.toggle()
                        }
                    ForEach(vm.enchants) { enchant in
                        enchantView(enchant: enchant)
                            .onTapGesture {
                                self.enchant = enchant
                                showPopover.toggle()
                            }
                    }
                }
            }
            .frame(width: 400)
            .frame( minHeight: 36, maxHeight: 600)
        }, label: Text(title), title: enchant?.name ?? "输入附魔名称可以搜索", searchCallback: { newValue in
            vm.loadEnchant(newValue, position: position, subType: subType, equip: equip)
        })
        .onChange(of: position, perform: { newValue in
            vm.loadEnchant("", position: newValue, subType: subType, equip: equip)
        })
        .onAppear{
            vm.loadEnchant("", position: position, subType: subType, equip: equip)
        }
    }
    
    private func onListItemGesture(enchant: Enchant) {
        self.enchant = enchant
        showPopover.toggle()
    }
    #endif
    
    private func enchantView(enchant: Enchant, showAttr: Bool = true) -> some View {
        HStack {
            Text(enchant.name)
                .bold()
                .foregroundColor(nameColor(enchant))
                .lineLimit(1)
            if showAttr {
                Spacer()
                if let attriName = enchant.attriName {
                    Text(attriName)
                        .font(.caption)
                }
//                if let attriName = enchant.boxAttriName {
//                    JX3GameText(text: attriName)
//                }
            }
        }
    }
    
    private func nameColor(_ enchant: Enchant) -> Color {
        if subType == .enchance {
            return enchant.quality?.color ?? .gray
        } else {
            return EquipQuality._4.color
        }
    }
    
    private var title: String {
        if subType == .enchant {
            return "大附魔"
        } else {
            return "小附魔"
        }
    }
    
}

struct EquipEnchantPicker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            List {
                EquipEnchantPicker(position: EquipPosition.boots, enchant: .constant(nil))
                EquipEnchantPicker(position: EquipPosition.boots, subType: .enchant, enchant: .constant(nil))
            }
        }
    }
}

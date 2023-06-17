//
//  EquipPickerView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import SwiftUI
import RangeSlider
import Combine

struct EquipPickerView: View {
    let kungfu: Mount
    let
position: EquipPosition
    
    @Binding var selected: Int?
    
    @State private var attrItems: [EquipAttribute] = []
    @State private var begin: CGFloat  = 10000
    @State private var end: CGFloat = 11000
    @State private var showEquipListSheet: Bool = false
    
    @StateObject private var vm = EquipPickerViewModel()
    
    
    
    init(kungfu: Mount, position: EquipPosition, selected: Binding<Int?>) {
        self.kungfu = kungfu
        self.position = position
        self._selected = selected
    }
    
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 20) {
                Section(content: {
                    RangeSlider<EmptyView, EmptyView>(
                        beginValue: $begin,
                        endValue: $end,
                        in: 9000...13500
                    )
                }, header: {
                    HStack {
                        Text("品质")
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                })
                Section(content: {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], content: {
                        ForEach(kungfu.attrs, id: \.rawValue) { attr in
                            Toggle(attr.label, isOn: Binding(get: {
                                attrItems.contains(attr)
                            }, set: { value in
                                logger(value)
                                if value {
                                    attrItems.append(attr)
                                } else {
                                    attrItems.removeAll(where: { $0 == attr })
                                }
                            }))
                        }
                    })
                    .toggleStyle(.plain)
                }, header: {
                    HStack {
                        Text("属性筛选")
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                })
                
                Section(content: {
                    HStack {
                        Text("散件")
                            .font(.system(size: 14))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        Text("精简")
                            .font(.system(size: 14))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            
                        Text("牌子")
                            .font(.system(size: 14))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        
                        Toggle("只显示本门派", isOn: .constant(false))
                            .toggleStyle(ButtonToggleStyle())
                    }
                }, header: {
                    HStack {
                        Text("其他筛选")
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                })
            }
            .padding()
            .background(.bar)
            
            VStack {
                Button("下载", action: {
                    vm.searchEquip(position, minLevel: Int(begin), maxLevel: Int(end), attrs: attrItems)
                    showEquipListSheet.toggle()
                })
            }
            .frame(height: 120)
            .background(Color.white)
            Spacer()
        }
        .toolbar(content: {
            Text("卸下")
                .foregroundColor(Color.accentColor)
        })
        .background(Color.gray.opacity(0.2))
        .navigationTitle("\(kungfu.name)-\(position.label)-\(kungfu.equip?.duty.rawValue ?? "<未知>")")
        .sheet(isPresented: $showEquipListSheet, content: {
            ScrollView {
                VStack {
                    ForEach(vm.equips) { equip in
                        Text(equip.name)
                    }
                }
            }
            .presentationDetents([.medium])
        })
    }
}

struct EquipPickerView_Previews: PreviewProvider {
    static var previews: some View {
        EquipPickerView(
            kungfu: Mount(
                id: 10144,
                name: "问水决",
                force: 1,
                kungfuId: 1,
                school: 6,
                client: ["client"]
            ), position: .amulet, selected: .constant(1)
        )
    }
}

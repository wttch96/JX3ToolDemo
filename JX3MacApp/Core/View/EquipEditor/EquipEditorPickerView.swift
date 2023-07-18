//
//  EquipEditorPickerView.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/18.
//

import SwiftUI
import WttchUI

/// 装备选择器
struct EquipEditorPickerView: View {
    // 心法
    let mount: Mount
    // 配装位置
    let position: EquipPosition
    
    @Binding private var selected: StrengthEquip?
    
    @State private var attrItems: [EquipAttribute] = []
    @State private var level: ClosedRange<CGFloat> = 9000...12000
    // sheet 选择
    @State private var showSheet: SheetType? = nil
    
    @State private var otherFilters: [OtherFilter] = [.spareParts, .simplify, .school]
    @State private var pvType: PvType = .all
    
    
    // MARK: 强化
    // ⚠️：暂不整合为 ObservableObject 因为会导致 CPU 100% 卡死
    // 强化等级
    @State private var strengthLevel: Int = 1
    // 五行石镶嵌
    @State private var embeddingStone: [DiamondAttribute: Int]
    // 小附魔
    @State private var enchant: Enchant? = nil
    
    @StateObject private var vm = EquipPickerViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(kungfu: Mount, position: EquipPosition, selected: Binding<StrengthEquip?>) {
        self.mount = kungfu
        self.position = position
        self._selected = selected
        if let equip = selected.wrappedValue?.equip {
            self._embeddingStone = State(initialValue: equip.diamondAttributes.reduce(into: [:] as [DiamondAttribute: Int], { partialResult, attr in
                    partialResult[attr] = 6
                })
            )
        } else {
            self._embeddingStone = State(initialValue: [:])
        }
        self.strengthLevel = selected.wrappedValue?.equip.maxStrengthLevel ?? 1
    }
    
    
    var body: some View {
        HStack {
            if let equip = selected {
                EquipDetailView(strengthEquip: equip)
            }
            List {
                HStack {
                    Text("品质")
                    RangeSlider(
                        value: $level,
                        in: 7000...13500,
                        label: { Text("") },
                        minimumValueLabel: { Text("\(Int(level.lowerBound))") },
                        maximumValueLabel: { Text("\(Int(level.upperBound))") }
                    )
                }
                Picker("类型", selection: $pvType, content: {
                    ForEach(PvType.allCases, content: { pvx in
                        Text(pvx.label)
                            .tag(pvx)
                    })
                })
                .pickerStyle(SegmentedPickerStyle())
                
                if position != .meleeWeapon && position != .meleeWeapon2 {
                    HStack {
                        Text("其他筛选")
                        Spacer()
                        ForEach(OtherFilter.allCases, id: \.rawValue, content: { filter in
                            Toggle(filter.rawValue, isOn: Binding(get: {
                                otherFilters.contains(filter)
                            }, set: { value in
                                if value {
                                    otherFilters.append(filter)
                                } else {
                                    otherFilters.removeAll(where: { $0 == filter })
                                }
                            }))
                        })
                    }
                    //.toggleStyle(.checkBox)
                }
                
                Section("属性筛选", content: {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], content: {
                        ForEach(mount.attrs, id: \.rawValue) { attr in
                            Toggle(attr.label, isOn: Binding(get: {
                                attrItems.contains(attr)
                            }, set: { value in
                                if value {
                                    attrItems.append(attr)
                                } else {
                                    attrItems.removeAll(where: { $0 == attr })
                                }
                            }))
                        }
                    })
                    .toggleStyle(.plain)
                })
                
                Section {
                    NavigationLink(destination: {
                        EquipSelectlListView(
                            kungfu: mount,
                            position: position,
                            attrItems: attrItems,
                            level: level,
                            otherFilters: otherFilters,
                            pvType: pvType,
                            selection: .init(get: {
                                return selected?.equip
                            }, set: { newValue in
                                if let value = newValue {
                                    selected = StrengthEquip(equip: value, strengthLevel: 0, embeddingStone: [:], enchant: nil)
                                    strengthLevel = 0
                                    embeddingStone = [:]
                                    enchant = nil
                                } else {
                                    selected = nil
                                }
                            })
                        )
                    }, label: {
                        HStack {
                            Text("选择装备")
                            Spacer()
                            if let equip = selected {
                                Text("\(equip.equip.name)")
                                    .font(.headline)
                                    .foregroundColor(equip.equip.quality.color)
                            }
                        }
                    })
                    if let equip = self.selected {
                        HStack {
                            Text("精炼等级")
                            Spacer()
                            StarMarkView(maxCount: equip.equip.maxStrengthLevel, selectedCount: $strengthLevel)
                        }
                        HStack {
                            Text("五行石镶嵌")
                            Spacer()
                            ForEach(equip.equip.diamondAttributes) { attr in
                                Text("\(attr.briefLabel)")
                                    .foregroundColor(.gray)
                                Image("Embedding\(embeddingStone[attr, default: 0])")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                            }
                        }
                        .onTapGesture(perform: {
                            showSheet =  .showEmbeddingStoneSheet
                        })
                        
                        EquipEnchantPicker(position: position, enchant: $enchant)
                    }
                }
            }
            //.listStyle(.grouped)
            .toolbar(content: {
                if selected != nil {
                    ToolbarItem {
                        Text("卸下")
                            .foregroundColor(Color.accentColor)
                            .onTapGesture(perform: {
                                selected = nil
                                presentationMode.wrappedValue.dismiss()
                            })
                    }
                }
            })
            .navigationTitle("\(mount.name)-\(position.label)-\(selected?.equip.name ?? "<none>")")
            .sheet(item: $showSheet, onDismiss: { showSheet = nil }, content: { item in
                if item == .showEmbeddingStoneSheet {
                    embeddingStoneSheet
                }
            })
        }
        .onChange(of: strengthLevel, perform: {
            selected = selected?.strengthLevel($0)
        })
        .onChange(of: embeddingStone, perform: {
            selected = selected?.embeddingStone($0)
        })
        .onChange(of: enchant, perform: {
            selected = selected?.enchant($0)
        })
    }
    
    // 带行标题的视图
    private func titleView(title: String, @ViewBuilder viewBuilder: () -> some View) -> some View {
        HStack {
            Text(title)
                .font(.title3)
                .bold()
            Spacer()
            viewBuilder()
        }
    }
    
    // MARK: 子视图
    
    // 五行石镶嵌选择的 sheet
    private var embeddingStoneSheet: some View {
        VStack {
            ZStack {
                Text("选择镶嵌孔")
                    .font(.title)
                    .bold()
                HStack {
                    Spacer()
                    Text("确定")
                        .font(.title3)
                        .bold()
                        .padding(.horizontal, 16)
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            showSheet = nil
                        }
                }
            }
            .padding(.vertical, 16)
            ScrollView {
                if let equip = selected {
                    ForEach(equip.equip.diamondAttributes, content: { attr in
                        VStack {
                            Text("第\(attr.id)孔位: \(attr.label) \(Int(attr.embedValue(level: embeddingStone[attr] ?? 6)))")
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), content: {
                                ForEach(0..<9, id: \.self, content: { stoneLevel in
                                    Image("Embedding\(stoneLevel)")
                                        .opacity(embeddingStone[attr] == stoneLevel ? 1 : 0.2)
                                        .onTapGesture {
                                            embeddingStone[attr] = stoneLevel
                                        }
                                })
                            })
                        }
                    })
                }
                Spacer()
            }
        }
        .presentationDetents([.medium])
    }
}

struct EquipEditorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        EquipEditorPickerView(kungfu: dev.mount1, position: .amulet, selected: .constant(nil))
    }
}

//
//  EquipEditorPickerView.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/18.
//

import SwiftUI
import WttchUI
import Combine

/// 装备选择器
struct EquipEditorSelectView: View {
    // 心法
    let mount: Mount
    // 配装位置
    let position: EquipPosition
    
    @Binding private var selected: StrengthEquip?
    
    @StateObject private var vm = EquipPickerModel()
    // sheet 选择
    @State private var showSheet: SheetType? = nil
    
    // MARK: 强化
    // ⚠️：暂不整合为 ObservableObject 因为会导致 CPU 100% 卡死
    // 强化等级
    @State private var strengthLevel: Int = 1
    // 五行石镶嵌
    @State private var embeddingStone: [DiamondAttribute: Int]
    // 小附魔
    @State private var enchance: Enchant? = nil
    // 大附魔
    @State private var enchant: Enchant? = nil
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState private var textFieldFocus: Bool
    @State private var showPop: Bool = false
    
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
        GeometryReader { geo in
            HStack {
                detailView
                    .frame(maxWidth: geo.size.width * 0.4)
                List {
                    Section("装备(\(position.label))选择", content: {
                        attrPickerView
                        
                        HStack {
                            Text("品质")
                            RangeSlider(
                                value: $vm.level,
                                in: 7000...13500,
                                label: { Text("") },
                                minimumValueLabel: { Text("\(Int(vm.level.lowerBound))") },
                                maximumValueLabel: { Text("\(Int(vm.level.upperBound))") }
                            )
                        }
                        HStack {
                            Picker("类型", selection: $vm.pvType, content: {
                                ForEach(PvType.allCases, content: { pvx in
                                    Text(pvx.label)
                                        .tag(pvx)
                                })
                            })
                            .frame(maxWidth: 120)
                            
                            Spacer()
                            
                            if position != .meleeWeapon && position != .meleeWeapon2 {
                                HStack {
                                    Text("其他筛选")
                                    ForEach(OtherFilter.allCases, id: \.rawValue, content: { filter in
                                        Toggle(filter.rawValue, isOn: Binding(get: {
                                            vm.otherFilters.contains(filter)
                                        }, set: { value in
                                            if value {
                                                vm.otherFilters.append(filter)
                                            } else {
                                                vm.otherFilters.removeAll(where: { $0 == filter })
                                            }
                                        }))
                                    })
                                }
                                //.toggleStyle(.checkBox)
                            }
                            
                        }
                        
                        pickerView
                    })
                    
                    Section("装备强化", content: {
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
                            
                            EquipEnchantPicker(position: position, enchant: $enchance)
                            EquipEnchantPicker(position: position, subType: .enchant ,enchant: $enchant, equip: selected?.equip)
                        }
                    })
                }
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
            .onChange(of: enchance, perform: {
                selected = selected?.enchance($0)
            })
        }
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
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 9), content: {
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
            .padding()
            .frame(minWidth: 540)
        }
        .presentationDetents([.medium])
    }
    
    // 装备详情
    private var detailView: some View {
        VStack {
            if let equip = selected {
                EquipDetailView(strengthEquip: equip)
            } else {
                EmptyView()
            }
            Spacer()
        }
    }
    // 属性选择
    private var attrPickerView: some View {
        HStack {
            Text("属性筛选")
            AutoResizeLazyVGrid(mount.attrs, gridSize: CGSizeMake(64, 32)) { attr in
                Toggle(attr.label, isOn: Binding(get: {
                    vm.attrItems.contains(attr)
                }, set: { value in
                    if value {
                        vm.attrItems.append(attr)
                    } else {
                        vm.attrItems.removeAll(where: { $0 == attr })
                    }
                }))
            }
            .toggleStyle(.plain)
            Spacer()
        }
    }
    
    private var pickerView: some View {
        SearchableCustomPicker({ item in
            if let item = item {
                return item.name
            } else {
                return "需要跨门派类别时可直接输入名称快捷搜索"
            }
        }, data: vm.equips, selection: .init(get: {
            selected?.equip
        }, set: { newValue in
            if let newValue = newValue {
                selected = StrengthEquip(equip: newValue)
            } else {
                selected = nil
            }
            strengthLevel = 0
            embeddingStone = [:]
            enchant = nil
        }), content: { item in
            if let equip = item {
                EquipPickerOptionView(equip: equip)
            } else {
                Text("无")
            }
        }, label: {
            Text("选择\(position.label)")
        }) { [self] searchText in
            self.vm.loadEquip("", mount: mount, position: self.position)
        }
        .onChange(of: position, perform: { newValue in
            self.vm.loadEquip("", mount: mount, position: newValue)
        })
        .onAppear {
            self.vm.loadEquip("", mount: mount, position: self.position)
        }
    }
}

struct EquipEditorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        EquipEditorSelectView(kungfu: dev.mount1, position: .amulet, selected: .constant(nil))
    }
}

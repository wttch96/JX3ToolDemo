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
    
    @Binding private var strengthedEquip: StrengthedEquip
    
    @ObservedObject private var equipProgramme: EquipProgramme
    
    @StateObject private var vm = EquipPickerModel()
    // sheet 选择
    @State private var showSheet: SheetType? = nil
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState private var textFieldFocus: Bool
    @State private var showPop: Bool = false
    
    init(kungfu: Mount, position: EquipPosition, selected: EquipProgramme) {
        self.mount = kungfu
        self.position = position
        self._equipProgramme = ObservedObject(wrappedValue: selected)
        self._strengthedEquip = .init(
            get: {
                return selected.equips[position, default: StrengthedEquip()]
            },
            set: { newValue in
                selected.equips[position] = newValue
            }
        )
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
                        if let equip = self.strengthedEquip.equip {
                            HStack {
                                Text("精炼等级")
                                Spacer()
                                StarMarkView(maxCount: equip.maxStrengthLevel, selectedCount: $strengthedEquip.strengthLevel)
                            }
                            HStack {
                                Text("五行石镶嵌")
                                Spacer()
                                ForEach(equip.diamondAttributes) { attr in
                                    Text("\(attr.briefLabel)")
                                        .foregroundColor(.gray)
                                    Image("Embedding\(strengthedEquip.embeddingStone[attr, default: 0])")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                }
                            }
                            .onTapGesture(perform: {
                                showSheet =  .showEmbeddingStoneSheet
                            })
                            
                            // 小附魔
                            if position.haveEnhance {
                                EquipEnchantPicker(position: position, enchant: $strengthedEquip.enchance)
                            }
                            // 大附魔
                            if position.haveEnchant {
                                EquipEnchantPicker(position: position, subType: .enchant ,enchant: $strengthedEquip.enchant, equip: strengthedEquip.equip)
                            }
                            // 五彩石
                            if position == .meleeWeapon || position == .meleeWeapon2 {
                                colorStonePickerView
                            }
                        }
                    })
                }
                .toolbar(content: {
                    if strengthedEquip.equip != nil {
                        ToolbarItem {
                            Text("卸下")
                                .foregroundColor(Color.accentColor)
                                .onTapGesture(perform: {
                                    strengthedEquip.equip = nil
                                    presentationMode.wrappedValue.dismiss()
                                })
                        }
                    }
                })
                .navigationTitle("\(mount.name)-\(position.label)-\(strengthedEquip.equip?.name ?? "<none>")")
                .sheet(item: $showSheet, onDismiss: { showSheet = nil }, content: { item in
                    if item == .showEmbeddingStoneSheet {
                        embeddingStoneSheet
                    }
                })
            }
        }
    }
    
    @State private var showColorStonePicker: Bool = false
    
    private var colorStonePickerView: some View {
        HStack {
            Text("五彩石镶嵌")
            if let colorStone = strengthedEquip.colorStone {
                JX3BoxIcon(id: Int(colorStone.icon) ?? 0)
                    .frame(width: 36, height: 36)
                Text(colorStone.name)
                    .foregroundColor(colorStone.color)
            }
            Button("选择五彩石") {
                showColorStonePicker.toggle()
            }
        }
        .popover(isPresented: $showColorStonePicker, attachmentAnchor: .point(.bottom), arrowEdge: .bottom) {
            ColorStonePicker(mount: mount, selection: $strengthedEquip.colorStone)
                .frame(minWidth: 800, minHeight: 600)
        }
        .onChange(of: strengthedEquip.colorStone) { newValue in
            showColorStonePicker.toggle()
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
                if let equip = strengthedEquip.equip {
                    ForEach(equip.diamondAttributes, content: { attr in
                        VStack {
                            Text("第\(attr.id)孔位: \(attr.label) \(Int(attr.embedValue(level: strengthedEquip.embeddingStone[attr] ?? 6)))")
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 9), content: {
                                ForEach(0..<9, id: \.self, content: { stoneLevel in
                                    Image("Embedding\(stoneLevel)")
                                        .opacity(strengthedEquip.embeddingStone[attr] == stoneLevel ? 1 : 0.2)
                                        .onTapGesture {
                                            strengthedEquip.embeddingStone[attr] = stoneLevel
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
            if let _ = strengthedEquip.equip {
                EquipDetailView(strengthEquip: strengthedEquip, equipProgramme: equipProgramme)
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
    @State private var showEquipPopover: Bool = false
    private var pickerView: some View {
        SearchablePicker(showPopover: $showEquipPopover, content: {
            ScrollView {
                VStack {
                    Text("无")
                        .onTapGesture {
                            strengthedEquip = StrengthedEquip()
                            strengthedEquip.equip = nil
                            strengthedEquip.strengthLevel = 0
                            strengthedEquip.enchant = nil
                            strengthedEquip.enchance = nil
                            strengthedEquip.colorStone = nil
                            showEquipPopover.toggle()
                        }
                    ForEach(vm.equips) { equip in
                        EquipPickerOptionView(equip: equip)
                            .onTapGesture {
                                strengthedEquip = StrengthedEquip()
                                strengthedEquip.equip = equip
                                strengthedEquip.strengthLevel = 0
                                strengthedEquip.enchant = nil
                                strengthedEquip.enchance = nil
                                strengthedEquip.colorStone = nil
                                showEquipPopover.toggle()
                            }
                    }
                    if vm.haveMoreEquip {
                        Button("加载更多") {
                            vm.page += 1
                            vm.loadEquip(mount: mount)
                        }
                        .buttonStyle(.link)
                    }
                }
            }
            .frame(width: 400, height: 600)
        }, label: Text("选择\(position.label)"), title: strengthedEquip.equip?.name ?? "需要跨门派类别时可直接输入名称快捷搜索", searchCallback: { text in
            vm.searchText = text
            vm.reset()
            vm.loadEquip(mount: mount)
        })
        .onChange(of: position, perform: { newValue in
            vm.reset()
            self.vm.position = newValue
        })
        .onAppear {
            vm.reset()
            self.vm.position = position
        }
    }
}

struct EquipEditorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        EquipEditorSelectView(kungfu: dev.mount1, position: .amulet, selected: EquipProgramme())
    }
}

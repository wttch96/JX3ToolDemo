//
//  EquipPickerView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import SwiftUI
import RangeSlider
import Combine


private enum OtherFilter: String, CaseIterable {
    case spareParts = "散件"
    case simplify = "精简"
    case school = "牌子"
    // 默认只要本门派
    // case onlyMineSchool = "仅显示本门派"
}

private enum SheetType: Int, Identifiable {
    // 选择装备的 sheet
    case showSelectEquipListSheet = 1
    // 选择五行石镶嵌等级的 sheet
    case showEmbeddingStoneSheet = 2
    
    var id: Int {
        return self.rawValue
    }
}

struct EquipPickerView: View {
    let kungfu: Mount
    let position: EquipPosition
    
    @Binding var selected: EquipDTO?
    
    @State private var attrItems: [EquipAttribute] = []
    @State private var level: ClosedRange<CGFloat> = 9000...12000
    // sheet 选择
    @State private var showSheet: SheetType? = nil
    
    @State private var otherFilters: [OtherFilter] = [.spareParts, .simplify, .school]
    @State private var pvType: PvType = .all
    @State private var showSearchTextField: Bool = false
    @FocusState private var textFieldFocused: Bool
    @State private var searchName: String = ""
    // 强化等级
    @State private var strengthLevel: Int = 1
    // 五行石镶嵌
    @State private var embeddingStone: [DiamondAttribute: Int]
    
    @StateObject private var vm = EquipPickerViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(kungfu: Mount, position: EquipPosition, selected: Binding<EquipDTO?>) {
        self.kungfu = kungfu
        self.position = position
        if let equip = selected.wrappedValue {
            self._embeddingStone = State(initialValue: equip.diamondAttributes.reduce(into: [:] as [DiamondAttribute: Int], { partialResult, attr in
                    partialResult[attr] = 6
                })
            )
        } else {
            self._embeddingStone = State(initialValue: [:])
        }
        self._selected = selected
        self.strengthLevel = selected.wrappedValue?.maxStrengthLevel ?? 1
        
    }
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                VStack(spacing: 20) {
                    Section(content: {
                        RangeSlider(
                            value: $level,
                            in: 7000...13500,
                            label: { Text("") },
                            minimumValueLabel: { Text("\(Int(level.lowerBound))") },
                            maximumValueLabel: { Text("\(Int(level.upperBound))") }
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
                        Picker("", selection: $pvType, content: {
                            ForEach(PvType.allCases, content: { pvx in
                                Text(pvx.label)
                                    .tag(pvx)
                            })
                        })
                        .pickerStyle(SegmentedPickerStyle())
                    }, header: {
                        HStack {
                            Text("类型")
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
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], content: {
                            ForEach(kungfu.attrs, id: \.rawValue) { attr in
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
                    }, header: {
                        HStack {
                            Text("属性筛选")
                                .font(.title3)
                                .bold()
                            Spacer()
                        }
                    })
                    
                    if position != .meleeWeapon && position != .meleeWeapon2 {
                        Section(content: {
                            HStack {
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
                                Spacer()
                            }
                            .toggleStyle(.checkBox)
                        }, header: {
                            HStack {
                                Text("其他筛选")
                                    .font(.title3)
                                    .bold()
                                Spacer()
                            }
                        })
                    }
                }
                .padding()
                .background(.bar)
                
                VStack(spacing: 10) {
                    HStack {
                        
                        Text("选择装备")
                            .font(.title3)
                            .bold()
                        
                        Spacer()
                        if showSearchTextField {
                            TextField(selected?.name ?? "输入装备名称可以直接搜索", text: $searchName)
                                .frame(maxWidth: 160)
                                .focused($textFieldFocused)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.accentColor)
                                )
                        } else {
                            Text(selected?.name ?? "请选择")
                                .foregroundColor(Color.accentColor)
                                .onTapGesture(perform: {
                                    showSearchTextField.toggle()
                                    textFieldFocused.toggle()
                                })
                        }
                        Image(systemName: "chevron.down")
                            .onTapGesture(perform: {
                                loadEquip()
                            })
                    }
                    if let equip = self.selected {
                        titleView(title: "精炼等级", viewBuilder: {
                            StarMarkView(maxCount: equip.maxStrengthLevel, selectedCount: $strengthLevel)
                        })

                        
                        titleView(title: "五行石镶嵌") {
                            ForEach(equip.diamondAttributes) { attr in
                                Text("\(attr.briefLabel)")
                                Image("Embedding\(embeddingStone[attr] ?? 6)")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                            }
                        }
                        .onTapGesture(perform: {
                            showSheet =  .showEmbeddingStoneSheet
                        })
                    }
                    if let equip = selected {
                        EquipDetailView(equip: equip, strengthLevel: strengthLevel, diamondAttributeLevels: self.embeddingStone)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.bar)
                Spacer()
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
            .background(Color.gray.opacity(0.2))
            .navigationTitle("\(kungfu.name)-\(position.label)-\(selected?.name ?? "<none>")")
            .sheet(item: $showSheet, onDismiss: { showSheet = nil }, content: { item in
                if item == .showSelectEquipListSheet {
                    selectEquipSheet
                } else if item == .showEmbeddingStoneSheet {
                    embeddingStoneSheet
                }
            })
        }
    }
    
    private func loadEquip() {
        var schools: [String] = []
        var kinds: [String] = []
        
        if otherFilters.contains(.spareParts) {
            schools.append("通用")
            if let primaryAttr = kungfu.equip?.primaryAttribute {
                kinds.append(primaryAttr)
            }
        }
        if otherFilters.contains(.simplify) {
            schools.append("精简")
            if let duty = kungfu.equip?.duty.rawValue {
                kinds.append(duty)
            }
        }
        if otherFilters.contains(.school),
           let schoolName = kungfu.equip?.schoolName{
            schools.append(schoolName)
            if let duty = kungfu.equip?.duty.rawValue,
               !schools.contains(duty){
                schools.append(duty)
            }
        }
        
        vm.searchEquip(
            position,
            minLevel: Int(level.lowerBound),
            maxLevel: Int(level.upperBound),
            pvType: pvType,
            attrs: attrItems,
            duty: kungfu.equip?.duty,
            belongSchool: schools, magicKind: kinds)
        
        showSheet = .showSelectEquipListSheet
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
    
    // 装备选择的 sheet
    private var selectEquipSheet: some View {
        ScrollView {
            VStack {
                Text("选择装备")
                    .font(.title)
                
                Rectangle()
                    .stroke(Color.gray.opacity(0.2))
                    .frame(height: 0.2)
                    .padding(.horizontal)
                
                ForEach(vm.equips) { equip in
                    EquipPickerOptionView(equip: equip)
                        .background()
                        .onTapGesture(perform: {
                            selected = equip
                            showSheet = nil
                        })
                }
            }
            .padding()
        }
        .presentationDetents([.large])
    }
    
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
            .padding(.vertical, 24)
            if let equip = selected {
                ForEach(equip.diamondAttributes, content: { attr in
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
        .presentationDetents([.medium])
    }
}

struct EquipPickerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EquipPickerView(
                kungfu: dev.mount1, position: .helm, selected: .constant(dev.equip1)
            )
        }
    }
}

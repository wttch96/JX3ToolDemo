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

struct EquipPickerView: View {
    let kungfu: Mount
    let position: EquipPosition
    
    @Binding var selected: Int?
    
    @State private var attrItems: [EquipAttribute] = []
    @State private var level: ClosedRange<CGFloat> = 9000...10000
    @State private var showEquipListSheet: Bool = false
    @State private var otherFilters: [OtherFilter] = []
    @State private var pvType: PvType = .all
    
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
                    .toggleStyle(.checkBox)
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
            .padding()
            .background(.bar)
            
            VStack {
                Button("下载", action: {
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
                    showEquipListSheet.toggle()
                })
            }
            .frame(height: 120)
            .background(Color.white)
            Spacer()
        }
        .toolbar(content: {
            ToolbarItem {
                Text("卸下")
                    .foregroundColor(Color.accentColor)
            }
        })
        .background(Color.gray.opacity(0.2))
        .navigationTitle("\(kungfu.name)-\(position.label)")
        .sheet(isPresented: $showEquipListSheet, content: {
            ScrollView {
                VStack {
                    ForEach(vm.equips) { equip in
                        EquipPickerOptionView(equip: equip)
                    }
                }
                .padding(.vertical)
            }
            .presentationDetents([.medium])
        })
    }
}

struct EquipPickerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EquipPickerView(
                kungfu: dev.mount1, position: .helm, selected: .constant(1)
            )
        }
    }
}

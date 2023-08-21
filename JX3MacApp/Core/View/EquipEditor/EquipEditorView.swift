//
//  EquipEditorView.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/17.
//

import SwiftUI

/// 配装器
struct EquipEditorView: View {
    // 心法
    let mount: Mount
    let record: EquipProgrammeRecord?
    
    // 要配装的位置
    @State private var selectedPosition: EquipPosition? = nil
    // 选择的装备
    @StateObject private var equipProgramme: EquipProgramme
    
    private let service = EquipProgrammeRecordService()
    
    init(mount: Mount, record: EquipProgrammeRecord? = nil) {
        self.mount = mount
        self.record = record
        let ep = EquipProgramme(mount: mount)
        
        
        if let jsonData = record?.jsonData, !jsonData.isEmpty,
            let jsonData = jsonData.data(using: .utf8) {
            if let equips = try? JSONDecoder().decode([EquipPosition: StrengthedEquipDAO].self, from: jsonData) {
                
                for (k, v) in equips {
                    let se = ep.equips[k]
                    se?.equip = v.equip
                    se?.strengthLevel = v.strengthLevel
                    se?.embeddingStone = v.embeddingStone
                    se?.enchance = v.enchance
                    se?.enchant = v.enchant
                    se?.colorStone = v.colorStone
                }
            }
        }
        
        self._equipProgramme = StateObject(wrappedValue: ep)
    }
    
   
    var body: some View {
        NavigationSplitView(sidebar: {
            VStack {
                HStack {
                    Image(systemName: "chart.pie")
                    Text("基本信息")
                    Spacer()
                    
                    KungfuIcon(kungfu: mount, selected: true, borderWidth: 2)
                        .padding(2)
                        .frame(width: 24, height: 24)
                    Text(mount.name)
                }
                EquipEditorNavView(mount: mount, selectedPosition: $selectedPosition, equipProgramme: equipProgramme)
                Spacer()
            }
            .padding(.horizontal)
        }, detail: {
            if let selectedPosition = self.selectedPosition {
                EquipEditorSelectView(kungfu: mount, position: selectedPosition, selected: equipProgramme)
            }
        })
        .toolbar {
            ToolbarItem {
                Button("保存") {
                    if let record = record {
                        var equips: [EquipPosition: StrengthedEquipDAO] = [:]
                        for (k, v) in equipProgramme.equips {
                            equips[k] = v.toDAO()
                        }
                        record.jsonData = String(bytes: (try? JSONEncoder().encode(equips)) ?? Data(), encoding: .utf8)
                        service.save(record)
                    }
                }
            }
        }
        
    }
}

struct EquipEditorView_Previews: PreviewProvider {
    static var previews: some View {
        EquipEditorView(mount: dev.mount1)
    }
}

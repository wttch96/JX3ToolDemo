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
    @StateObject private var equipProgramme: EquipProgrammeViewModel
    
    private let service = EquipProgrammeRecordService()
    
    init(mount: Mount, record: EquipProgrammeRecord? = nil) {
        self.mount = mount
        self.record = record
        
        self._equipProgramme = StateObject(wrappedValue: record?.toViewModel(mount: mount) ?? EquipProgrammeViewModel(mount: mount))
    }
    
   
    var body: some View {
        VStack {
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
                            record.score = Int64(equipProgramme.totalScore)
                            record.jsonData = String(bytes: (try? JSONEncoder().encode(equipProgramme.toEntity())) ?? Data(), encoding: .utf8)
                            service.save(record)
                        }
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

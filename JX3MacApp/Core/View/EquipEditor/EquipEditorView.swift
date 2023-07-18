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
    
    // 要配装的位置
    @State private var selectedPosition: EquipPosition? = nil
    
    
    // 选择的装备
    @State private var selectedEquips: [EquipPosition: StrengthEquip] = [:]
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
                EquipEditorNavView(mount: mount, selectedPosition: $selectedPosition, selectedEquips: selectedEquips)
                Spacer()
            }
            .padding(.horizontal)
        }, detail: {
            if let selectedPosition = self.selectedPosition {
                EquipEditorPickerView(kungfu: mount, position: selectedPosition, selected: $selectedEquips[selectedPosition])
            }
        })
        
    }
}

struct EquipEditorView_Previews: PreviewProvider {
    static var previews: some View {
        EquipEditorView(mount: dev.mount1)
    }
}

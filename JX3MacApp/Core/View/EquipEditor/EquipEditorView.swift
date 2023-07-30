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
    @StateObject private var equipProgramme: EquipProgramme
    
    init(mount: Mount) {
        self.mount = mount
        self._equipProgramme = StateObject(wrappedValue: EquipProgramme(mount: mount))
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
        
    }
}

struct EquipEditorView_Previews: PreviewProvider {
    static var previews: some View {
        EquipEditorView(mount: dev.mount1)
    }
}

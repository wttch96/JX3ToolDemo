//
//  EquipEditorView.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/17.
//

import SwiftUI

struct EquipEditorView: View {
    let mount: Mount
    
    @State private var selectedPosition: EquipPosition? = nil
    @State private var selectedEquips: [EquipPosition: EquipDTO?] = [:]
    
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
                EquipEditorNavView(mount: mount, selectedPosition: $selectedPosition)
                Spacer()
            }
            .padding(.horizontal)
        }, detail: {
            HStack {
                if let selectedPosition = self.selectedPosition {
                    EquipEditorPickerView(kungfu: mount, position: selectedPosition, selected: .init(get: {
                        return selectedEquips[selectedPosition, default: nil]
                    }, set: { newValue in
                        selectedEquips[selectedPosition] = newValue
                    }))
                }
            }
        })
        
    }
}

struct EquipEditorView_Previews: PreviewProvider {
    static var previews: some View {
        EquipEditorView(mount: dev.mount1)
    }
}

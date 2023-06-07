//
//  EquipPickerView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import SwiftUI

struct EquipPickerView: View {
    let kungfu: Kungfu
    let postion: EquipPosition
    
    @Binding var selected: Int?
    
    var body: some View {
        VStack {
            
        }
        .navigationTitle("\(kungfu.name)-\(postion.label)")
    }
}

struct EquipPickerView_Previews: PreviewProvider {
    static var previews: some View {
        EquipPickerView(
            kungfu: .common, postion: .amulet, selected: .constant(1)
        )
    }
}

//
//  KungfuPicker.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import SwiftUI

/// 心法选择器
struct KungfuPicker: View {
    @StateObject var vm = KungfuLoaderViewModel()
    @Binding var selectedKungfu: Kungfu
    
    var body: some View {
        AutoResizeLazyVGrid(vm.kungfus, gridSize: CGSize(width: 60, height: 72), content: { item in
            VStack(alignment: .center) {
                KungfuIcon(kungfu: item, selected: selectedKungfu == item)
                    .frame(width: 48, height: 48)
                Text(item.name)
                    .font(.system(size: 11))
                    .foregroundColor(selectedKungfu == item ? Color.theme.accent : Color.theme.secondaryText)
                    .bold()
            }
            .onTapGesture {
                self.selectedKungfu = item
            }
        })
    }
}

struct KungfuPicker_Previews: PreviewProvider {
    static var previews: some View {
        KungfuPicker(selectedKungfu: .constant(.common))
    }
}

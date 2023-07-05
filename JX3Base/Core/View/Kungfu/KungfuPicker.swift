//
//  KungfuPicker.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import SwiftUI

/// 心法选择器
struct KungfuPicker: View {
    @Binding var selectedKungfu: Mount
    
    @Namespace var namespace
    
    private let borderWidth: CGFloat = 4
    
    var body: some View {
        AutoResizeLazyVGrid(AssetJsonDataManager.shared.mounts, gridSize: CGSize(width: 48, height: 60), content: { item in
            VStack(alignment: .center) {
                ZStack {
                    KungfuIcon(kungfu: item, selected: selectedKungfu == item, borderWidth: borderWidth)
                    
                    if selectedKungfu == item {
                        RoundedRectangle(cornerRadius: borderWidth)
                            .stroke(lineWidth: borderWidth)
                            // 【⚠️】不能使用 opacity 必须要让视图存在/消失才能触发 matchedGeometryEffect
                            // .opacity(selectedKungfu == item ? 1 : 0)
                            .foregroundColor(.blue)
                            .matchedGeometryEffect(id: "border", in: self.namespace)
                    }
                }
                .frame(width: 36, height: 36)
                Text(item.name)
                    .font(.system(size: 11))
                    .foregroundColor(selectedKungfu == item ? Color.theme.accent : Color.theme.secondaryText)
                    .bold()
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.selectedKungfu = item
                }
            }
        })
    }
}

struct KungfuPicker_Previews: PreviewProvider {
    static var previews: some View {
        KungfuPicker(selectedKungfu: .constant(.common))
    }
}

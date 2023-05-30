//
//  KungfuPicker.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import SwiftUI

struct KungfuPicker: View {
    
    @StateObject var vm = KungfuLoaderViewModel()
    
    var body: some View {
        AutoResizeLazyVGrid(vm.kungfus, gridSize: CGSize(width: 48, height: 60), content: { kungfu in
            VStack {
                
                Text(kungfu.name)
                    .font(.caption)
                    .frame(width: 60)
            }
        })
    }
}

struct KungfuPicker_Previews: PreviewProvider {
    static var previews: some View {
        KungfuPicker()
    }
}

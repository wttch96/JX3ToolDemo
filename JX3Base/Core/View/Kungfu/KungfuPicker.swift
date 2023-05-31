//
//  KungfuPicker.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import SwiftUI

struct KungfuPicker: View {
    @StateObject var vm = KungfuLoaderViewModel()
    @Binding var selectedKungfu: Kungfu
    
    #if os(iOS)
    @State private var showSheet = false
    var body: some View {
        NavigationStack {
            Picker("选择心法", selection: $selectedKungfu, content: {
                ForEach(vm.kungfus, content: { kungfu in
                    HStack {
                        KungfuIcon(kungfu: kungfu)
                            .frame(width: 36, height: 36)
                        Text(kungfu.name)
                    }
                    .tag(kungfu)
                })
            })
            .pickerStyle(.navigationLink)
        }
    }
    #endif
    #if os(OSX)
    var body: some View {
        picker {
            self.selectedKungfu = $0
        }
    }
    #endif
    
    
    private func picker(_ onTapGesture: @escaping (Kungfu) -> Void) -> some View {
        AutoResizeLazyVGrid(vm.kungfus, gridSize: CGSize(width: 48, height: 72), content: { item in
            VStack {
                KungfuIcon(kungfu: item)
                    .frame(width: 40, height: 40)
                    .opacity(selectedKungfu == item ? 1 : 0.4)
                    .scaleEffect(selectedKungfu == item ? 0.8 : 1.0)
                    .border(.blue, width: selectedKungfu == item ? 2 : 0)
                    .animation(.spring(), value: selectedKungfu == item)
                    .background(Color(red: 36 / 255, green: 41 / 255, blue: 46 / 255))
                    .cornerRadius(4)
                Text(item.name)
                    .font(.system(size: 11))
                Spacer()
            }
            .onTapGesture {
                onTapGesture(item)
            }
        })
    }
}

struct KungfuPicker_Previews: PreviewProvider {
    static var previews: some View {
        KungfuPicker(selectedKungfu: .constant(.common))
    }
}

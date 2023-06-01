//
//  ExtraPointVersionPicker.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import SwiftUI

/// 奇穴版本选择
struct TalentVersionPicker: View {
    
    @StateObject var vm = TalentVersionViewModel()
    
    @Binding var selectedVersion: TalentVersion?
    
    var body: some View {
        ZStack {
            if vm.versions.isEmpty {
                if vm.isLoadidng {
                    ProgressView()
                } else {
                    HStack {
                        Text("加载失败!")
                        CircleButton(iconName: "arrow.clockwise")
                            .onTapGesture {
                                vm.loadVersion()
                            }
                    }
                }
            } else {
                Picker("选择心法", selection: $selectedVersion, content: {
                    ForEach(vm.versions) { version in
                        Text(version.name)
                            .tag(version as TalentVersion?)
                    }
                })
            }
        }
        .padding(.horizontal)
        .onChange(of: vm.versions, perform: { newValue in
            selectedVersion = newValue.first
        })
    }
}

struct ExtraPointVersionPicker_Previews: PreviewProvider {
    static var previews: some View {
        TalentVersionPicker(selectedVersion: .constant(nil))
    }
}

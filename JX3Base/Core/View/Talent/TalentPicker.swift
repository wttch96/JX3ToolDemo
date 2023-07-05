//
//  TalentPicker.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import SwiftUI

struct TalentPicker: View {
    @StateObject var vm: TalentPickerViewModel = TalentPickerViewModel()
    
    @State var seletedTalents: [String: Talent] = [:]
    
    var body: some View {
        List {
            TalentVersionPicker(selectedVersion: $vm.version)
            
            
            KungfuPicker(selectedKungfu: $vm.kungfu)
            
            Section {
                if !vm.talents.isEmpty {
                    AutoResizeLazyVGrid(vm.talents, gridSize: CGSize(width: 60, height: 80)) { level in
                        TalentLevelView(talentLeve: level, seletedTalent: bindingTalent(for: level))
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color.theme.panel)
                    )
                }
            }
        }
        .navigationTitle("\(vm.version?.name ?? "") - \(vm.kungfu.name)")
        .onChange(of: vm.kungfu, perform: { _ in
            seletedTalents = [:]
        })
    }
    
    private func bindingTalent(for level: TalentLevel) -> Binding<Talent> {
        return .init(
            get: { self.seletedTalents[level.id, default: level.talents.first!] },
            set: { self.seletedTalents[level.id] = $0 }
        )
    }
}

struct TalentPicker_Previews: PreviewProvider {
    static var previews: some View {
        TalentPicker()
    }
}

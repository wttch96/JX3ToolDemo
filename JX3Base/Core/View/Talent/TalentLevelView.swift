//
//  TalentLevelView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/1.
//

import SwiftUI

struct TalentLevelView: View {
    let talentLeve: TalentLevel
    @Binding var seletedTalent: Talent
    
    @State private var showTalents = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 2) {
            TalentView(talent: seletedTalent)
                .popover(isPresented: $showTalents) {
                    VStack {
                        ForEach(talentLeve.talents) { item in
                            HStack {
                                TalentView(talent: item)
                                Text(item.desc ?? "<none>")
                                Spacer()
                            }
                            .onTapGesture {
                                seletedTalent = item
                                showTalents.toggle()
                            }
                        }
                    }
                    .padding()
                    .presentationDetents([.medium])
                }
        }
        .onTapGesture {
            showTalents.toggle()
        }
    }
}

struct TalentLevelView_Previews: PreviewProvider {
    static var previews: some View {
        TalentLevelView(talentLeve: TalentLevel(id: "1", talents: dev.talnets), seletedTalent: .constant(dev.talnet))
    }
}

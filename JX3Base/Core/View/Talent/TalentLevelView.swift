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
    
    @Environment(\.debug) var debug
    
    var body: some View {
        HStack(alignment: .top, spacing: 2) {
            TalentView(talent: seletedTalent)
                .popover(isPresented: $showTalents) {
                    VStack {
                        Text("第一重:\(seletedTalent.name)")
                            .padding()
                            .font(.title)
                        ScrollView {
                            VStack {
                                ForEach(talentLeve.talents) { item in
                                    HStack(alignment: .top) {
                                        VStack {
                                            TalentView(talent: item)
//                                            Text(item.isSkill ? "主动招式" : "被动招式")
//                                                .font(.caption)
//                                                .foregroundColor(Color.white)
                                            Spacer()
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            if let meta = item.meta {
                                                Text(meta)
                                            }
                                            Text((item.desc ?? "<none>").replacing("<br/>", with: "\n"))
                                            if let extend = item.extend {
                                                Text(extend)
                                            }
                                            if debug {
                                                Text("ID: \(item.id ?? "<none>")")
                                                    .foregroundColor(.theme.red)
                                            }
                                        }
                                        .font(.system(size: 12))
                                        .foregroundColor(.yellow)
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .onTapGesture {
                                        seletedTalent = item
                                        showTalents.toggle()
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal)
                    .background(Color.theme.panel)
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
            .environment(\.debug, true)
    }
}

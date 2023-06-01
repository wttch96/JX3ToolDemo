//
//  TalentView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/1.
//

import SwiftUI

struct TalentView: View {
    let talent: Talent?
    
    var body: some View {
        VStack {
            ZStack {
                JX3BoxIcon(id: talent?.icon ?? 13)
                    .padding(2)
                if !(talent?.isSkill ?? false) {
                    Image("TalentCoverImage")
                        .resizable()
                        .scaledToFit()
                }
            }
            Text(talent?.name ?? "<none>")
                .font(.caption)
        }
        .frame(width: 60, height: 72)
    }
}

struct TalentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TalentView(talent: dev.talnet)
            TalentView(talent: dev.talnet2)
        }
    }
}

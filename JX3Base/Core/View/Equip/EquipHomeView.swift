//
//  EquipView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/5.
//

import SwiftUI
import WttchUI

struct EquipHomeView: View {
    @State var selectedKungfu: Mount = .common
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack {
                    ForEach(AssetJsonDataManager.shared.schools) { school in
                        ZStack {
                            CornersRectangle(topLeftBottomRight: 36, topRightBottomLeft: 12)
                                .foregroundColor(school.color)
                                .frame(height: 80)
                                .overlay {
                                    HStack {
                                        RadialGradient(colors: [
                                            Color.white.opacity(0.3),
                                            Color.white.opacity(0.1)
                                        ], center: .center, startRadius: 0, endRadius: 100)
                                        .mask{
                                            Image("School\(school.id)")
                                        }
                                        .frame(width: 300)
                                        Spacer()
                                    }
                                }
                            HStack {
                                Spacer()
                                
                                if !school.mounts.isEmpty {
                                    ForEach(school.mounts) { kungfu in
                                        NavigationLink(destination: {
                                            EquipEditView(kungfu: kungfu)
                                        }, label: {
                                            Text("\(kungfu.name)")
                                                .foregroundColor(kungfu.color)
                                                .font(.headline)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 6)
                                                .background {
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .fill(Color.white)
                                                }
                                        })
                                    }
                                }
                            }
                            .padding(.trailing, 12)
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
        .navigationTitle("配装器")
    }
}

struct EquipView_Previews: PreviewProvider {
    static var previews: some View {
        EquipHomeView()
    }
}

//
//  HomeView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination: {
                ServerStateView()
            }, label: {
                VStack {
                    Text("服务器状态")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(14)
                }
            })
            NavigationLink(destination: {
                TalentPicker()
            }, label: {
                VStack {
                    Text("奇穴模拟")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(14)
                }
            })
            NavigationLink(destination: {
                EquipHomeView()
            }, label: {
                VStack {
                    Text("配装器")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(14)
                }
            })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

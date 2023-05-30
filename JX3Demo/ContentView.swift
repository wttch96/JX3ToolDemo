//
//  ContentView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                NavigationLink(destination: {
                    ServerStateView()
                }, label: {
                    DisplayBarView(iconName: "desktopcomputer", title: "服务器状态", content: {
                        ServerStateSimpleView()
                    })
                })
                NavigationLink(destination: {
                    ServerStateView()
                }, label: {
                    DisplayBarView(iconName: "desktopcomputer", title: "服务器状态", content: {
                        ServerStateSimpleView()
                    })
                })
                Spacer()
            }
            .background(Color.theme1.background)
            .tabItem {
                VStack {
                    Image(systemName: "house.fill")
                    Text("主页")
                        .font(.caption)
                }
            }
            NavigationStack {
                NavigationLink {
                    ScrollView {
                        ForEach(0..<100) { _ in
                            Text("aa")
                        }
                    }
                } label: {
                    ScrollView {
                        ForEach(0..<100) { _ in
                            Text("aa")
                        }
                    }
                }

            }
            .navigationBarTitle("Home")
            .tabItem {
                Image(systemName: "star")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

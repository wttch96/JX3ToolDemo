//
//  ServerStateSectionView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import SwiftUI

struct ServerStateSectionView: View {
    let title: String
    let servers: [ServerState]
    
    init(title: String, servers: [ServerState]?) {
        self.title = title
        self.servers = servers ?? []
    }
    
    var body: some View {
        VStack {
            Section(content: {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]) {
                    ForEach(servers, content: {server in
                        ServerStateItemView(serverState: server)
                    })
                }
                .padding(.horizontal, 8)
            }, header: {
                HStack {
                    Text(title)
                        .font(.title)
                        .bold()
                    Spacer()
                }
                .padding(.leading, 20)
            })
        }
    }
}

struct ServerStateSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ServerStateSectionView(title: "测试", servers: [dev.serverState])
    }
}

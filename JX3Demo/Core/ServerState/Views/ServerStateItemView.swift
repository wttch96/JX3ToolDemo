//
//  ServerStateItemView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import SwiftUI

struct ServerStateItemView: View {
    
    let serverState: ServerState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(serverState.serverName)
                    .font(.title)
                    .bold()
                Text(serverState.state)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .foregroundColor(serverState.color)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                    )
                Spacer()
            }
            Text("IP:\(serverState.ipAddress):\(serverState.ipPort)")
            Text("最近维护时间:\(serverState.maintainDate)")
        }
        .padding()
        .foregroundColor(.white)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .foregroundColor(serverState.color)
        )
    }
}

struct ServerStateItemView_Previews: PreviewProvider {
    static var previews: some View {
        ServerStateItemView(serverState: dev.serverState)
    }
}

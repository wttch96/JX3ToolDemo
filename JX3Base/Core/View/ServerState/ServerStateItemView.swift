//
//  ServerStateItemView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import SwiftUI

struct ServerStateItemView: View {
    @State private var pinServers: [String] = []
    @State private var showDetail = false
    @EnvironmentObject private var vm: ServerStateViewModel
    
    @State var serverState: ServerState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(serverState.serverName)
                    .bold()
                Spacer()
            }
            Text(serverState.state)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .foregroundColor(Color(serverState:serverState))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                )
//            Text("IP:\(serverState.ipAddress):\(serverState.ipPort)")
//            Text("最近维护时间:\(serverState.maintainDate)")
        }
        .padding(4)
        .foregroundColor(.white)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(Color(serverState: serverState))
        )
        .onTapGesture {
            showDetail.toggle()
        }
        .sheet(isPresented: $showDetail) {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(serverState.serverName)
                            .font(.largeTitle)
                            .bold()
                        Text(serverState.zoneName)
                            .font(.headline)
                    }
                    Text(serverState.state)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(serverState: serverState))
                        )
                    Spacer()
                    Image(systemName: serverState.isPined ? "pin.fill" : "pin.slash.fill")
                        .frame(width: 24, height: 24)
                        .padding(8)
                        .background(
                            Circle()
                                .foregroundColor(
                                    serverState.isPined ?
                                        .theme.accent : .theme.close)
                        )
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.2)) {
                                if self.serverState.isPined {
                                    vm.removePin(self.serverState)
                                } else {
                                    vm.savePin(self.serverState)
                                }
                            }
                        }
                }
                HStack {
                    Text("IP")
                        .font(.headline)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.theme.accent)
                        )
                    Text("\(serverState.ipAddress):\(serverState.ipPort)")
                    Spacer()
                }
                Text("上次维护时间:\(serverState.maintainDate)")
            }
            .padding()
            // sheet 高度只占 20%
            .presentationDetents([.fraction(0.2)])
        }
    }
}

struct ServerStateItemView_Previews: PreviewProvider {
    static var previews: some View {
        ServerStateItemView(serverState: dev.serverState)
    }
}

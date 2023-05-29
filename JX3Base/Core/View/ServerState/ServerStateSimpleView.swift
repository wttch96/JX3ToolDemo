//
//  ServerStateSimpleView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import SwiftUI

struct ServerStateSimpleView: View {
    @StateObject var vm = ServerStateViewModel()
    var body: some View {
        VStack {
            GeometryReader { proxy in
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible()), count: hCount(proxy))) {
                        ForEach(vm.allMainServerState) { state in
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundColor(Color(serverState: state))
                                .frame(width: 24, height: 24)
                                .onTapGesture {
                                    print("\(state.serverName)")
                                }
                        }
                    }
                    .frame(maxHeight: CGFloat(vCount(proxy, vm.allMainServerState.count)) * 36)
            }
        }
    }
    
    private func vCount(_ proxy: GeometryProxy, _ total: Int) -> Int {
        if hCount(proxy) == 0 { return 1 }
        return total / hCount(proxy) + 1
    }
    
    private func hCount(_ proxy: GeometryProxy) -> Int {
        return Int(proxy.size.width) / 36
    }
    
}

struct ServerStateSimpleView_Previews: PreviewProvider {
    static var previews: some View {
        ServerStateSimpleView()
            .background(.purple)
    }
}

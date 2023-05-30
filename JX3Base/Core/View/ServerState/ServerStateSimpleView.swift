//
//  ServerStateSimpleView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import SwiftUI

struct ServerStateSimpleView: View {
    @StateObject var vm = ServerStateViewModel()
    // 列数量
    @State private var columnCount: Int = 1
    // 行数量
    @State private var rowCount: Int = 1
    
    private let gridSize: Int = 36
    
    var body: some View {
        AutoResizeLazyVGrid(vm.allMainServerState) { state in
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(Color(serverState: state))
                .frame(width: 24, height: 24)
        }
    }
}

struct ServerStateSimpleView_Previews: PreviewProvider {
    static var previews: some View {
        ServerStateSimpleView()
            .background(.purple)
    }
}

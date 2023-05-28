//
//  ServerStateView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import SwiftUI

struct ServerStateView: View {
    
    @StateObject var vm = ServerStateViewModel()
    
    var body: some View {
        ScrollView {
            ForEach(vm.zoneServerStates.keys.sorted(), id: \.self) { key in
                ServerStateSectionView(title: key, servers: vm.zoneServerStates[key])
            }
        }
    }
}

struct ServerStateView_Previews: PreviewProvider {
    static var previews: some View {
        ServerStateView()
    }
}

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
            ServerStateSectionView(title: "我的关注", servers: vm.pinServerStates)
            
            ForEach(vm.zoneServerStates.keys.sorted(by: ZoneType.compareZone), id: \.self) { key in
                ServerStateSectionView(title: key, servers: vm.zoneServerStates[key])
            }
        }
        .refreshable {
            vm.loadServerStates()
        }
        .environmentObject(vm)
    }
}

struct ServerStateView_Previews: PreviewProvider {
    static var previews: some View {
        ServerStateView()
    }
}

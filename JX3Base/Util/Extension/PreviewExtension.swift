//
//  PreviewExtension.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev : Dev { return Dev() }
}

class Dev {
    let serverState = ServerState(zoneName: "双线一区", serverName: "天鹅坪", ipAddress: "127.0.0.0", ipPort: "188", mainServer: "天鹅坪", connectState: true, maintainTime: 1683153483, heat: "7", isPin: true)
    let serverState2 = ServerState(zoneName: "双线一区", serverName: "天鹅坪1", ipAddress: "127.0.0.0", ipPort: "188", mainServer: "天鹅坪", connectState: true, maintainTime: 1683153483, heat: "8", isPin: false)
    
    let servers: [ServerState]
    
    let talnet = Talent(id: "1", name: "测试测试", icon: nil, desc: "简述<br/>建树啊饿哦俗套恶俗太好饿土豪扫榻黑嫂河图", order: "1", pos: 1, skill: 0, meta: nil, extend: nil)
    let talnet2 = Talent(id: "1", name: "测试", icon: 11840, desc: "简述", order: "1", pos: 1, skill: 1, meta: nil, extend: nil)
    let talnets: [Talent]
    
    init() {
        self.servers = [self.serverState, self.serverState2]
        self.talnets = [self.talnet, self.talnet2]
    }
    
}

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
    
    let equip1: Equip
    let equip2: Equip
    let weapon1: Equip
    
    let mount1: Mount = Mount("问水诀")!
    let mount2: Mount = Mount("冰心诀")!
    
    let enchant1: Enchant
    
    let news: [BoxNews]
    
    init() {
        self.servers = [self.serverState, self.serverState2]
        self.talnets = [self.talnet, self.talnet2]
        
        self.equip1 = BundleUtil.loadJson("equip1.json", type: EquipDTO.self)!.toEntity()
        self.equip2 = BundleUtil.loadJson("equip2.json", type: EquipDTO.self)!.toEntity()
        self.weapon1 = BundleUtil.loadJson("weapon1.json", type: EquipDTO.self)!.toEntity()
        self.enchant1 = BundleUtil.loadJson("enchant1.json", type: Enchant.self)!
        
        self.news = BundleUtil.loadJson("news.json", type: [BoxNews].self)!
    }
    
}

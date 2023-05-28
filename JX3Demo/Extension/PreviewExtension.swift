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
    let serverState = ServerState(zoneName: "双线一区", serverName: "天鹅坪", ipAddress: "127.0.0.0", ipPort: "188", mainServer: "天鹅坪", connectState: true, maintainTime: 1683153483, heat: "7")
}

//
//  ServerState.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import Foundation
import SwiftUI

// MARK: - ServerState
struct ServerState: Identifiable, Codable {
    let zoneName, serverName, ipAddress, ipPort: String
    let mainServer: String
    let connectState: Bool
    let maintainTime: Int
    let heat: String

    enum CodingKeys: String, CodingKey {
        case zoneName = "zone_name"
        case serverName = "server_name"
        case ipAddress = "ip_address"
        case ipPort = "ip_port"
        case mainServer = "main_server"
        case connectState = "connect_state"
        case maintainTime = "maintain_time"
        case heat
    }
    
    var id: String {
        get { return zoneName + "/" + serverName }
    }
}


extension ServerState {
    var maintainDate: String {
        return Date(timeIntervalSince1970: Double(maintainTime)).formatted()
    }
    
    var color: Color {
        switch heat {
        case "8": return Color.theme.full
        case "7": return Color.theme.busy
        case "6": return Color.theme.open
        default: return Color.theme.close
        }
    }
    
    var state: String {
        switch heat {
        case "8": return "爆满"
        case "7": return "繁忙"
        case "6": return "良好"
        default: return "维护"
        }
    }
}

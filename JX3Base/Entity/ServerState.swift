//
//  ServerState.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import Foundation
import SwiftUI

// MARK: - ServerState
struct ServerState: Identifiable, Codable, Comparable {
    let zoneName, serverName, ipAddress, ipPort: String
    let mainServer: String
    let connectState: Bool
    let maintainTime: Int
    let heat: String
    
    var isPin: Bool?

    enum CodingKeys: String, CodingKey {
        case zoneName = "zone_name"
        case serverName = "server_name"
        case ipAddress = "ip_address"
        case ipPort = "ip_port"
        case mainServer = "main_server"
        case connectState = "connect_state"
        case maintainTime = "maintain_time"
        case heat
        case isPin
    }
    
    var id: String {
        get { return zoneName + "/" + serverName }
    }
    
    var isPined: Bool {
        get { return isPin ?? false }
    }
    
    static func < (lhs: ServerState, rhs: ServerState) -> Bool {
        return ZoneType.zone(lhs.zoneName) < ZoneType.zone(rhs.zoneName)
    }
}

// 服务器区域类型
enum ZoneType : Int, CaseIterable, Comparable {
    case doule = 1
    case telecom = 2
    case international = 3
    case match = 4
    case origin = 5
    case unowned = 10
    
    var name: String {
        switch self {
        case .doule: return "双线"
        case .telecom: return "电信"
        case .international: return "國際"
        case .match: return "比赛"
        case .origin: return "缘起"
        case .unowned: return "未知"
        }
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    
    static func zone(_ zoneName: String) -> ZoneType {
        for zone in ZoneType.allCases {
            if zoneName.contains(zone.name) {
                return zone
            }
        }
        return .unowned
    }
    
    static func compareZone(lhs: String, rhs: String) -> Bool {
        let z1 = ZoneType.zone(lhs)
        let z2 = ZoneType.zone(rhs)
        if z1 == z2 {
            return lhs < rhs
        }
        
        return z1 < z2
    }
}

extension ServerState {
    var maintainDate: String {
        return Date(timeIntervalSince1970: Double(maintainTime)).formatted()
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


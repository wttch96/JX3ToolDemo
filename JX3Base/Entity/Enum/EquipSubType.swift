//
//  EquipSubType.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/21.
//

import Foundation

enum EquipSubType : String, CaseIterable, Codable {
    case PRIMARY_WEAPON = "0"
    case SENCONDARY_WEAPON = "1"
    case JACKET = "2"
    case HAT = "3"
    case NECKLACE = "4"
    case RING = "5"
    case BELT = "6"
    case PENDANT = "7"
    case BOTTOMS = "8"
    case SHOES = "9"
    case WRIST = "10"
    
    var position : Int { return extra.0 }
    var name : String { return extra.1 }
    
    /// HAT                头部    3
    /// JACKET         上衣    2
    /// BELT              腰带    6
    /// WRIST           护腕    10
    /// BOTTOMS     下装    8
    /// SHOES          鞋子    9
    /// NECKLACE   项链    4
    /// PENDANT     腰坠    7
    /// RING_1        戒指    5
    /// RING_2        戒指    5
    /// PRIMARY_WEAPON    主武器    0
    /// TERTIARY_WEAPON   副武器    0
    /// SECONDARY_WEAPON 暗器     1
    var extra : (Int, String) {
        switch self {
        case .PRIMARY_WEAPON: return (0, "近身武器")
        case .SENCONDARY_WEAPON: return (1, "远程器")
        case .JACKET: return (2, "上衣")
        case .HAT: return (3, "头部")
        case .NECKLACE: return (4, "项链")
        case .RING: return(5, "戒指")
        case .BELT: return(6, "腰带")
        case .PENDANT: return(7, "腰坠")
        case .BOTTOMS: return(8, "下装")
        case .SHOES: return(9, "鞋子")
        case .WRIST: return(10, "护腕")
        }
    }
}

//
//  Environment.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/20.
//

import Foundation
import SwiftUI

struct MountEnvironmentKey: EnvironmentKey {
    static var defaultValue: Mount = Mount("问水诀")!
}

struct EquipPositionEnvironmentKey: EnvironmentKey {
    static var defaultValue: EquipPosition = .amulet
}

extension EnvironmentValues {
    
    var mount: Mount {
        get {
            self[MountEnvironmentKey.self]
        }
        set {
            self[MountEnvironmentKey.self] = newValue
        }
    }
    
    var equipPosition: EquipPosition {
        get {
            self[EquipPositionEnvironmentKey.self]
        }
        set {
            self[EquipPositionEnvironmentKey.self] = newValue
        }
    }
}

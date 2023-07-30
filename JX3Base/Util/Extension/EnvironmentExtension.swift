//
//  EnvironmentExtension.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/3.
//

import Foundation
import SwiftUI

private struct DebugKey: EnvironmentKey {
    static let defaultValue = false
}


extension EnvironmentValues {
    var debug: Bool {
        get { self[DebugKey.self] }
        set { self[DebugKey.self] = newValue }
    }
}

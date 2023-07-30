//
//  TransitionExtension.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/3.
//

import Foundation
import SwiftUI


extension AnyTransition {
    static var talentInOut: AnyTransition {
        return AnyTransition.asymmetric(
            insertion: .move(edge: .leading),
            removal: .opacity)
    }
}

//
//  JX3MacAppApp.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/5/29.
//

import SwiftUI

@main
struct JX3MacAppApp: App {
    var body: some Scene {
        WindowGroup {
            // ContentView()
            EquipEditorView(mount: Mount("花间游")!)
        }
        
        
        WindowGroup(id: "WebWindowGroup") {
            OpenUrlWewView()
                // .handlesExternalEvents(preferring: Set(arrayLiteral: "WebWindowGroup"), allowing: Set(arrayLiteral: "*"))
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "WebWindowGroup"))
    }
}

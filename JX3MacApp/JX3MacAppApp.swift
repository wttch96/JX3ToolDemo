//
//  JX3MacAppApp.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/5/29.
//

import SwiftUI

@main
struct JX3MacAppApp: App {
    
    init() {
        logger.logLevel = .debug
    }
    
    var body: some Scene {
        WindowGroup {
            EquipProgrammeListView()
        }
        WindowGroup(id: "EquipEditor") {
            // ContentView()
            EquipProgrammeWindow()
                .navigationTitle("配装器")
            // EquipEditorView(mount: Mount("花间游")!)
            // EquipEditorView(mount: Mount("天罗诡道")!)
            // EquipEditorView(mount: Mount("明尊琉璃体")!)
            // EquipEditorView(mount: Mount("铁骨衣")!)
            // EquipEditorView(mount: Mount("洗髓经")!)
            // EquipEditorView(mount: Mount("北傲诀")!)
            // EquipEditorView(mount: Mount("离经易道")!)
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "EquipEditor"))

        
        WindowGroup(id: "WebWindowGroup") {
            OpenUrlWewView()
                // .handlesExternalEvents(preferring: Set(arrayLiteral: "WebWindowGroup"), allowing: Set(arrayLiteral: "*"))
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "WebWindowGroup"))

    }
}

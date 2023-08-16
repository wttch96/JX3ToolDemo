//
//  EquipProgrammeWindow.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/8/14.
//

import SwiftUI

struct EquipProgrammeWindow: View {
    @State private var mount: Mount? = nil
    @State private var record: EquipProgrammeRecord? = nil
    
    private let service = EquipProgrammeRecordService()
    var body: some View {
        ZStack {
            if let mount = mount {
                EquipEditorView(mount: mount, record: record)
            }
        }
        .onOpenURL { url in
            if let component = URLComponents(string: url.absoluteString),
               let idItem = component.queryItems?.first(where: { $0.name == "id" }),
               let id = idItem.value,
               let record = service.findById(id) {
                self.record = record
                self.mount = Mount(id: Int(record.mountId))
            }
        }
    }
}

struct EquipProgrammeWindow_Previews: PreviewProvider {
    static var previews: some View {
        EquipProgrammeWindow()
    }
}

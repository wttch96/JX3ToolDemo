//
//  EquipProgrammeListView.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/8/12.
//

import SwiftUI

struct EquipProgrammeListView: View {
    @State private var mount: Mount = .common
    
    // 显示新建配装的名称
    @State private var showNamePop = false
    @State private var equipProgrameName: String = ""
    @State private var equipProgrameRecords: [EquipProgrammeRecord] = []
    
    private let service = EquipProgrammeRecordService()
    var body: some View {
        VStack {
            KungfuPicker(selectedKungfu: $mount)
            Table(equipProgrameRecords, columns: {
                TableColumn("ID") { record in
                    Text("\(record.id?.uuidString ?? "")")
                }
                TableColumn("心法") { record in
                    if let mount = Mount(id: Int(record.mountId)) {
                        HStack {
                            KungfuIcon(kungfu: mount, selected: true, borderWidth: 0)
                                .frame(maxHeight: 18)
                            Text(mount.name)
                        }
                    } else {
                        Text("未知心法")
                    }
                }
                TableColumn("名称") { record in
                    Text(record.name ?? "")
                }
                TableColumn("操作") { record in
                    HStack {
                        Button(action: {
                            service.delete(record)
                            equipProgrameRecords = service.findByMount(mount)
                            
                        }) {
                            Image(systemName: "trash")
                        }
                        
                        Button(action: {
                            if let url = URL(string: "JX3MacApp://EquipEditor?id=\(record.id?.uuidString ?? "")") {
                                NSWorkspace.shared.open(url)
                            }
                        }) {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                }
            })
            
            Spacer()
        }
        .toolbar(content: {
            ToolbarItem(content: {
                Button("添加", action: {
                    showNamePop.toggle()
                })
                .disabled(mount == .common)
            })
        })
        .onAppear {
            equipProgrameRecords = service.findByMount(mount)
        }
        .onChange(of: mount, perform: { newValue in
            equipProgrameRecords = service.findByMount(newValue)
        })
        .popover(isPresented: $showNamePop, content: {
            VStack {
                HStack {
                    Text("心法:")
                    KungfuIcon(kungfu: mount, selected: true, borderWidth: 0)
                    Text(mount.name)
                }
                HStack {
                    Text("配装名称:")
                        .foregroundColor(equipProgrameName.isEmpty ? .red : .white)
                    TextField("输入配装名称", text: $equipProgrameName)
                }
                
                HStack {
                    Spacer()
                    if !equipProgrameName.isEmpty {
                        Button("确定", action: {
                            service.createEquipProgrammeRecord(mount: mount, name: equipProgrameName)
                            showNamePop.toggle()
                        })
                    }
                }
            }
            .padding()
        })
    }
}

struct EquipProgrammeListView_Previews: PreviewProvider {
    static var previews: some View {
        EquipProgrammeListView()
    }
}

//
//  EquipProgrammeRecordService.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/8/14.
//

import Foundation
import CoreData


/// 配装记录
class EquipProgrammeRecordService {
    
    private let manager = CoreDataManager.instance
    
    func findById(_ id: String) -> EquipProgrammeRecord? {
        let fetch = NSFetchRequest<EquipProgrammeRecord>(entityName: "EquipProgrammeRecord")
        
        fetch.predicate = NSPredicate(format: "id = '\(id)'")
        
        return try? manager.context.fetch(fetch).first
    }
    
    func findByMount(_ mount: Mount) -> [EquipProgrammeRecord] {
        let fetch = NSFetchRequest<EquipProgrammeRecord>(entityName: "EquipProgrammeRecord")
        if mount != .common {
            fetch.predicate = NSPredicate(format: "mountId = %ld", mount.id)
        }
        
        do {
            return try manager.context.fetch(fetch)
        } catch let error {
            logger.info("Load EquipProgrammeRecord error...\(error.localizedDescription)")
            return []
        }
    }
    
    func createEquipProgrammeRecord(mount: Mount, name: String) {
        let record = EquipProgrammeRecord(context: manager.context)
        record.id = UUID()
        record.name = name
        record.mountId = Int64(mount.id)
        do {
            try manager.context.save()
            logger.info("新建配装记录: 心法\(mount.name) - 【\(name)】")
        } catch let error {
            logger.error("保存配装记录失败: \(error.localizedDescription)")
        }
    }
    
    func delete(_ record: EquipProgrammeRecord) {
        manager.context.delete(record)
        do {
            let name = record.name
            try manager.context.save()
            logger.info("删除配装记录:\(name ?? "")")
        } catch let error {
            logger.error("删除配装记录失败: \(error.localizedDescription)")
        }
    }
}

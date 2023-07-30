//
//  CoreDataManager.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/28.
//

import Foundation
import CoreData

// Core Data 管理类
class CoreDataManager {
    static let instance = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: "JX3")
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Load core data error: \(error.localizedDescription)")
            }
        }
        context = container.viewContext
    }
    
    // 保存 Core Data
    func save() {
        do {
            try context.save()
            print("Save core data successful.")
        } catch let error {
            print("Save core data error: \(error.localizedDescription)")
        }
    }
    
}

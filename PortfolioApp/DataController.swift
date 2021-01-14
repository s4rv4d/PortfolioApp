//
//  DataController.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 09/12/2020.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    
    // MARK: - Properties
    let container: NSPersistentCloudKitContainer
    
    // MARK: Initializers
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            // inMemory is for testing data on ram rather than stored on storage i.e., volatile memory, data gets deleted on reset
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // loading persistent stores
        container.loadPersistentStores { storeDescription, error in
            
            if let error = error {
                fatalError("error while loading store: \(error.localizedDescription)")
            }
        }
    }
    
    // creating preview
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("error creating preview: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    // MARK: - Methods
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for i in 0...5 {
            // creating projects
            let project = Project(context: viewContext)
            project.title = "Project \(i)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()
            
            // creating items
            for j in 0...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(j)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.project = project
                item.priority = Int16.random(in: 1...3)
            }
        }
        
        try viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    // used mainly for previews
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }
    
    // generic func to get a count of items, efficient as it doesnt have to parse through all data every single time
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    // to check if award is earned
    func hasEarned(for award: Award) -> Bool {
        switch award.criterion {
        case "items":
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "complete":
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        default:
//            fatalError("Unknown award criterion: \(award.criterion)")
        return false
        }
    }
}

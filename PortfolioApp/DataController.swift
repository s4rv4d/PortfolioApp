//
//  DataController.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 09/12/2020.
//

// swiftlint:disable trailing_whitespace

import CoreData
import SwiftUI

/// An environment singleton responsible for managing our CoreData stack, including handling saving,
/// counting fetch requests, tracking awards, and dealing with sample data.
class DataController: ObservableObject {
        
    /// the lone CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer
    
    /// This initialises a data controller either in memory (for temporary use such as testing or previewing)
    /// or on permanent storage (for use in regular app runs),
    ///
    /// defaults to permanent storage.
    /// - Parameter inMemory: whether to store data in temporary memory or permanent storage.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        if inMemory {
            // swiftlint:disable:next line_length
            // inMemory is for testing data on ram rather than stored on storage i.e., volatile memory, data gets deleted on reset
            // this is for testing and previewing purposes
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        // loading persistent stores
        container.loadPersistentStores { _, error in
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
    
    /// Creates example projects and items to test
    /// - Throws: throws NSError sent from calling save() from NSManagedObject
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for index in 0..<5 {
            // creating projects
            let project = Project(context: viewContext)
            project.title = "Project \(index)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()
            
            // creating items
            for index2 in 0..<10 {
                let item = Item(context: viewContext)
                item.title = "Item \(index2)"
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
    
    /// used mainly for previews
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }
    
    /// generic func to get a count of items, efficient as it doesnt have to parse through all data every single time
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    /// to check if award is earned
    func hasEarned(for award: Award) -> Bool {
        switch award.criterion {
        case "items":
            // returns true if user added certain number of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "complete":
            // returns true if user completed certain number of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        default:
            // unknown criterion, which should not be allowed
            return false
        }
    }
}

//
//  Item-CoreDataHelpers.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 10/12/2020.
//

// swiftlint:disable trailing_whitespace

import Foundation

extension Item {
    enum SortOrder {
        case optimized, title, creationDate
    }
    var itemTitle: String {
        title ?? NSLocalizedString("New Item", comment: "Create a new item in a project")
    }
    
    var itemDetail: String {
        detail ?? ""
    }
    
    var itemCreationDate: Date {
        creationDate ?? Date()
    }
    
    static var example: Item {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let item = Item(context: viewContext)
        item.title = "Example item"
        item.detail = "This is an example item"
        item.priority = 3
        item.creationDate = Date()
        
        return item
    }
}

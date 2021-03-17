//
//  PortfolioAppTests.swift
//  PortfolioAppTests
//
//  Created by Sarvad Shetty on 17/03/2021.
//

import CoreData
import XCTest
@testable import PortfolioApp

class BaseTestCase: XCTestCase {

    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}

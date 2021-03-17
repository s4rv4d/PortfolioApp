//
//  AwardTest.swift
//  PortfolioAppTests
//
//  Created by Sarvad Shetty on 17/03/2021.
//

import CoreData
import XCTest
@testable import PortfolioApp

class AwardTest: BaseTestCase {
    let awards = Award.allItems

    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award ID should always match its name")
        }
    }

    func testNewUserHasNoAwards() {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(for: award), "New users should have no earned awards")
        }
    }
    
    func testAddingItems() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]
    }
}

//
//  AssetTest.swift
//  PortfolioAppTests
//
//  Created by Sarvad Shetty on 17/03/2021.
//

import XCTest
@testable import PortfolioApp

class AssetTest: XCTestCase {
    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog")
        }
    }

    func testJSONLoadsCorrectly() {
        XCTAssertFalse(Award.allItems.isEmpty, "Failed to load awards from JSON")
    }
}

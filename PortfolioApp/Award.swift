//
//  Award.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 12/01/2021.
//

import Foundation

struct Award: Decodable, Identifiable {
    
    var id: String { name }
    let name: String
    let description: String
    let color: String
    let criterion: String
    let value: Int
    let image: String
    
    static let allItems = Bundle.main.decode([Award].self, from: "Awards.json")
}

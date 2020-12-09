//
//  PortfolioAppApp.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 09/12/2020.
//

import SwiftUI

@main
struct PortfolioAppApp: App {
    
    @StateObject var dataController: DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}

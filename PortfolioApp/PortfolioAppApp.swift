//
//  PortfolioAppApp.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 09/12/2020.
//

import SwiftUI

@main
struct PortfolioAppApp: App {
    
    // MARK: - Property wrappers
    @StateObject var dataController: DataController
    
    // MARK: - Initializers
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    // MARK: - Life cycle
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                /// when app goes into background, save changes
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save(_:))
        }
    }
    
    // MARK: - Functions
    func save(_ not: Notification) {
        dataController.save()
    }
}

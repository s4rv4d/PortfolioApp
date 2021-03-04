//
//  PortfolioAppApp.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 09/12/2020.
//

// swiftlint:disable trailing_whitespace

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
                .onReceive(
                    // automatically save when we detect that we are no longer the foreground
                    // app atm. Use this rather than the scene phase API so that we can port
                    // to macOS where scene phase won't detect out app losing focus as off
                    // macOS 11.1.
                    NotificationCenter.default.publisher(
                        for: UIApplication.willResignActiveNotification),
                    perform: save(_:)
                )
            // when app goes into background, save changes
        }
    }
    
    // MARK: - Functions
    func save(_ not: Notification) {
        dataController.save()
    }
}

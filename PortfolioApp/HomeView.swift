//
//  HomeView.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 09/12/2020.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Add Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
            .navigationTitle(Text("Home"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

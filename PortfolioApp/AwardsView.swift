//
//  AwardsView.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 14/01/2021.
//

import SwiftUI

struct AwardsView: View {
    
    static let tag: String? = "Awards"
    
    @EnvironmentObject var dataController: DataController
    
    @State private var selectedAwards = Award.example
    @State private var showingAwardDetail = false
    
    /// 100x100
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allItems) { award in
                        // button
                        Button {
                            selectedAwards = award
                            showingAwardDetail = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(dataController.hasEarned(for: award) ? Color(award.color) : Color.secondary.opacity(0.5))
                        }
                        .accessibilityLabel(Text(dataController.hasEarned(for: award) ? "Unlocked award: \(award.name)" : "Locked!"))
                        .accessibilityHint(Text(award.description))
                    }
                }
            }
            .navigationTitle(Text("Awards"))
        }
        .alert(isPresented: $showingAwardDetail) {
            if dataController.hasEarned(for: selectedAwards) {
                return Alert(title: Text("Unlocked award: \(selectedAwards.name)"), message: Text(selectedAwards.description), dismissButton: .default(Text("OK")))
            } else {
                return Alert(title: Text("Locked!"), message: Text(selectedAwards.description), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
    }
}

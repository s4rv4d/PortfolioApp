//
//  EditItemView.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 20/12/2020.
//

import SwiftUI

struct EditItemView: View {
    
    let item: Item
    @EnvironmentObject var dataController: DataController
    
    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool
    
    init(item: Item) {
        self.item = item
        
        self._title = State(wrappedValue: item.itemTitle)
        self._detail = State(wrappedValue: item.itemDetail)
        self._priority = State(wrappedValue: Int(item.priority))
        self._completed = State(wrappedValue: item.completed)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Basic Settings")) {
                TextField("Item name", text: $title)
                TextField("Description", text: $detail)
            }
            
            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section {
                Toggle("Mark completed", isOn: $completed)
            }
        }
        .navigationTitle("Edit item")
        .onDisappear(perform: update)
    }
    
    func update() {
        
        // need to notify of change
        item.project?.objectWillChange.send()
        
        item.title = title
        item.detail = detail
        item.priority = Int16(priority)
        item.completed = completed
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
    }
}

//
//  EditItemView.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 20/12/2020.
//

// swiftlint:disable trailing_whitespace

import SwiftUI

struct EditItemView: View {
    /// dont need to add @ObservedObjects, because managedObjects are observable by default
    let item: Item
    @EnvironmentObject var dataController: DataController
    
    // MARK: - Property wrappers
    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool
    
    // MARK: - Initializer
    init(item: Item) {
        self.item = item
        self._title = State(wrappedValue: item.itemTitle)
        self._detail = State(wrappedValue: item.itemDetail)
        self._priority = State(wrappedValue: Int(item.priority))
        self._completed = State(wrappedValue: item.completed)
    }
    
    // MARK: - Life cycle
    var body: some View {
        Form {
            Section(header: Text("Basic Settings")) {
                TextField("Item name", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            }
            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority.onChange(update)) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            Section {
                Toggle("Mark completed", isOn: $completed.onChange(update))
            }
        }
        .navigationTitle("Edit item")
        .onDisappear(perform: dataController.save)
    }
    // MARK: - Functions
    func update() {
        /// need to notify of change, changing the parent project will in turn update all the items in it
        item.project?.objectWillChange.send()
        /// and updated
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

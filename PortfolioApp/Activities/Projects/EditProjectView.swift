//
//  EditProjectView.swift
//  PortfolioApp
//
//  Created by Sarvad Shetty on 21/12/2020.
//

// swiftlint:disable trailing_whitespace

import SwiftUI

struct EditProjectView: View {
    
    let project: Project
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false
    
    /// for grid
    let colorColumns = [GridItem(.adaptive(minimum: 44))]
    
    init(project: Project) {
        self.project = project
        
        self._title = State(wrappedValue: project.projectTitle)
        self._detail = State(wrappedValue: project.projectDetail)
        self._color = State(wrappedValue: project.projectColor)
    }
    
    var body: some View {
        Form {
            /// section 1
            Section(header: Text("Basic settings")) {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }
            
            /// section 2
            Section(header: Text("Custom project colors")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self) { item in
                        ZStack {
                            Color(item)
                                /// aspect ratio of 1 turns it into square
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(6)
                            
                            if item == color {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                        }
                        .onTapGesture {
                            self.color = item
                            update()
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityAddTraits(
                            item == color
                                ? [.isButton, .isSelected]
                                : .isButton
                        )
                        .accessibilityLabel(LocalizedStringKey(item))
                    }
                }
                padding(.vertical)
            }
            
            /// section 3
            // swiftlint:disable:next line_length
            Section(footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project entirely")) {
                Button(project.closed ? "Reopen this project" : "Close this project") {
                    project.closed.toggle()
                    update()
                }
                
                Button("Delete this project") {
                    /// deleting the project
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle(Text("Edit Project"))
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
                title: Text("Delete project?"),
                message: Text("Are you sure you want to delete this project? You will also delete all the items it contains"), // swiftlint:disable:this line_length
                primaryButton: .default(Text("Delete"), action: delete),
                secondaryButton: .cancel()
            )
        }
    }
    
    func update() {
        project.title = title
        project.detail = detail
        project.color = color
    }
    
    func delete() {
        /// once dismissed the context is saved and updated
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}

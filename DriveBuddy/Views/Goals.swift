//
//  Goals.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/9/21.
//

import SwiftUI
import CoreData

enum SortOrder {
    case byName
    case byRemaining
    mutating func toggle() {
        switch self {
        case .byName:
            self = .byRemaining
        case .byRemaining:
            self = .byName
        }
    }
    
}

struct Goals: View {
    var body: some View {
            GoalList2()
    }
}

struct GoalList2: View {
    @State private var sortOrder: SortOrder = .byName
    private var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    var body: some View {
        GoalList3(fetchRequest:fetchRequest, sortOrder: $sortOrder)
            .onReceive(didSave) {_ in
                // CoreData doesn't automatically fetchf when relations change.
                if sortOrder == .byName {
                    // Toggle twice has the effect of forcing a new fetch request to be made.
                    sortOrder.toggle()
                    sortOrder.toggle()
                }
            }
    }
    
    private var fetchRequest: FetchRequest<Goal> {
        switch sortOrder {
        case .byName:
            return FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Goal.goal, ascending: true)])
        case .byRemaining:
            return FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "done == 0"))
        }
    }
}

struct GoalList3: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var fetchRequest:FetchRequest<Goal>
    
    @Binding var sortOrder: SortOrder
    
    private var goals: FetchedResults<Goal> {
        fetchRequest.wrappedValue
    }
    
    /// Controls the presentation of the goal creation sheet.
    @State private var newGoalIsPresented = false
    
    var body: some View {
        goalList
            .navigationBarTitle(Text("\(goals.count) Goals"))
            .navigationBarItems(
                leading: HStack {
                    EditButton()
                    newGoalButton
                },
                trailing: toggleOrderingButton)
    }
    
    private var goalList: some View {
        List {
            ForEach(goals) { goal in
                NavigationLink(destination: editorView(for: goal)) {
                    GoalRow(goal: goal)
                        .animation(nil)
                }
            }
            .onDelete(perform: deleteGoals)
        }
        .listStyle(PlainListStyle())
    }
    
    /// The view that edits a item in the list.
    private func editorView(for goal: Goal) -> some View {
        GoalEditor(
            context:viewContext,
            goal: goal)
            .navigationBarTitle(goal.wrappedName)
    }
    
    /// The button that presents the item creation sheet.
    private var newGoalButton: some View {
        Button(
            action: {
                self.newGoalIsPresented = true
            },
            label: {
                Label("Add Goal ", systemImage: "plus").imageScale(.medium)
                    .padding(2.5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .fill(Color.accentColor)
                    )
                
            })
            .sheet(
                isPresented: $newGoalIsPresented,
                content: { self.newGoalCreationSheet })
    }
    
    /// The goal creation sheet.
    private var newGoalCreationSheet: some View {
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = viewContext
        return GoalCreationSheet(
            context:childContext,
            goal: Goal(context: childContext),
            dismissAction: {
                self.newGoalIsPresented = false
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
    
            })
            .environment(\.managedObjectContext, childContext)
            .accentColor(.purple)
    }
    
    private func deleteGoals(offsets: IndexSet) {
        withAnimation {
            offsets.map { goals[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    /// The button that toggles between name/done ordering.
    private var toggleOrderingButton: some View {
        switch sortOrder {
        case .byName:
            return Button(action: toggleSortOrder, label: {
                HStack {
                    Text("Goal Name")
                    Image(systemName: "tag")
                        .imageScale(.small)
                }
            })
        case .byRemaining:
            return Button(action: toggleSortOrder, label: {
                HStack {
                    Text("Remaining")
                    Image(systemName: "tray.2")
                        .imageScale(.small)
                }
            })
        }
    }
    
    private func toggleSortOrder() {
        sortOrder.toggle()
    }
}

struct GoalRow: View {
    @ObservedObject var goal: Goal
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(goal.wrappedName)
        }
    }
}

struct Goals_Previews: PreviewProvider {
    static var previews: some View {
        Goals()
    }
}

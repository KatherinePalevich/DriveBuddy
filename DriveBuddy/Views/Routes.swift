//
//  Routes.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/13/21.
//

import SwiftUI

import SwiftUI
import CoreData

enum DriveSortOrder {
    case byFirst
    case byLast
    mutating func toggle() {
        switch self {
        case .byFirst:
            self = .byLast
        case .byLast:
            self = .byFirst
        }
    }
    
}

struct Routes: View {
    var body: some View {
        RouteList2()
    }
}

struct RouteList2: View {
    @State private var sortOrder: DriveSortOrder = .byLast
    private var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    var body: some View {
        RouteList3(fetchRequest:fetchRequest, sortOrder: $sortOrder)
            .onReceive(didSave) {_ in
                // CoreData doesn't automatically fetchf when relations change.
                if sortOrder == .byLast {
                    // Toggle twice has the effect of forcing a new fetch request to be made.
                    sortOrder.toggle()
                    sortOrder.toggle()
                }
            }
    }
    
    private var fetchRequest: FetchRequest<Drive> {
        switch sortOrder {
        case .byFirst:
            return FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Drive.date, ascending: true)])
        case .byLast:
            return FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Drive.date, ascending: false)])
        }
    }
}

struct RouteList3: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var fetchRequest:FetchRequest<Drive>
    
    @Binding var sortOrder: DriveSortOrder
    
    private var drives: FetchedResults<Drive> {
        fetchRequest.wrappedValue
    }
    
    /// Controls the presentation of the goal creation sheet.
    @State private var newDriveIsPresented = false
    @State private var liveDriveIsPresented = false
    @State private var drive : Drive?
    
    var body: some View {
        driveList
            .navigationBarTitle(Text("\(drives.count) Drives"))
            .navigationBarItems(
                leading: HStack {
                    EditButton()
                    newDriveButton
                },
                trailing: toggleOrderingButton)
            .sheet(isPresented: $liveDriveIsPresented){
                LiveDrive(drive: drive!, showLiveDrive: $liveDriveIsPresented)
            }
    }
    
    private var driveList: some View {
        List {
            ForEach(drives) { drive in
                NavigationLink(destination: editorView(for: drive)) {
                    DriveRow(drive: drive)
                        .animation(nil)
                }
            }
            .onDelete(perform: deleteDrives)
        }
        .listStyle(PlainListStyle())
    }
    
    /// The view that edits a item in the list.
    private func editorView(for drive: Drive) -> some View {
        DriveEditor(
            context:viewContext,
            drive: drive)
            .navigationBarTitle(date(drive: drive))
    }
    
    private func date(drive: Drive) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        dateFormatter.string(from: drive.wrappedDate)
        return dateFormatter.string(from: drive.wrappedDate)
    }
    
    /// The button that presents the item creation sheet.
    private var newDriveButton: some View {
        Button(
            action: {
                self.newDriveIsPresented = true
            },
            label: {
                Label("", systemImage: "plus.circle").imageScale(.large)
            })
            .sheet(
                isPresented: $newDriveIsPresented,
                content: { self.newDriveCreationSheet })
    }
    
    /// The goal creation sheet.
    private var newDriveCreationSheet: some View {
        return DriveCreationSheet(
            dismissAction: { goals in
                self.newDriveIsPresented = false
                if !goals.isEmpty {
                    self.drive = newDrive(goals: goals)
                    self.liveDriveIsPresented = true
                }
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
    
            })
            .accentColor(.purple)
    }
    
    private func newDrive(goals: Set<Goal>) -> Drive {
        let drive = Drive(context: viewContext)
        drive.date = Date()
        drive.goals = goals as NSSet
        return drive
    }
    
    private func deleteDrives(offsets: IndexSet) {
        withAnimation {
            offsets.map { drives[$0] }.forEach(viewContext.delete)
            
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
        case .byLast:
            return Button(action: toggleSortOrder, label: {
                HStack {
                    Image(systemName: "car.2").imageScale(.large)
                }
            })
        case .byFirst:
            return Button(action: toggleSortOrder, label: {
                HStack {
                    Image(systemName: "car.2.fill").imageScale(.large)
                }
            })
        }
    }
    
    private func toggleSortOrder() {
        sortOrder.toggle()
    }
}

struct DriveRow: View {
    @ObservedObject var drive: Drive
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(date)
        }
    }
    
    private var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        dateFormatter.string(from: drive.wrappedDate)
        return dateFormatter.string(from: drive.wrappedDate)
    }
}


struct Routes_Previews: PreviewProvider {
    static var previews: some View {
        Routes()
    }
}

//
//  DriveCreationSheet.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 4/3/21.
//

import CoreData
import SwiftUI

struct DriveCreationSheet: View {
    let context: NSManagedObjectContext
    /// Manages editing of the new drive
    @ObservedObject var drive: Drive

    /// Executed when user cancels or saves the new drive.
    let dismissAction: () -> Void

    @State private var errorAlertIsPresented = false
    @State private var errorAlertTitle = ""

    var body: some View {
        NavigationView {
            DriveForm(drive: drive)
                .alert(
                    isPresented: $errorAlertIsPresented,
                    content: { Alert(title: Text(errorAlertTitle)) })
                .navigationBarTitle("New Drive")
                .navigationBarItems(
                    leading: Button(
                        action: self.dismissAction,
                        label: { Text("Cancel") }),
                    trailing: Button(
                        action: self.save,
                        label: { Text("Save") }))
        }
    }

    private func save() {
        do {
            try context.save()
            dismissAction()
        } catch {
            errorAlertTitle = (error as? LocalizedError)?.errorDescription ?? "An error occurred"
            errorAlertIsPresented = true
        }
    }
}

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
    let dismissAction: (Goal?) -> Void

    @State private var errorAlertIsPresented = false
    @State private var errorAlertTitle = ""
    @State private var selectedGoal : Goal?

    var body: some View {
        NavigationView {
            GoalPicker(selectedGoal: $selectedGoal)
                .alert(
                    isPresented: $errorAlertIsPresented,
                    content: { Alert(title: Text(errorAlertTitle)) })
                .navigationBarTitle("New Drive")
                .navigationBarItems(
                    leading: Button(
                        action: {self.dismissAction(nil)},
                        label: { Text("Cancel") }),
                    trailing: Button(
                        action: self.startDrive,
                        label: { Text("Start") }))
        }
    }

    private func startDrive() {
        dismissAction(selectedGoal)
    }
    
    private func save() {
        do {
            try context.save()
            dismissAction(selectedGoal)
        } catch {
            errorAlertTitle = (error as? LocalizedError)?.errorDescription ?? "An error occurred"
            errorAlertIsPresented = true
        }
    }
}

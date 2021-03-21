//
//  GoalCreationSheet.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/13/21.
//

import CoreData
import SwiftUI

struct GoalCreationSheet: View {
    let context: NSManagedObjectContext
    /// Manages editing of the new item
    @ObservedObject var goal: Goal

    /// Executed when user cancels or saves the new item.
    let dismissAction: () -> Void

    @State private var errorAlertIsPresented = false
    @State private var errorAlertTitle = ""

    var body: some View {
        NavigationView {
            GoalForm(goal: goal)
                .alert(
                    isPresented: $errorAlertIsPresented,
                    content: { Alert(title: Text(errorAlertTitle)) })
                .navigationBarTitle("New Goal")
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
            goal.done = false
            try context.save()
            dismissAction()
        } catch {
            errorAlertTitle = (error as? LocalizedError)?.errorDescription ?? "An error occurred"
            errorAlertIsPresented = true
        }
    }
}

//
//  DriveCreationSheet.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 4/3/21.
//

import CoreData
import SwiftUI

struct DriveCreationSheet: View {    
    /// Executed when user cancels or saves the new drive.
    let dismissAction: (Set<Goal>) -> Void

    @State private var errorAlertIsPresented = false
    @State private var errorAlertTitle = ""
    @State private var selectedGoals : Set<Goal> = []

    var body: some View {
        NavigationView {
            GoalPicker(selection: $selectedGoals)
                .alert(
                    isPresented: $errorAlertIsPresented,
                    content: { Alert(title: Text(errorAlertTitle)) })
                .navigationBarTitle("New Drive")
                .toolbar(){
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(
                            action: {self.dismissAction([])},
                            label: { Text("Cancel") })
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(
                            action: self.startDrive,
                            label: { Text("Start") })
                    }
                }
//                .navigationBarItems(
//                    leading: Button(
//                        action: {self.dismissAction([])},
//                        label: { Text("Cancel") }),
//                    trailing: Button(
//                        action: self.startDrive,
//                        label: { Text("Start") }))
        }
    }

    private func startDrive() {
        dismissAction(selectedGoals)
    }
    
    private func save() {
        dismissAction(selectedGoals)
    }
}

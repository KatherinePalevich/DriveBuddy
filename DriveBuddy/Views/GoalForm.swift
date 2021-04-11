//
//  GoalForm.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/20/21.
//

import CoreData
import SwiftUI

struct GoalForm: View {
    /// Manages the item form
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var goal: Goal
    private let pasteboard = UIPasteboard.general

    var body: some View {
        Form {
            TextField("Goal", text: $goal.wrappedName)
            Toggle(isOn: $goal.completed) {
                Text("Completed")
            }
            TextEditor(text: $goal.wrappedDetails)
        }
    }
}

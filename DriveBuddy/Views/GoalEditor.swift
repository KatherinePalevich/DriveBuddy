//
//  GoalEditor.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/13/21.
//

import CoreData
import SwiftUI

/// The Item editor view, designed to be the destination of
/// a NavigationLink.
struct GoalEditor: View {
    let context: NSManagedObjectContext
    /// Manages editing the player
    @ObservedObject var goal: Goal

    var body: some View {
        GoalForm(goal: goal)
            .onDisappear(perform: {
                // Ignore validation errors
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            })
    }
}

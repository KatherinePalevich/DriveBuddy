//
//  GoalPicker.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 5/1/21.
//
import Foundation
import SwiftUI

struct GoalPicker : View {
            
    @FetchRequest(entity: Goal.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Goal.goal, ascending: true)],
                  predicate: NSPredicate(format: "done == 0")
    )
    private var goals: FetchedResults<Goal>
    @State private var selectedGoal : Goal?
    
    
    var body: some View {
        if goals.count < 1 {
            Text("No more goals left to complete!")
        } else {
            Form {
                    Picker(selection: $selectedGoal, label: Text("Goal")) {
                        ForEach(goals) { goal in
                            Text(goal.wrappedGoal).tag(goal as Goal?)
                        }
                    }
            }.navigationTitle("Goals")
        }
    }
}

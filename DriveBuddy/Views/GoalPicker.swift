//
//  GoalPicker.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 5/1/21.
//
import Foundation
import SwiftUI

struct GoalPicker: View {
    
    @FetchRequest(entity: Goal.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Goal.goal, ascending: true)],
                  predicate: NSPredicate(format: "done == 0")
    )
    private var goals: FetchedResults<Goal>
    @Binding var selection : Set<Goal>
    
    var body: some View {
        if goals.count < 1 {
            Text("No more goals left to complete!")
            NavigationLink(destination: Goals()){
                Text("Add a goal")
            }
        } else {
            Form {
                ForEach(goals, id:\.self){ goal in
                    Toggle(isOn: Binding(
                        get: {
                            selection.contains(goal)
                        },
                        set: { on in
                            if on {
                                selection.insert(goal)
                            } else {
                                selection.remove(goal)
                            }
                        }
                    )) {
                        Text(goal.wrappedGoal)
                    }
                }
            }.navigationTitle("Goals")
        }
    }
}

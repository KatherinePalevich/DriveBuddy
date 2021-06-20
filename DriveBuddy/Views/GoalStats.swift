//
//  GoalStats.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 6/19/21.
//

import SwiftUI

struct GoalStats: View {
    
    @FetchRequest(
        entity: Goal.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Goal.goal, ascending: true)]
    ) var goals: FetchedResults<Goal>
    
    
    var body: some View {
        ForEach(goals) { goal in
            Text("\(goal.wrappedGoal): \(goal.wrappedDrives.count)")
        }
    }
}

struct GoalStats_Previews: PreviewProvider {
    static var previews: some View {
        GoalStats()
    }
}

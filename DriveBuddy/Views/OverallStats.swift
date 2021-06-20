//
//  OverallStats.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/9/21.
//

import SwiftUI
import CoreData

struct OverallStats: View {
    
    @FetchRequest(
        entity: Drive.entity(),
        sortDescriptors: []
    ) var drives: FetchedResults<Drive>
    
    var totalDriveTime : TimeInterval {
        drives.reduce(0.0) {
            $0 + TimeInterval($1.driveLength)
        }
    }
    
    var totalDriveTimeHours : Double {
        totalDriveTime/3600
    }
    
    var body: some View {
        Form{
            let formatted = String(format: "%.2f", totalDriveTimeHours)
            Text("Total Hours: \(formatted)")
            Text("Total Drives: \(drives.count)")
            Section(header: Text("Goals")){
                GoalStats()
            }
        }.navigationTitle("Overall Stats")
    }
}

struct OverallStats_Previews: PreviewProvider {
    static var previews: some View {
        OverallStats()
    }
}

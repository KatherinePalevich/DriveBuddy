//
//  DriveForm.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 4/3/21.
//

import CoreData
import SwiftUI

struct DriveForm: View {
    /// Manages the drive form
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var drive: Drive
    private let pasteboard = UIPasteboard.general
    
    var body: some View {
        Text("Drive on \(date(drive.wrappedDate))").padding(.horizontal)
        Text("Drive Length: \(duration(TimeInterval(drive.driveLength)))").padding(.horizontal)
        Text("Goals Practiced: \(drive.wrappedGoals)").padding(.horizontal)
        MapView(lineCoordinates: .constant(DrivingRoute(pointsString: drive.route ?? "").points), done: true)
    }
    
    private func date(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return formatter.string(from: date)
    }
    
    private func duration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full

        return formatter.string(from: duration)!
    }
}



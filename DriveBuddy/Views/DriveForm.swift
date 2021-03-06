//
//  DriveForm.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 4/3/21.
//

import CoreData
import SwiftUI
import MapKit

extension CLLocationCoordinate2D : CustomStringConvertible {
    public var description: String {
        "lat: \(latitude), long: \(longitude)"
    }
}

struct DriveForm: View {
    /// Manages the drive form
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var drive: Drive
    private let pasteboard = UIPasteboard.general
    
    var body: some View {
        ScrollView{
            HStack() {
                VStack(alignment: .leading, spacing: 5){
                    Text("Drive on \(date(drive.wrappedDate))")
                    Text("Drive Length: \(duration(TimeInterval(drive.driveLength)))")
                    Text("Goals Practiced").font(.headline)
                    Text("\(drive.wrappedGoals)")
                }
                Spacer()
            }.padding()
        }.frame( height: 200)
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



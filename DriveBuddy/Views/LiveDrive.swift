//
//  LiveDrive.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 5/1/21.
//

import SwiftUI
import MapKit

struct LiveDrive: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var drive: Drive
    private let pasteboard = UIPasteboard.general
    @Binding var activeSheet: ActiveSheet?
    @State var startDate = Date()
    @ObservedObject var locationManager : LocationManager
    
    init(drive: Drive, activeSheet : Binding<ActiveSheet?>) {
        self.drive = drive
        self._activeSheet = activeSheet
        self.locationManager = LocationManager(drivingRoute: DrivingRoute())
    }
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.longitude ?? 0)"
    }
    
    
    var body: some View {
        NavigationView {
                VStack {
                    //Text("location status: \(locationManager.statusString)")
//                    HStack {
//                        Text("latitude: \(userLatitude)")
//                        Text("longitude: \(userLongitude)")
//                    }
                    Text(startDate, style: .timer).font(.title)
                    MapView(lineCoordinates: $locationManager.drivingRoute.points, done: false)
                }
                .navigationBarTitle(Text("Live Drive"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.activeSheet = nil
                    drive.driveLength = Int32(-startDate.timeIntervalSinceNow)
                    drive.route = locationManager.drivingRoute.asString
                    do {
                        try viewContext.save()
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                })  {
                    Text("Done").bold()
                })
        }
    }
}

func elapsedTimeFormatter(time: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .full // or .short or .abbreviated
    formatter.allowedUnits = [.second, .minute, .hour]
    
    return formatter.string(from: time)!
}

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
    @Binding var showLiveDrive: Bool
    @State var startDate = Date()
    @ObservedObject var locationManager : LocationManager
    
    init(drive: Drive, showLiveDrive : Binding<Bool>) {
        self.drive = drive
        self._showLiveDrive = showLiveDrive
        self.locationManager = LocationManager(drivingRoute: drive.route!)
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
                    Text("location status: \(locationManager.statusString)")
                    HStack {
                        Text("latitude: \(userLatitude)")
                        Text("longitude: \(userLongitude)")
                    }
                    Text(startDate, style: .timer)
                    let locations = drive.route?.points ?? []
                    let region = MKCoordinateRegion(
                        // Apple Park
                        center: locations.last ?? CLLocationCoordinate2D(latitude: 37.334803, longitude: -122.008965),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                      )
                    MapView(lineCoordinates: $drive.wrappedRoute.points)
                }
                .navigationBarTitle(Text("Live Drive"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showLiveDrive = false
                    drive.driveLength = Int32(-startDate.timeIntervalSinceNow)
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

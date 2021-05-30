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
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 47.606, longitude: -122.332), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
    
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
            ScrollView{
                VStack {
                    Text("location status: \(locationManager.statusString)")
                    HStack {
                        Text("latitude: \(userLatitude)")
                        Text("longitude: \(userLongitude)")
                    }
                    Text(startDate, style: .timer)
                    let locations = drive.route?.points ?? []
                    let polyline = MKPolyline(coordinates: locations, count: locations.count)
                    Map(coordinateRegion: $region,
                        showsUserLocation: true, userTrackingMode: .constant(.follow))
                        .addOverlay(polyline)
                        .frame(width: 400, height: 300)
                }.navigationBarTitle(Text("Live Drive"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showLiveDrive = false
                    drive.driveLength = Int32(-startDate.timeIntervalSinceNow)
                })  {
                    Text("Done").bold()
                })
            }
        }
    }
}

func elapsedTimeFormatter(time: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .full // or .short or .abbreviated
    formatter.allowedUnits = [.second, .minute, .hour]
    
    return formatter.string(from: time)!
}

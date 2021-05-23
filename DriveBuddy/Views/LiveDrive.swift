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
    @ObservedObject var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 47.606, longitude: -122.332), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
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
                    Map(coordinateRegion: $region,
                        showsUserLocation: true, userTrackingMode: .constant(.follow))
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
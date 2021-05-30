//
//  LocationManager.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 5/8/21.
//

//code borrowed from https://stackoverflow.com/questions/57681885/how-to-get-current-location-using-swiftui-without-viewcontrollers
import Foundation
import CoreLocation
import Combine
import MapKit
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    var drivingRoute : DrivingRoute
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?

    init(drivingRoute: DrivingRoute) {
        self.drivingRoute = drivingRoute
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

   
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    var lastLocation : CLLocationCoordinate2D? {
        drivingRoute.points.last
    }
    
    // MARK: locationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        for location in locations {
            drivingRoute.points.append(location.coordinate)
        }
    }
}

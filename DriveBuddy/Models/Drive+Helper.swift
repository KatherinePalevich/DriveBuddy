//
//  Drive+Helper.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 4/3/21.
//

import Foundation
import UIKit
import CoreLocation

extension Drive {
    //Date of the drive when it was created
    var wrappedDate: Date {
        get {
            date ?? Date(timeIntervalSince1970: 0)
        }
        set(newValue) {
            objectWillChange.send()
            date = newValue
        }
    }
    
    var wrappedGoals : String {
        get {
            let g = goals as? Set<Goal> ?? []
            let g2 = g.sorted {
                $0.wrappedGoal < $1.wrappedGoal
            }
            return g2.map(\.wrappedGoal).joined(separator: ",")
        }
    }
    
    var wrappedRoute : DrivingRoute {
        get {
            route!
        }
        set {
            route = newValue
        }
    }
    
    func append(point: CLLocationCoordinate2D){
        willChangeValue(forKey: "route")
        route!.points.append(point)
        didChangeValue(forKey: "route")
    }
}

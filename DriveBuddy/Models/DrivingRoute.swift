//
//  DrivingRoute.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 5/22/21.
//

import MapKit
import Foundation
public class DrivingRoute : NSObject, NSSecureCoding{
    public static var supportsSecureCoding = true
    var points : [CLLocationCoordinate2D]
    
    public required convenience init?(coder decoder: NSCoder) {
        let points = decoder.decodeObject(forKey: "points") as? [CLLocationCoordinate2D] ?? []
        self.init(points: points)
    }
    
    init(points: [CLLocationCoordinate2D]) {
        self.points = points
    }
    
    override init(){
        self.points = []
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.points, forKey: "points")
    }
    
}

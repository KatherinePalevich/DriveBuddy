//
//  DrivingRoute.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 5/22/21.
//

import MapKit
import Foundation

extension CLLocationCoordinate2D {
    init(string: String) {
        let coords = string.components(separatedBy: ",").map{
            Double($0)!
        }
        self.init(latitude: coords[0], longitude: coords[1])
    }
}


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
    
    convenience init(pointsString: String) {
        self.init(points:pointsString.components(separatedBy: "|").map { CLLocationCoordinate2D(string:$0) })
    }
    
    override init(){
        self.points = []
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.points, forKey: "points")
    }
    
    public func append(point: CLLocationCoordinate2D){
        points.append(point)
    }
    
    var asString : String {
        points.map{
            "\($0.latitude),\($0.longitude)"
        }.joined(separator: "|")
    }
    
}

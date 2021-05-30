//
//  DrivingRouteTransformer.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 5/29/21.
//

import Foundation

class DrivingRouteTransformer : NSSecureUnarchiveFromDataTransformer {
    
    override static var allowedTopLevelClasses: [AnyClass] {
        [DrivingRoute.self]
    }
    
    static func register() {
        let className = String(describing: DrivingRouteTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = DrivingRouteTransformer()
        
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
    
}

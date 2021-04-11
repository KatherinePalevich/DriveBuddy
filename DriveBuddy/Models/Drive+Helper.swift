//
//  Drive+Helper.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 4/3/21.
//

import Foundation
import UIKit

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
    var wrappedDrive: Double {
        
        get {
            driveLength
            
        }
        set(newValue) {
            objectWillChange.send()
            driveLength = newValue
        }
    }
}

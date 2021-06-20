//
//  Goal+Helper.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/13/21.
//

import Foundation
import UIKit

extension Goal {
    
    var wrappedGoal: String {
      get {
        goal ?? ""
      }
      set(newValue) {
        objectWillChange.send()
        goal = newValue
      }
    }
    
    var wrappedDetails: String {
      get {
        details ?? ""
      }
      set(newValue) {
        objectWillChange.send()
        details = newValue
      }
    }
    
    var completed: Bool {
      get {
        done
      }
      set(newValue) {
        objectWillChange.send()
        done = newValue
      }
    }
    
    var wrappedDrives: Set<Drive> {
        get {
            if let drives = drives {
                return Set(_immutableCocoaSet: drives)
            } else {
                return Set()
            }
        }
    }
}

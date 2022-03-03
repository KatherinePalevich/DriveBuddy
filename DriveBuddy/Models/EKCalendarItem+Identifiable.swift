//
//  EKCalendarItem+Identifiable.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/3/22.
//

import Foundation
import EventKit

extension EKCalendarItem : Identifiable {
    @objc public var id : String{
        calendarItemIdentifier
    }
}

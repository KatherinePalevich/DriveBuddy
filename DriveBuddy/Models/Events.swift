//
//  Events.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/1/22.
//

import Foundation
import EventKit
import Combine
import SwiftUI

class Events: ObservableObject {
    @Published public var dayEvents : [EKEvent] = []
    @Published public var weekEvents : [EKEvent] = []
    private var cancellables = Set<AnyCancellable>()
    public static let driveBuddyEventString = "Created in the DriveBuddy application"
    
    public static let eventStore = EKEventStore()
    @Published public var date : Date {
        didSet {
            populateDayEvents(date: date)
            populateWeekEvents(date: date)
        }
    }

    public init(date: Date) {
        self.date = date
        Events.eventStore.requestAccess(to: EKEntityType.event){ (granted, error) in
            if !granted {
                fatalError("Cannot access events")
            }
        }
        NotificationCenter.default.publisher(for: .EKEventStoreChanged)
            .sink{ _ in
                DispatchQueue.main.async {
                    self.populateDayEvents(date: self.date)
                    self.populateWeekEvents(date: self.date)
                }
            }.store(in: &cancellables)
    }
    
    public func populateDayEvents(date: Date){
        // Get the appropriate calendar.
        let calendar = Calendar.current
        
        let beginningOfDay = calendar.startOfDay(for: date)
        var dateComponents = DateComponents()
        dateComponents.minute = 0
        dateComponents.second = 0
        dateComponents.hour = 0

        let endOfDay = calendar.nextDate(after: date, matching: dateComponents, matchingPolicy: .nextTime)!
        
        let predicate = Events.eventStore.predicateForEvents(withStart: beginningOfDay, end: endOfDay, calendars: Events.eventStore.calendars(for: EKEntityType.event))
        
        dayEvents = Events.eventStore.events(matching: predicate).filter {
            $0.notes?.contains(Events.driveBuddyEventString) ?? false
            //$0.title?.contains(Events.driveBuddyEventString) ?? false
        }
        
    }
    
    public func populateWeekEvents(date: Date){
        // Get the appropriate calendar.
        let calendar = Calendar.current
        
        let beginningOfWeek = (calendar.nextWeekend(startingAfter: date, direction: .backward)?.end)?.addingTimeInterval(-60 * 60 * 24)
        var endOfWeek = (calendar.nextWeekend(startingAfter: date, direction: .forward)?.end)!.addingTimeInterval(-60 * 60 * 24)
        if(calendar.isDateInWeekend(date) && calendar.isDateInWeekend(date.addingTimeInterval(60 * 60 * 24))){
            endOfWeek = date
        }
        
        
        let predicate = Events.eventStore.predicateForEvents(withStart: beginningOfWeek!, end: endOfWeek, calendars: Events.eventStore.calendars(for: EKEntityType.event))
        weekEvents = Events.eventStore.events(matching: predicate).filter {
            $0.notes?.contains(Events.driveBuddyEventString) ?? false
            //$0.title?.contains(Events.driveBuddyEventString) ?? false
        }
        
    }
    
}

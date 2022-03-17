//
//  DriveSchedule.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/1/22.
//

import SwiftUI
import EventKit
import EventKitUI

struct DriveSchedule: View {
    var body: some View {
        PlannerView()
    }
}

struct PlannerView: View {
    @ObservedObject var calendar = Events(date: Date())
    @State private var selectedEvent : EKEvent?
    @State private var newEventIsPresented = false
    
    var body: some View {
        DatePicker(
            "Start Date",
            selection: $calendar.date,
            displayedComponents: [.date]
        )
            .frame(maxWidth: .infinity)
            .datePickerStyle(.graphical)
        TabView {
            DayView(calendarEvents: calendar.dayEvents)
                .tabItem {
                    Label("Day", systemImage: "circle")
                }
            
            WeekView(calendarEvents: calendar.weekEvents)
                .tabItem {
                    Label("Week", systemImage: "circle.hexagongrid")
                }
        }.onAppear(){
            calendar.populateDayEvents(date: Date())
            calendar.populateWeekEvents(date: Date())
        }
        .navigationBarItems(
            trailing: HStack {
                newEventButton
            }
        )
    }
    
    /// The button that presents the entry creation sheet.
    private var newEventButton: some View {
        Button(
            action: {
                self.newEventIsPresented = true
            },
            label: {
                Label("Add Event ", systemImage: "plus.circle").imageScale(.large)
                    .padding(2.5)
            })
            .sheet(
                isPresented: $newEventIsPresented,
                content: { self.newEventCreationSheet })
    }
    
    /// The event creation sheet.
    private var newEventCreationSheet: some View {
        let event = EKEvent(eventStore: Events.eventStore)
        return EventViewer(event: event).accentColor(Color.purple)
    }
}


/// The view that edits a event in the list.
private func editorView(for event: EKEvent) -> some View {
    EventEditor(event: event)
        .navigationBarTitle("Event")
}

struct EventRow: View {
    var event: EKEvent
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(event.title)
            Text("\(event.startDate)")
        }
    }
}

struct DayView : View {
    var calendarEvents : [EKEvent]
    @State private var selectedEvent : EKEvent?
    
    var body: some View {
        List {
            ForEach(calendarEvents, id: \.self) { event in
                EventRow(event: event).onTapGesture {
                    selectedEvent = event
                }
            }
        }.sheet(item: $selectedEvent) { item in
            EventViewer(event: item)
        }
    }
    
}
struct WeekView : View {
    var calendarEvents : [EKEvent]
    @State private var selectedEvent : EKEvent?
    
    var body: some View {
        List {
            ForEach(calendarEvents, id: \.self) { event in
                
                EventRow(event: event).onTapGesture {
                    selectedEvent = event
                }
            }
        }.sheet(item: $selectedEvent) { item in
            EventViewer(event: item)
            
        }
    }
}

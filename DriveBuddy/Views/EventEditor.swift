//
//  EventEditor.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/1/22.
//

import SwiftUI
import EventKit
import EventKitUI

struct EventEditor: View {
    var event: EKEvent
    
    @State private var showIt = false
        var body: some View {
            Button("Events") { showIt = true }
                .sheet(isPresented: $showIt) {
                    EventViewer(event: event)
                }
        }
}

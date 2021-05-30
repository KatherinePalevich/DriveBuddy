//
//  DriveBuddyApp.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/9/21.
//

import SwiftUI

@main
struct DriveBuddyApp: App {
    let persistenceController = PersistenceController.shared
    init(){
        DrivingRouteTransformer.register()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

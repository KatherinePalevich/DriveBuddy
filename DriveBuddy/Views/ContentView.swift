//
//  ContentView.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/9/21.
//

import Foundation
import SwiftUI
import CoreData

struct ContentView: View {
    let persistenceController = PersistenceController.shared
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        TabView{
            goals.tabItem{
                Image(systemName: "target")
                Text("Goals")
            }
            recordRoute.tabItem{
                Image(systemName: "car")
                Text("Record Route")
            }
            overallStats.tabItem{
                Image(systemName: "chart.bar.fill")
                Text("Overall Stats")
            }
        }.environment(\.managedObjectContext, persistenceController.container.viewContext)
        .accentColor(Color.purple)
    }
    }

var goals: some View {
    NavigationView {
        Goals()
    }
}

var recordRoute: some View {
    NavigationView {
        RecordRoute()
        WelcomeView()
    }
}

var overallStats: some View {
    NavigationView {
        OverallStats()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

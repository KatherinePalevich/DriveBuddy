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
    @State private var selection = 1

    var body: some View {
        TabView(selection: $selection){
            goals.tabItem{
                Image(systemName: "target")
                Text("Goals")
            }
            .tag(0)
            routes.tabItem{
                Image(systemName: "car")
                Text("Routes")
            }
            .tag(1)
            overallStats.tabItem{
                Image(systemName: "chart.bar.fill")
                Text("Overall Stats")
            }
            .tag(2)
        }.environment(\.managedObjectContext, persistenceController.container.viewContext)
        .accentColor(Color.purple)
    }
    }

var goals: some View {
    NavigationView {
        Goals()
    }
}

var routes: some View {
    NavigationView {
        Routes()
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

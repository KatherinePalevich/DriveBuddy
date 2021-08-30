//
//  StatsWelcomeView.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 8/29/21.
//

import SwiftUI

struct StatsWelcomeView: View {
    var body: some View {
        VStack{
            Text("Welcome to Drive Buddy").font(.largeTitle)
            Text("Swipe from the left or click Overall Stats to see Drive Buddy statistics").foregroundColor(.secondary)
        }
    }
}

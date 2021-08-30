//
//  GoalWelcomeView.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 8/29/21.
//

import SwiftUI

struct GoalWelcomeView: View {
    var body: some View {
        VStack{
            Text("Welcome to Drive Buddy").font(.largeTitle)
            Text("Please create a goal from the left-hand menu; swipe from the left and click the plus button").foregroundColor(.secondary)
        }
    }
}

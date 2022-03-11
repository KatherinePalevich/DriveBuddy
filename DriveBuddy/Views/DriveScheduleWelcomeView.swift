//
//  DriveScheduleWelcomeView.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/4/22.
//

import SwiftUI

struct DriveScheduleWelcomeView: View {
    var body: some View {
        VStack{
            Text("Welcome to Drive Buddy").font(.largeTitle)
            Text("Swipe from the left or click Back to see Drive Buddy schedule").foregroundColor(.secondary)
        }
    }
}

struct DriveScheduleWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        DriveScheduleWelcomeView()
    }
}

//
//  WelcomeView.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/9/21.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack{
            Text("Welcome to Drive Buddy").font(.largeTitle)
            Text("Please start a drive from the left-hand menu; swipe from the left and click the plus button").foregroundColor(.secondary)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

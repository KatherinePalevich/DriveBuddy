//
//  DriveForm.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 4/3/21.
//

import CoreData
import SwiftUI

struct DriveForm: View {
    /// Manages the item form
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var drive: Drive
    private let pasteboard = UIPasteboard.general
    @ObservedObject var stopWatch = StopWatch()
    
    var body: some View {
        VStack {
            Text("Drive \(drive.wrappedDate )")
            Text(self.stopWatch.stopWatchTime)
                .font(.custom("courier", size: 60))
                .frame(width: UIScreen.main.bounds.size.width,
                       height: 300,
                       alignment: .center)
            HStack{
                StopWatchButton(actions: [self.stopWatch.reset, self.stopWatch.lap],
                                labels: ["Reset", "Lap"],
                                color: Color.red,
                                isPaused: self.stopWatch.isPaused())
                
                StopWatchButton(actions: [self.stopWatch.start, self.stopWatch.pause],
                                labels: ["Start", "Pause"],
                                color: Color.blue,
                                isPaused: self.stopWatch.isPaused())
            }
        }
    }
}

// Code borrowed from https://programmingwithswift.com/build-a-stopwatch-app-with-swiftui/
struct StopWatchButton : View {
    var actions: [() -> Void]
    var labels: [String]
    var color: Color
    var isPaused: Bool
    
    var body: some View {
        let buttonWidth = (UIScreen.main.bounds.size.width / 2) - 12
        
        return Button(action: {
            if self.isPaused {
                self.actions[0]()
            } else {
                self.actions[1]()
            }
        }) {
            if isPaused {
                Text(self.labels[0])
                    .foregroundColor(Color.white)
                    .frame(width: buttonWidth,
                           height: 50)
            } else {
                Text(self.labels[1])
                    .foregroundColor(Color.white)
                    .frame(width: buttonWidth,
                           height: 50)
            }
        }
        .background(self.color)
        .cornerRadius(5)
    }
}

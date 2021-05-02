//
//  PreDrive.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 5/1/21.
//

import SwiftUI

struct PreDrive: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var drive: Drive
    private let pasteboard = UIPasteboard.general
    @ObservedObject var stopWatch = StopWatch()

    var body: some View {
        GoalPicker()
    }
}

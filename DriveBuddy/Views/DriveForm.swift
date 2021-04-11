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

    var body: some View {
        Form {
            Text("Drive \(drive.wrappedDate ?? Date.distantFuture)")
        }
    }
}

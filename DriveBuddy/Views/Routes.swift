//
//  Routes.swift
//  DriveBuddy
//
//  Created by Katherine Palevich on 3/13/21.
//

import SwiftUI

struct Routes: View {
    var body: some View {
        Text("Hello World")
        NavigationLink(destination: RecordRoute()) {
            Text("New Route")
        }
    }
}

struct Routes_Previews: PreviewProvider {
    static var previews: some View {
        Routes()
    }
}

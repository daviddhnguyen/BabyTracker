//
//  babyTrackerApp.swift
//  babyTracker
//
//  Created by David Nguyen on 5/25/25.
//

import SwiftUI

@main
struct babyTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

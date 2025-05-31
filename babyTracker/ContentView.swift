//
//  ContentView.swift
//  babyTracker
//
//  Created by David Nguyen on 5/25/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showEntry = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.teal
                    .ignoresSafeArea()
                VStack {
                    NavigationLink(destination: LogView(logType: "Sleep")) {
                        Text("Sleeping")
                    }
                    NavigationLink(destination: LogView(logType: "Feed")) {
                        Text("Feeding")
                    }
                    NavigationLink(destination: LogView(logType: "Diaper")) {
                        Text("Diapers")
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: {showEntry.toggle()}) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                .foregroundStyle(Color.black)
                .navigationTitle("Home")
            }
            
            Text("Select an item")
        }
        .sheet(isPresented: $showEntry, onDismiss: {showEntry = false}) {
            AddLogEntryView(isEntry: $showEntry)
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

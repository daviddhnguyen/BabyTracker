//
//  AddLogEntryView.swift
//  babyTracker
//
//  Created by David Nguyen on 5/29/25.
//

import SwiftUI
import CoreData

struct AddLogEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isEntry: Bool
    
    @State var type: String = "init"
    @State var timestamp: Date = Date()
    @State var notes: String = ""
    @State var diaperType: String = ""
    @State var amount: Double = 0
    @State var bottleType: String = ""
    @State var duration: Double = 0
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                Color.teal
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HStack{
                        Button("Sleep") {
                            type = "Sleep"
                        }
                        Button("Feed") {
                            type = "Feed"
                        }
                        Button("Diaper") {
                            type = "Diaper"
                        }
                    }
                    .padding()
                    
                    let value = type
                        
                    Text(value)
                        .padding()
                    
                    switch type {
                    case "Sleep":
                        Text("Sleep")
                        
                    case "Feed":
                        Text("Bottle Type")
                        TextField("Bottle Type", text: $bottleType)
                        
                        Text("Amount")
                        TextField("Amount", value: $amount, format: .number)
                        
                    case "Diaper":
                        Text("Diaper Type")
                        TextField("Diaper Type", text: $diaperType)
                        
                    default:
                        Text("default")
                    }
                
                    HStack {
                        Button("Submit") {
                            let newItem = LogEntry(context: viewContext)
                            newItem.type = type
                            newItem.bottleType = bottleType
                            newItem.diaperType = diaperType
                            newItem.duration = duration
                            newItem.amount = amount
                            newItem.notes = notes
                            newItem.timestamp = Date()
                            
                            do {
                                try viewContext.save()
                                isEntry = false
                            } catch {
                                // Replace this implementation with code to handle the error appropriately.
                                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }
                        
                        Button("Cancel") {
                            isEntry = false
                        }
                    }
                }
                .padding()
                .font(.title)
                .navigationTitle("New Entry")
            }
        }
    }
}

#Preview {
    AddLogEntryView(isEntry: .constant(true)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

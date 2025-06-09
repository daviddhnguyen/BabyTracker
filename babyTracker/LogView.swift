//
//  LogView.swift
//  babyTracker
//
//  Created by David Nguyen on 5/30/25.
//

import SwiftUI
import CoreData

struct LogView: View {
    var logType: String
    
    //@ObservedObject var entry: LogEntry
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \LogEntry.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<LogEntry>
    
    @State private var startSleepTime: Date = Date()
    @State private var endSleepTime: Date = Date()
    
    var duration: Double {
        endSleepTime.timeIntervalSince(startSleepTime) / 60.0
    }
    
    var body: some View {
        NavigationStack {
                List {
                    ForEach(items.filter {$0.type == logType}) { item in
                        NavigationLink {
                            EntryDetailView(item: item, logType: logType)
                        } label: {
                            entryLabel(for: item)
                        }
                    }
                    .onDelete(perform: deleteItems)
            }
                //.listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle("\(logType) Log")
        }
    }
    
    @ViewBuilder
    func entryLabel(for item: LogEntry) -> some View {
        switch logType {
        case "Sleep":
            Text("Duration: \(item.duration, specifier: "%.1f") minutes")
                .accessibilityIdentifier("durationLabel")
            
        case "Feed":
            VStack(alignment: .leading) {
                Text("Bottle: \(item.bottleType ?? "")")
                    .accessibilityIdentifier("bottleTypeLabel")
                Text("Amount: \(item.amount, specifier: "%.1f") fl oz")
                    .accessibilityIdentifier("amountLabel")
            }
            
        case "Diaper":
            Text("Diaper Type: \(item.diaperType ?? "")")
                .accessibilityIdentifier("diaperTypeLabel")
            
        default:
            Text("Unknown Entry")
                .accessibilityIdentifier("unknownLabel")
            
        }
        Text(item.timestamp!, formatter: itemFormatter)
    }
    /*
    @ViewBuilder
    func entryDetail(for item: LogEntry) -> some View {
        VStack {
            switch logType {
            case "Sleep":
                VStack {
                    Form {
                        DatePicker("Start Time", selection: $startSleepTime, displayedComponents: [.date, .hourAndMinute])
                            .onChange(of: startSleepTime) { oldStart, newStart in
                                if endSleepTime < newStart {
                                    endSleepTime = newStart
                                }
                            }
                        
                        DatePicker("End Time", selection: $endSleepTime, in: startSleepTime..., displayedComponents: [.date, .hourAndMinute])
                        
                        Text(String(format: "Duration: %.1f minutes", duration))
                            .accessibilityLabel("durationLabel")
                    }
                    .onAppear {
                        startSleepTime = item.startSleepTime ?? Date()
                        endSleepTime = item.endSleepTime ?? Date()
                    }
                }
                
            case "Feed":
                VStack(alignment: .leading) {
                    Text("Bottle: \(item.bottleType ?? "")")
                        .accessibilityIdentifier("bottleTypeLabel")
                    Text("Amount: \(item.amount, specifier: "%.1f") fl oz")
                        .accessibilityIdentifier("amountLabel")
                }
                
            case "Diaper":
                Text("Diaper Type: \(item.diaperType ?? "")")
                    .accessibilityIdentifier("diaperTypeLabel")
                
            default:
                Text("Unknown Entry")
                    .accessibilityIdentifier("unknownLabel")
                
            }
            HStack {
                Button("Submit") {
                    item.startSleepTime = startSleepTime
                    item.endSleepTime = endSleepTime
                    item.duration = duration
                    try? viewContext.save()
                    dismiss()
                }
                Button("Cancel") {
                    dismiss()
                }
            }
            .padding()
        }
        Text(item.timestamp!, formatter: itemFormatter)
    }
    */
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
    
    
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    LogView(logType: "Feed").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

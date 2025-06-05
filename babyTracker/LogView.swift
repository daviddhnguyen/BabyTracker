//
//  LogView.swift
//  babyTracker
//
//  Created by David Nguyen on 5/30/25.
//

import SwiftUI

struct LogView: View {
    var logType: String
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \LogEntry.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<LogEntry>
    
    var body: some View {
        NavigationStack {
                List {
                    ForEach(items.filter {$0.type == logType}) { item in
                        NavigationLink {
                            entryDetail(for: item)
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
            //.accessibilityIdentifier("dateLabel")
    }
    
    @ViewBuilder
    func entryDetail(for item: LogEntry) -> some View {
        VStack(alignment: .leading) {
            entryLabel(for: item)
        }
        .padding()
    }
    
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
    LogView(logType: "Sleep").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

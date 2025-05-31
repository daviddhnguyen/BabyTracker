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
        sortDescriptors: [NSSortDescriptor(keyPath: \LogEntry.type, ascending: true)],
        animation: .default)
    private var items: FetchedResults<LogEntry>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items.filter {$0.type == logType}) { item in
                    NavigationLink {
                        Text("Item is \(item.type!)")
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.type!)
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle("\(logType) Log")
        }
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
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    LogView(logType: "test").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

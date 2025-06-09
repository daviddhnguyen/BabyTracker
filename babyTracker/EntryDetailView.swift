import SwiftUI
import CoreData

struct EntryDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var item: LogEntry
    var logType: String
    
    @State private var startSleepTime: Date = Date()
    @State private var endSleepTime: Date = Date()
    
    var duration: Double {
        endSleepTime.timeIntervalSince(startSleepTime) / 60.0
    }
    
    var body: some View {
        ZStack {
            switch logType {
            case "Sleep":
                Form {
                    DatePicker("Start Time", selection: $startSleepTime, displayedComponents: [.date, .hourAndMinute])
                        .onChange(of: startSleepTime) { oldStart, newStart in
                            if endSleepTime < newStart {
                                endSleepTime = newStart
                            }
                        }
                    
                    DatePicker("End Time", selection: $endSleepTime, in: startSleepTime..., displayedComponents: [.date, .hourAndMinute])
                    
                    Text(String(format: "Duration: %.1f minutes", duration))
                        .accessibilityIdentifier("durationLabel")
                }
                .onAppear {
                    startSleepTime = item.startSleepTime ?? Date()
                    endSleepTime = item.endSleepTime ?? Date()
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
                    // Save changes to Core Data
                    if logType == "Sleep" {
                        item.startSleepTime = startSleepTime
                        item.endSleepTime = endSleepTime
                        item.duration = duration
                    }
                    do {
                        try viewContext.save()
                    } catch {
                        print("Failed to save: \(error.localizedDescription)")
                    }
                    dismiss()
                }
                
                Button("Cancel") {
                    dismiss()
                }
            }
            .padding()
        }
        .navigationTitle("\(logType) Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

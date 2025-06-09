//
//  Persistence.swift
//  babyTracker
//
//  Created by David Nguyen on 5/25/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let types = ["Sleep", "Feed", "Diaper", "test"]
        let diaperOptions = ["Wet", "Dirty", "Mixed"]
        let bottleOptions = ["Breast Milk", "Formula"]
        
        for type in types {
            for _ in 0..<10 {
                let newItem = LogEntry(context: viewContext)
                
                //Random date in last 30 days
                let randomDaysAgo = Int.random(in: 0..<30)
                let randomDate = Date().addingTimeInterval(-Double(randomDaysAgo) * 86400)
                newItem.timestamp = randomDate
                
                if let randomDiaper = diaperOptions.randomElement() {
                    newItem.diaperType = randomDiaper
                }
                
                if let randomBottle = bottleOptions.randomElement() {
                    newItem.bottleType = randomBottle
                }
                
                newItem.type = type
                newItem.startSleepTime = randomDate
                let end = randomDate.addingTimeInterval(Double.random(in: 1...6000))
                newItem.endSleepTime = end
                newItem.duration = end.timeIntervalSince(randomDate) / 60.0
                newItem.amount = Double.random(in: 1...10)

            }
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "babyTracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                print("❌ Failed to load store: \(error), \(error.userInfo)")
                } else {
                    print("✅ Store loaded: \(storeDescription)")
                }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

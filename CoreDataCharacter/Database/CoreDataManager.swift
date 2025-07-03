import CoreData

final class CoreDataManager: ObservableObject {
    let container: NSPersistentContainer = NSPersistentContainer(name: "CoreDataCharacter")
    
    init() {
        container.loadPersistentStores { descriptor, error in
            debugPrint(descriptor.url?.absoluteString ?? "")
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

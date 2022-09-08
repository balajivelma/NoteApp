//
//  NoteData.swift
//  POC
//
//  Created by balajireddy velma on 07/09/22.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  let container: NSPersistentContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "Note")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
  }
    // MARK: - 4. PREVIEW
    static var preview: PersistenceController = {
      let result = PersistenceController(inMemory: true)
      let viewContext = result.container.viewContext
      for i in 0..<8 {
        let newItem = NoteItem(context: viewContext)
        newItem.date = Date()
        newItem.text = "Sample task nº\(i)"
        newItem.id = UUID()
      }
      do {
        try viewContext.save()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
      return result
    }()
    
}

//
//  POCApp.swift
//  POC
//
//  Created by balajireddy velma on 06/09/22.
//

import SwiftUI

@main
struct POCApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

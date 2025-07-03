//
//  RPG_CoreDataApp.swift
//  RPG-CoreData
//
//  Created by Larissa Kailane on 02/07/25.
//

import SwiftUI

@main
struct RPG_CoreDataApp: App {
//    let persistenceController = PersistenceController

    var body: some Scene {
        WindowGroup {
            GuildView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  A2_iOS_Oleg_101466133App.swift
//  A2_iOS_Oleg_101466133
//
//  Created by user294604 on 4/9/26.
//

import SwiftUI
import CoreData

@main
struct A2_iOS_Oleg_101466133App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

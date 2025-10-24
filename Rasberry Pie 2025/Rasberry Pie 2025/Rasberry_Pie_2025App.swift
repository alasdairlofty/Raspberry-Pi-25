//
//  Rasberry_Pie_2025App.swift
//  Rasberry Pie 2025
//
//  Created by Oscar Mason on 20/10/2025.
//

import SwiftUI
import SwiftData

@main
struct Rasberry_Pie_2025App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            CreateAccountView()
        }
        .modelContainer(sharedModelContainer)
    }
}

import SwiftUI
import Firebase

@main
struct Rasberry_Pie_2025App: App {
    // Initialize Firebase when the app launches
    init() {
        // Ensure Firebase is configured once
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

    var body: some Scene {
        WindowGroup {
            
           HomePage()
        }
    }
}

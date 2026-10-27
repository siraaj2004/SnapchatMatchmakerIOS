import SwiftUI

@main
struct MatchmakerApp: App {
    @StateObject private var store = MatchmakerStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}

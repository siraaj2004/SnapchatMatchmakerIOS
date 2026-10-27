import SwiftUI

struct CannotDoView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("What this app cannot do") {
                    Text("1. Discover Snapchat friends, send friend requests, read chats, or send messages automatically — there's no permitted Snapchat integration for that, and I won't use an unofficial login to fake it.")
                    Text("2. Guess religion, age, or location from a name or photo — those stay \"unknown\" until she volunteers them.")
                    Text("3. Run daily on its own hunting for matches, or keep running on GitHub until you have a girlfriend.")
                }
                Section("What it does instead") {
                    Text("Manual contacts only, drafts only, disclosure plus AI-consent gate, Guntur filter on a volunteered answer only, and a Promising notification plus pause when the evidence thresholds are met.")
                }
            }
            .navigationTitle("Cannot do")
        }
    }
}

struct AboutView: View {
    @EnvironmentObject var store: MatchmakerStore
    @State private var showingDeleteConfirm = false
    var body: some View {
        NavigationStack {
            List {
                Section("About") {
                    Text("Matchmaker AI, version 1.0.0 build 1. Manual only. No Snapchat login, no Snapchat automation, no passwords stored in this app. All data stays on this phone.")
                }
                Section("Pause / resume") {
                    Toggle("Paused", isOn: $store.paused)
                    Text("When paused, no new drafts are prepared.").font(.footnote).foregroundColor(.secondary)
                }
                Section("Privacy") {
                    Button("Delete all data", role: .destructive) { showingDeleteConfirm = true }
                }
            }
            .navigationTitle("About")
            .alert("Delete all data?", isPresented: $showingDeleteConfirm) {
                Button("Delete all", role: .destructive) { store.deleteAll() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This deletes every candidate on this phone only. It cannot be undone.")
            }
        }
    }
}

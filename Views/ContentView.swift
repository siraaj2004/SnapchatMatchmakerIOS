import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: MatchmakerStore
    @State private var showingAdd = false
    @State private var showingDeleteConfirm = false
    var body: some View {
        TabView {
            NavigationStack {
                ContactListView(showingAdd: $showingAdd)
                    .navigationTitle("Matchmaker AI")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Add") { showingAdd = true }
                        }
                    }
                    .sheet(isPresented: $showingAdd) { AddContactView() }
            }
            .tabItem { Label("Contacts", systemImage: "person.2") }
            CannotDoView()
                .tabItem { Label("Cannot do", systemImage: "exclamationmark.octagon") }
            AboutView()
                .tabItem { Label("About", systemImage: "info.circle") }
        }
        .alert("Delete all data?", isPresented: $showingDeleteConfirm) {
            Button("Delete all", role: .destructive) { store.deleteAll() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This deletes every candidate on this phone only. It cannot be undone.")
        }
    }
}

struct ContactListView: View {
    @EnvironmentObject var store: MatchmakerStore
    @Binding var showingAdd: Bool
    var body: some View {
        List {
            if store.paused {
                Section {
                    Text("Paused. No new drafts are being prepared. Turn Pause off in About to resume.")
                        .foregroundColor(.orange)
                }
            }
            Section("Manual contacts only") {
                if store.candidates.isEmpty {
                    Text("No contacts yet. Tap Add, and only add someone you already know, who contacted you first, or who is already mutual / accepted — with adult status confirmed.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                ForEach(store.candidates) { candidate in
                    NavigationLink(destination: ContactDetailView(candidate: candidate)) {
                        ContactRowView(candidate: candidate)
                    }
                }
                .onDelete(perform: store.delete)
            }
            Section("What this app never does") {
                Text("It never logs into Snapchat, never discovers friends, never sends a request or a message by itself, and never guesses religion, age, or location.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ContactRowView: View {
    var candidate: Candidate
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(candidate.username.isEmpty ? "Unnamed" : candidate.username).font(.headline)
            Text(candidate.status).font(.subheadline).foregroundColor(.secondary)
            if candidate.isPromising {
                Text("❤️ PROMISING — take over personally").font(.subheadline).bold()
            }
        }
    }
}

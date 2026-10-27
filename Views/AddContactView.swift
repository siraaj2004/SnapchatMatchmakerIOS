import SwiftUI

struct AddContactView: View {
    @EnvironmentObject var store: MatchmakerStore
    @Environment(\.dismiss) private var dismiss
    @State private var username = ""
    @State private var basis: Basis = .contactedFirst
    @State private var adultConfirmed = false
    var body: some View {
        NavigationStack {
            Form {
                Section("Snapchat username (you type it yourself)") {
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                Section("How do you know this person?") {
                    Picker("Basis", selection: $basis) {
                        ForEach(Basis.allCases) { b in Text(b.label).tag(b) }
                    }
                }
                Section("Adult check — required") {
                    Toggle("Adult status voluntarily confirmed (18+)", isOn: $adultConfirmed)
                    Text("Do not add anyone unless adult status is confirmed. Age is never guessed from a name or photo.")
                        .font(.footnote).foregroundColor(.secondary)
                }
                Section {
                    Text("This app does not discover people, does not log into Snapchat, and does not send anything. You approve every draft, and you send it yourself in Snapchat.")
                        .font(.footnote).foregroundColor(.secondary)
                }
            }
            .navigationTitle("Add contact")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var c = Candidate()
                        c.username = username.trimmingCharacters(in: .whitespaces)
                        c.basis = basis
                        c.adultConfirmed = adultConfirmed
                        store.add(c)
                        dismiss()
                    }
                    .disabled(username.trimmingCharacters(in: .whitespaces).isEmpty || !adultConfirmed)
                }
            }
        }
    }
}

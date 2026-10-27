import SwiftUI

struct ContactDetailView: View {
    @EnvironmentObject var store: MatchmakerStore
    @State var candidate: Candidate
    @State private var copied = ""
    var body: some View {
        List {
            Section("Status") {
                Text(candidate.status).bold()
                Text("Basis: \(candidate.basis.label)")
                Text("Adult confirmed: \(candidate.adultConfirmed ? "Yes" : "No")")
            }
            DraftSection(title: "Opening draft — copy it, then you send it yourself in Snapchat", text: Candidate.openingDraft, copied: $copied)
            Section("AI-assisted chat — disclosure and consent") {
                Text("The opening draft says an AI introduction assistant is helping on Siraaj's behalf. Do not prepare a further draft until she explicitly agrees.")
                    .font(.footnote).foregroundColor(.secondary)
                Picker("Her answer", selection: $candidate.aiConsent) {
                    ForEach(AIConsent.allCases, id: \.self) { c in Text(c.label).tag(c) }
                }
                if candidate.aiConsent == .no {
                    Text("Closed. No further drafts for this person.").foregroundColor(.red)
                }
            }
            if candidate.aiConsent == .yes {
                DraftSection(title: "Guntur question", text: Candidate.gunturQuestion, copied: $copied)
                Section("Location — volunteered only") {
                    Picker("Location volunteered", selection: $candidate.locationVolunteered) {
                        Text("unknown").tag("unknown")
                        Text("Guntur").tag("Guntur")
                        Text("Outside Guntur").tag("Outside Guntur")
                    }
                    if candidate.locationVolunteered == "Outside Guntur" {
                        Text("Outside Guntur: romantic track ends politely. No exact home address is ever collected.").foregroundColor(.red)
                    }
                }
                Section("Volunteered details only — never guess") {
                    TextField("Age volunteered (or unknown)", text: $candidate.ageVolunteered)
                    TextField("Religion volunteered (or unknown)", text: $candidate.religionVolunteered)
                    Text("Leave as unknown unless she volunteers it herself.").font(.footnote).foregroundColor(.secondary)
                }
                Section("Compatibility — observed evidence only") {
                    Stepper("Incoming messages: \(candidate.incomingMessages)", value: $candidate.incomingMessages, in: 0...100)
                    Stepper("Positive signals: \(candidate.positiveSignals)", value: $candidate.positiveSignals, in: 0...100)
                    Toggle("Mutual effort observed", isOn: $candidate.mutualEffort)
                    Toggle("Mutual romantic interest expressed", isOn: $candidate.mutualRomanticInterest)
                    Toggle("Serious relationship intention expressed", isOn: $candidate.seriousIntention)
                }
                Section("Marriage expectations — as stated") {
                    DraftSection(title: "Question you may draft after genuine mutual interest", text: Candidate.marriageQuestion, copied: $copied)
                    TextField("Her stated expectations", text: $candidate.marriageExpectations, axis: .vertical)
                    Text("Elopement is never required. Do not pressure anyone to commit.").font(.footnote).foregroundColor(.secondary)
                }
                Section("Intimacy values — permission only") {
                    Picker("Topic", selection: $candidate.intimacyTopic) {
                        ForEach(IntimacyTopic.allCases, id: \.self) { t in Text(t.label).tag(t) }
                    }
                    Text("Only after trust, and only with her permission. Never demand, investigate, or try to verify sexual history. If she declines, the topic closes.").font(.footnote).foregroundColor(.secondary)
                }
                if candidate.isPromising {
                    Section("❤️ PROMISING GUNTUR MATCH FOUND") {
                        Text(candidate.promisingNotification)
                        Button("Copy notification") {
                            UIPasteboard.general.string = candidate.promisingNotification
                            copied = "Notification copied. Take over personally — the app does not send it."
                        }
                        Text("Pause here and take over personally.").bold()
                    }
                }
            }
            if !copied.isEmpty {
                Section { Text(copied).foregroundColor(.green) }
            }
        }
        .navigationTitle(candidate.username)
        .onChange(of: candidate) { _, newValue in store.update(newValue) }
    }
}

struct DraftSection: View {
    var title: String
    var text: String
    @Binding var copied: String
    var body: some View {
        Section(title) {
            Text(text)
            Button("Copy draft") {
                UIPasteboard.general.string = text
                copied = "Copied. You send it yourself in Snapchat — this app never sends it."
            }
        }
    }
}

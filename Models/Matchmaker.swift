import Foundation

enum Basis: String, CaseIterable, Codable, Identifiable {
    case contactedFirst, mutualAccepted, knownPersonally
    var id: String { rawValue }
    var label: String {
        switch self {
        case .contactedFirst: return "She contacted me first"
        case .mutualAccepted: return "Already mutual / accepted"
        case .knownPersonally: return "I already know her personally"
        }
    }
}

enum AIConsent: String, CaseIterable, Codable {
    case notAsked, yes, no
    var label: String {
        switch self {
        case .notAsked: return "Not asked yet"
        case .yes: return "Yes — agreed"
        case .no: return "No — declined"
        }
    }
}

enum IntimacyTopic: String, CaseIterable, Codable {
    case notDiscussed, permissionGiven, declined
    var label: String {
        switch self {
        case .notDiscussed: return "Not discussed"
        case .permissionGiven: return "Permission given to discuss values"
        case .declined: return "Declined to discuss"
        }
    }
}

struct Candidate: Identifiable, Codable, Equatable {
    var id = UUID()
    var username: String = ""
    var basis: Basis = .contactedFirst
    var adultConfirmed: Bool = false
    var ageVolunteered: String = "unknown"
    var religionVolunteered: String = "unknown"
    var locationVolunteered: String = "unknown"
    var aiConsent: AIConsent = .notAsked
    var incomingMessages: Int = 0
    var positiveSignals: Int = 0
    var mutualEffort: Bool = false
    var mutualRomanticInterest: Bool = false
    var seriousIntention: Bool = false
    var marriageExpectations: String = ""
    var intimacyTopic: IntimacyTopic = .notDiscussed

    static let openingDraft = "Assalamualaikum ji \u{1F60A} Main Siraaj ki taraf se ek AI introduction assistant hoon. Agar aap comfortable ho toh kya hum thodi baat kar sakte hain?"
    static let gunturQuestion = "Aap Guntur se ho kya?"
    static let marriageQuestion = "Agar future mein hum dono shaadi karna chahein aur ghar wale raazi na hon, toh aap kya sochogi? Kya hum dono milkar unko samjha sakte hain?"

    var status: String {
        if aiConsent == .no { return "Closed — declined AI chat" }
        if locationVolunteered != "unknown" && locationVolunteered != "Guntur" { return "Closed — outside Guntur" }
        if isPromising { return "Promising — notify and pause" }
        if aiConsent == .yes { return "Active" }
        return "Draft ready — waiting for your approval"
    }

    var isPromising: Bool {
        adultConfirmed
        && religionVolunteered == "Muslim"
        && locationVolunteered == "Guntur"
        && mutualRomanticInterest
        && seriousIntention
        && incomingMessages >= 4
        && positiveSignals >= 3
        && mutualEffort
        && aiConsent == .yes
    }

    var promisingNotification: String {
        "❤️ PROMISING GUNTUR MATCH FOUND\n\nSnapchat username: \(username)\nAge: \(ageVolunteered)\nLocation: Guntur\nReligion: Muslim\nMutual romantic interest: \(mutualRomanticInterest ? "yes - expressed" : "no")\nCompatibility observations: \(incomingMessages) incoming messages, \(positiveSignals) positive signals, mutual effort: \(mutualEffort)\nMarriage expectations: \(marriageExpectations.isEmpty ? "unknown" : marriageExpectations)\nTopics still unknown: anything not voluntarily disclosed\nRecommended next step: Open conversation to take over personally."
    }
}

final class MatchmakerStore: ObservableObject {
    @Published var candidates: [Candidate] = [] {
        didSet { save() }
    }
    @Published var paused: Bool = false {
        didSet { save() }
    }
    private let key = "snapchat-matchmaker-candidates-v1"
    private let pausedKey = "snapchat-matchmaker-paused-v1"

    init() { load() }

    func add(_ candidate: Candidate) {
        guard candidate.adultConfirmed, !candidate.username.isEmpty else { return }
        candidates.append(candidate)
    }
    func update(_ candidate: Candidate) {
        guard let i = candidates.firstIndex(where: { $0.id == candidate.id }) else { return }
        candidates[i] = candidate
    }
    func delete(at offsets: IndexSet) { candidates.remove(atOffsets: offsets) }
    func deleteAll() { candidates = []; paused = false }

    private func save() {
        if let data = try? JSONEncoder().encode(candidates) {
            UserDefaults.standard.set(data, forKey: key)
        }
        UserDefaults.standard.set(paused, forKey: pausedKey)
    }
    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Candidate].self, from: data) {
            candidates = decoded
        }
        paused = UserDefaults.standard.bool(forKey: pausedKey)
    }
}

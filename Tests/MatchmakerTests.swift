import XCTest
@testable import Matchmaker

final class MatchmakerTests: XCTestCase {
    func testOpeningDraftIsExactAndPromisingThreshold() {
        XCTAssertTrue(Candidate.openingDraft.hasPrefix("Assalamualaikum ji"))
        XCTAssertEqual(Candidate.gunturQuestion, "Aap Guntur se ho kya?")
        var c = Candidate()
        c.username = "test_user"
        c.adultConfirmed = true
        c.aiConsent = .yes
        c.locationVolunteered = "Guntur"
        c.religionVolunteered = "Muslim"
        c.mutualEffort = true
        c.mutualRomanticInterest = true
        c.seriousIntention = true
        c.positiveSignals = 3
        c.incomingMessages = 3
        XCTAssertFalse(c.isPromising, "3 incoming messages must not be promising")
        c.incomingMessages = 4
        XCTAssertTrue(c.isPromising)
        XCTAssertTrue(c.promisingNotification.contains("PROMISING GUNTUR MATCH FOUND"))
        XCTAssertTrue(c.promisingNotification.contains("Open conversation to take over personally"))
    }
    func testDeclinedConsentIsNotPromising() {
        var c = Candidate()
        c.adultConfirmed = true
        c.aiConsent = .no
        c.locationVolunteered = "Guntur"
        c.religionVolunteered = "Muslim"
        c.incomingMessages = 10
        c.positiveSignals = 10
        c.mutualEffort = true
        c.mutualRomanticInterest = true
        c.seriousIntention = true
        XCTAssertFalse(c.isPromising)
        XCTAssertEqual(c.status, "Closed — declined AI chat")
    }
    func testOutsideGunturIsNotPromising() {
        var c = Candidate()
        c.adultConfirmed = true
        c.aiConsent = .yes
        c.locationVolunteered = "Outside Guntur"
        c.religionVolunteered = "Muslim"
        c.incomingMessages = 10
        c.positiveSignals = 10
        c.mutualEffort = true
        c.mutualRomanticInterest = true
        c.seriousIntention = true
        XCTAssertFalse(c.isPromising)
    }
    func testStoreRefusesContactWithoutAdultConfirmation() {
        let store = MatchmakerStore()
        var c = Candidate()
        c.username = "test_user"
        c.adultConfirmed = false
        store.add(c)
        XCTAssertTrue(store.candidates.isEmpty)
    }
    func testUnknownFieldsStayUnknownByDefault() {
        let c = Candidate()
        XCTAssertEqual(c.ageVolunteered, "unknown")
        XCTAssertEqual(c.religionVolunteered, "unknown")
        XCTAssertEqual(c.locationVolunteered, "unknown")
        XCTAssertFalse(c.isPromising)
    }
}

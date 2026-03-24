import XCTest
@testable import SecurityKit

final class SecurityKitTests: XCTestCase {

    var storage: SecureStorage!

    override func setUp() {
        super.setUp()
        storage = SecureStorage()
        // Clean slate — remove any keys left from previous runs
        storage.delete(forKey: "test.token")
        storage.delete(forKey: "test.overwrite")
        storage.delete(forKey: "test.delete")
    }

    // MARK: - SecureStorage

    func testSaveAndRetrieve() throws {
        try storage.save("eyJhbGciOiJSUzI1NiJ9", forKey: "test.token")
        let value = try storage.retrieve(forKey: "test.token")
        XCTAssertEqual(value, "eyJhbGciOiJSUzI1NiJ9")
    }

    func testOverwriteExistingKey() throws {
        try storage.save("first-value", forKey: "test.overwrite")
        try storage.save("second-value", forKey: "test.overwrite")
        let value = try storage.retrieve(forKey: "test.overwrite")
        XCTAssertEqual(value, "second-value", "Should return the most recently saved value")
    }

    func testDeleteRemovesItem() throws {
        try storage.save("to-be-deleted", forKey: "test.delete")
        storage.delete(forKey: "test.delete")
        XCTAssertThrowsError(try storage.retrieve(forKey: "test.delete")) { error in
            XCTAssertEqual(error as? SecurityKitError, SecurityKitError.notFound)
        }
    }

    func testRetrieveNonExistentKeyThrowsNotFound() {
        XCTAssertThrowsError(try storage.retrieve(forKey: "definitely.does.not.exist")) { error in
            XCTAssertEqual(error as? SecurityKitError, SecurityKitError.notFound)
        }
    }

    func testDeleteNonExistentKeyDoesNotThrow() {
        // Should silently succeed — not crash or throw
        storage.delete(forKey: "key.that.was.never.saved")
    }

    // MARK: - DeviceIntegrity

    func testSimulatorAlwaysReportsClean() {
        #if targetEnvironment(simulator)
        let integrity = DeviceIntegrity()
        XCTAssertFalse(integrity.isCompromised, "Simulator should always report device as clean")
        XCTAssertEqual(integrity.riskLevel, .none)
        #endif
    }

    func testStatusMessageMatchesCompromisedState() {
        let integrity = DeviceIntegrity()
        if integrity.isCompromised {
            XCTAssertTrue(integrity.statusMessage.contains("failed"))
            XCTAssertEqual(integrity.riskLevel, .high)
        } else {
            XCTAssertTrue(integrity.statusMessage.contains("verified"))
            XCTAssertEqual(integrity.riskLevel, .none)
        }
    }
}

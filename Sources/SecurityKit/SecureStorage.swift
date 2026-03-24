import Foundation
import SecurityKitCore

/// Thread-safe interface for storing and retrieving sensitive string values
/// in the iOS Keychain.
///
/// Usage:
/// ```swift
/// let storage = SecureStorage()
/// try storage.save("eyJhbGci...", forKey: "auth.accessToken")
/// let token = try storage.retrieve(forKey: "auth.accessToken")
/// storage.delete(forKey: "auth.accessToken")
/// ```
public final class SecureStorage {

    public init() {}

    // MARK: - Write

    /// Saves a string value to the Keychain under `key`.
    /// Overwrites any existing value for that key.
    ///
    /// - Parameters:
    ///   - value: The string to store (e.g. a JWT, PIN hash, or session token).
    ///   - key:   A stable identifier, e.g. `"com.nullstack.aims.accessToken"`.
    /// - Throws: `SecurityKitError.encodingFailed` or `SecurityKitError.saveFailed`.
    public func save(_ value: String, forKey key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw SecurityKitError.encodingFailed
        }
        let status = KeychainService.save(key: key, data: data)
        guard status == errSecSuccess else {
            throw SecurityKitError.saveFailed(status)
        }
    }

    // MARK: - Read

    /// Retrieves a previously stored string value from the Keychain.
    ///
    /// - Parameter key: The same key used when saving.
    /// - Returns: The stored string value.
    /// - Throws: `SecurityKitError.notFound` if no item exists for `key`.
    public func retrieve(forKey key: String) throws -> String {
        guard
            let data = KeychainService.load(key: key),
            let value = String(data: data, encoding: .utf8)
        else {
            throw SecurityKitError.notFound
        }
        return value
    }

    // MARK: - Delete

    /// Removes the item for `key` from the Keychain.
    /// Silently does nothing if the item does not exist.
    public func delete(forKey key: String) {
        KeychainService.delete(key: key)
    }
}

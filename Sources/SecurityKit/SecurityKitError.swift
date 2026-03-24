import Foundation

/// Errors thrown by SecurityKit operations.
public enum SecurityKitError: Error, LocalizedError, Equatable {

    /// The string value could not be encoded as UTF-8 data.
    case encodingFailed

    /// The Keychain returned a non-success OSStatus.
    case saveFailed(OSStatus)

    /// No item was found in the Keychain for the given key.
    case notFound

    public var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "Failed to encode value as UTF-8 data."
        case .saveFailed(let status):
            return "Keychain write failed (OSStatus \(status))."
        case .notFound:
            return "No item found in Keychain for the specified key."
        }
    }
}

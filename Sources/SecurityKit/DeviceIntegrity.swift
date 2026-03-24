import Foundation
import SecurityKitCore

/// Provides heuristic signals about the integrity of the current device.
///
/// Usage:
/// ```swift
/// let integrity = DeviceIntegrity()
/// if integrity.isCompromised {
///     // Log to analytics, restrict features, or warn the user
/// }
/// ```
public struct DeviceIntegrity {

    public init() {}

    /// Returns `true` if heuristic checks suggest the device may be jailbroken.
    ///
    /// Always returns `false` on the simulator.
    public var isCompromised: Bool {
        JailbreakDetector.isJailbroken()
    }

    /// A human-readable status string suitable for display in a demo UI.
    public var statusMessage: String {
        isCompromised
            ? "⚠️  Device integrity check failed"
            : "✅  Device integrity verified"
    }

    /// Risk level derived from the integrity check.
    public var riskLevel: RiskLevel {
        isCompromised ? .high : .none
    }
}

// MARK: - Supporting types

public enum RiskLevel: String, Sendable {
    case none = "None"
    case high = "High"
}

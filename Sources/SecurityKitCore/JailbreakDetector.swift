import Foundation

/// Heuristic jailbreak detection. Internal — not exposed directly.
/// Note: No detection is foolproof; sophisticated jailbreaks can evade these checks.
/// Use as one signal among many, not as a hard gate.
package struct JailbreakDetector {

    package static func isJailbroken() -> Bool {
        #if targetEnvironment(simulator)
        // Simulator always returns false — sandbox rules don't apply
        return false
        #else
        return hasSuspiciousFiles() || canWriteOutsideSandbox()
        #endif
    }

    // MARK: - Private checks

    /// Checks for files installed by common jailbreak tools
    private static func hasSuspiciousFiles() -> Bool {
        let suspiciousPaths = [
            "/Applications/Cydia.app",
            "/Applications/Sileo.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/usr/bin/ssh"
        ]
        return suspiciousPaths.contains { FileManager.default.fileExists(atPath: $0) }
    }

    /// Attempts to write outside the app sandbox.
    /// On a stock device this always fails; on a jailbroken device it may succeed.
    private static func canWriteOutsideSandbox() -> Bool {
        let testPath = "/private/jailbreak_probe_\(UUID().uuidString)"
        do {
            try "probe".write(toFile: testPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            return true // Succeeded — sandbox is broken
        } catch {
            return false // Expected on a stock device
        }
    }
}

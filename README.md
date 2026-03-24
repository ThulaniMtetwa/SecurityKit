# SecurityKit

A Swift Package demonstrating **multi-target package architecture**, **Keychain storage**, and **jailbreak detection** — built as a learning exercise and portfolio piece.

## Package structure

```
SecurityKit/
├── Package.swift
├── Sources/
│   ├── SecurityKitCore/          ← Internal implementation (not importable by consumers)
│   │   ├── KeychainService.swift
│   │   └── JailbreakDetector.swift
│   └── SecurityKit/              ← Public API layer
│       ├── SecureStorage.swift
│       ├── DeviceIntegrity.swift
│       └── SecurityKitError.swift
├── Tests/
│   └── SecurityKitTests/
│       └── SecurityKitTests.swift
└── Examples/
    └── ContentView.swift         ← SwiftUI demo app view
```

## Features

### `SecureStorage`
Stores and retrieves sensitive string values in the iOS Keychain with `kSecAttrAccessibleWhenUnlockedThisDeviceOnly`.

```swift
let storage = SecureStorage()

// Save
try storage.save("eyJhbGci...", forKey: "com.myapp.accessToken")

// Retrieve
let token = try storage.retrieve(forKey: "com.myapp.accessToken")

// Delete
storage.delete(forKey: "com.myapp.accessToken")
```

### `DeviceIntegrity`
Heuristic jailbreak detection using filesystem and sandbox checks.

```swift
let integrity = DeviceIntegrity()

if integrity.isCompromised {
    // Restrict sensitive features, log to analytics, warn the user
    print(integrity.statusMessage) // "⚠️ Device integrity check failed"
    print(integrity.riskLevel)     // RiskLevel.high
}
```

## Requirements

- iOS 16+
- Swift 5.9+
- Xcode 15+

## Installation (Swift Package Manager)

```
https://github.com/YOUR_USERNAME/SecurityKit
```

File → Add Package Dependencies → paste URL → choose version rule.

## Running the example app

1. Open `Package.swift` in Xcode
2. Create a new iOS App project in `Examples/SecurityKitDemoApp/`
3. In the new project: **File → Add Package Dependencies → Add Local…** → select the `SecurityKit` folder
4. Link `SecurityKit` library to your app target
5. Replace `ContentView.swift` with the provided `Examples/ContentView.swift`

## Architecture notes

The two-target split (`SecurityKitCore` + `SecurityKit`) demonstrates the **internal/public boundary pattern** in SPM:
- `SecurityKitCore` contains raw implementations that are intentionally `internal`
- `SecurityKit` wraps Core and exposes a clean, stable public API
- Consumers can only `import SecurityKit` — they never see Core internals

## License

MIT

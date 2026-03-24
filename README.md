cat > README.md << 'EOF'
# SecurityKit

A Swift Package demonstrating **multi-target package architecture**, **Keychain storage**, and **jailbreak detection** — built as a learning exercise and portfolio piece.

## Screenshots

<table>
  <tr>
    <td align="center"><b>Home</b></td>
    <td align="center"><b>Save</b></td>
    <td align="center"><b>Retrieve</b></td>
    <td align="center"><b>Delete</b></td>
  </tr>
  <tr>
    <td><img src="demo_screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202026-03-24%20at%2023.24.05.png" width="180"></td>
    <td><img src="demo_screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202026-03-24%20at%2023.24.15.png" width="180"></td>
    <td><img src="demo_screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202026-03-24%20at%2023.24.19.png" width="180"></td>
    <td><img src="demo_screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202026-03-24%20at%2023.24.22.png" width="180"></td>
  </tr>
</table>

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
├── Examples/
│   └── SecurityKitDemoApp/       ← SwiftUI demo app
└── demo_screenshots/
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
https://github.com/ThulaniMtetwa/SecurityKit
```

File → Add Package Dependencies → paste URL → choose version rule.

## Running the example app

1. Open `Package.swift` in Xcode
2. In the new project: **File → Add Package Dependencies → Add Local…** → select the `SecurityKit` folder
3. Link `SecurityKit` library to your app target under **General → Frameworks**
4. Run on simulator

## Architecture notes

The two-target split (`SecurityKitCore` + `SecurityKit`) demonstrates the **internal/public boundary pattern** in SPM:
- `SecurityKitCore` contains raw implementations marked `package` — visible across targets within this package, but never exported to consumers
- `SecurityKit` wraps Core and exposes a clean, stable `public` API
- Consumers can only `import SecurityKit` — they never see Core internals

## License

MIT
EOF
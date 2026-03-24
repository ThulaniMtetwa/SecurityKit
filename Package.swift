// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SecurityKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "SecurityKit", targets: ["SecurityKit"]),
    ],
    targets: [
        // Internal implementation — consumers never import this directly
        .target(
            name: "SecurityKitCore",
            path: "Sources/SecurityKitCore"
        ),
        // Public API layer — this is what apps import
        .target(
            name: "SecurityKit",
            dependencies: ["SecurityKitCore"],
            path: "Sources/SecurityKit"
        ),
        .testTarget(
            name: "SecurityKitTests",
            dependencies: ["SecurityKit"],
            path: "Tests/SecurityKitTests"
        ),
    ]
)

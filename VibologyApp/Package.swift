// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "VibologyApp",
    platforms: [.macOS(.v26)],
    targets: [
        .executableTarget(
            name: "VibologyApp",
            path: "Sources/VibologyApp",
            resources: [.process("Resources")]
        )
    ]
)

// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "PianoAnalytics",
    platforms: [
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3),
        .macOS(.v10_12)
    ],
    products: [
        .library(name: "PianoAnalytics", targets: ["PianoAnalytics"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PianoAnalytics",
            resources: [
                .process("default.json")
            ],
            swiftSettings: [
              .define("SPM")
            ]
        ),
        .testTarget(
            name: "PianoAnalyticsTests",
            dependencies: ["PianoAnalytics"]
        ),
        .testTarget(
            name: "Piano Analytics Tests",
            dependencies: ["PianoAnalytics"]
        )
    ],
    swiftLanguageVersions: [.v5]
)

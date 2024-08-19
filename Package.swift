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
    dependencies: [
        .package(url: "https://gitlab.com/piano-public/sdk/ios/packages/consents", .upToNextMinor(from: "1.0.8")),
    ],
    targets: [
        .target(
            name: "PianoAnalytics",
            dependencies: [
                .product(name: "PianoConsents", package: "consents")
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
              .define("SPM")
            ]
        ),
        .testTarget(
            name: "PianoAnalyticsTests",
            dependencies: [
                "PianoAnalytics",
                .product(name: "PianoConsents", package: "consents")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)

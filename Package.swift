// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "PianoAnalytics",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v9),
        .macOS(.v13)
    ],
    products: [
        .library(name: "PianoAnalytics", targets: ["PianoAnalytics"])
    ],
    dependencies: [
        .package(url: "https://gitlab.com/piano-public/sdk/ios/packages/consents", .upToNextMajor(from: "1.0.11")),
    ],
    targets: [
        .target(
            name: "PianoAnalytics",
            dependencies: [
                .product(name: "PianoConsents", package: "consents")
            ],
            resources: [
                .process("Resources")
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

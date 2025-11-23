// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Loggy",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Loggy",
            targets: ["Loggy"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Loggy",
            dependencies: []
        ),
        .executableTarget(
            name: "LoggyExample",
            dependencies: ["Loggy"]
        ),
        .testTarget(
            name: "LoggyTests",
            dependencies: ["Loggy"]
        ),
    ]
)

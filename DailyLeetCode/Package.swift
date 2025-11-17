// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DailyLeetCode",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "DailyLeetCodeCore",
            targets: ["DailyLeetCodeCore"]
        ),
        .executable(
            name: "DailyLeetCodeRunner",
            targets: ["DailyLeetCodeRunner"]
        )
    ],
    targets: [
        .target(
            name: "DailyLeetCodeCore"
        ),
        .executableTarget(
            name: "DailyLeetCodeRunner",
            dependencies: ["DailyLeetCodeCore"]
        ),
        .testTarget(
            name: "DailyLeetCodeCoreTests",
            dependencies: ["DailyLeetCodeCore"]
        )
    ]
)

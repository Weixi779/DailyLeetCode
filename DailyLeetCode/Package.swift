// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DailyLeetCode",
    platforms: [
        .macOS(.v14)
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
    dependencies: [
        .package(path: "../LeetCodeAPI")
    ],
    targets: [
        .target(
            name: "DailyLeetCodeCore",
            dependencies: [
                "LeetCodeAPI"
            ]
        ),
        .executableTarget(
            name: "DailyLeetCodeRunner",
            dependencies: ["DailyLeetCodeCore", "LeetCodeAPI"]
        ),
        .testTarget(
            name: "DailyLeetCodeCoreTests",
            dependencies: ["DailyLeetCodeCore"]
        )
    ]
)

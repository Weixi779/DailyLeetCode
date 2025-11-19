// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LeetCodeAPI",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "LeetCodeAPI",
            targets: ["LeetCodeAPI"]
        ),
    ],
    dependencies: [
        .package(path: "../DailyLeetCode/Demark-main")
    ],
    targets: [
        .target(
            name: "LeetCodeAPI",
            dependencies: [
                .product(name: "Demark", package: "Demark-main")
            ]
        ),
        .testTarget(
            name: "LeetCodeAPITests",
            dependencies: ["LeetCodeAPI"]
        ),
    ]
)

// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Coral",
    products: [
        .library(
            name: "Coral",
            targets: ["Coral"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Coral",
            dependencies: [],
            path: ".",
            sources: ["Sources"]),
        .testTarget(
            name: "CoralTests",
            dependencies: ["Coral"],
            path: ".",
            sources: ["Tests"]),
    ]
)

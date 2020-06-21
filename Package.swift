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
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
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

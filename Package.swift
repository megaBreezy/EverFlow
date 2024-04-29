// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EverFlow",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "EverFlow",
            targets: ["EverFlow"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/nalexn/ViewInspector", .upToNextMajor(from: "0.9.10")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "EverFlow"),
        .testTarget(
            name: "EverFlowTests",
            dependencies: ["EverFlow", "ViewInspector"]),
    ]
)

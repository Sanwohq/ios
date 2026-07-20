// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Sanwo",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Sanwo", targets: ["Sanwo"])
    ],
    targets: [
        .target(name: "Sanwo"),
        .testTarget(name: "SanwoTests", dependencies: ["Sanwo"])
    ]
)

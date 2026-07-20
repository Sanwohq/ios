// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Sanwo",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Sanwo", targets: ["Sanwo"]),
        .library(name: "SanwoPaystack", targets: ["SanwoPaystack"]),
        .library(name: "SanwoFlutterwave", targets: ["SanwoFlutterwave"]),
    ],
    targets: [
        .target(name: "Sanwo"),
        .target(name: "SanwoPaystack", dependencies: ["Sanwo"]),
        .target(name: "SanwoFlutterwave", dependencies: ["Sanwo"]),
        .testTarget(name: "SanwoTests", dependencies: ["Sanwo", "SanwoPaystack", "SanwoFlutterwave"]),
    ]
)

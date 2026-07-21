// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Sanwo",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Sanwo", targets: ["Sanwo"]),
        .library(name: "SanwoFlutterwave", targets: ["SanwoFlutterwave"]),
        .library(name: "SanwoInterswitch", targets: ["SanwoInterswitch"]),
        .library(name: "SanwoMonnify", targets: ["SanwoMonnify"]),
        .library(name: "SanwoPaystack", targets: ["SanwoPaystack"]),
        .library(name: "SanwoRazorpay", targets: ["SanwoRazorpay"]),
    ],
    targets: [
        .target(name: "Sanwo"),
        .target(name: "SanwoFlutterwave", dependencies: ["Sanwo"]),
        .target(name: "SanwoInterswitch", dependencies: ["Sanwo"]),
        .target(name: "SanwoMonnify", dependencies: ["Sanwo"]),
        .target(name: "SanwoPaystack", dependencies: ["Sanwo"]),
        .target(name: "SanwoRazorpay", dependencies: ["Sanwo"]),
        .testTarget(name: "SanwoTests", dependencies: ["Sanwo", "SanwoFlutterwave", "SanwoInterswitch", "SanwoMonnify", "SanwoPaystack", "SanwoRazorpay"]),
    ]
)

// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SwipyCell",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "SwipyCell", targets: ["SwipyCell"])
    ],
    targets: [
        .target(name: "SwipyCell")
    ]
)

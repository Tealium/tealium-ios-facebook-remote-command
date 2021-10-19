// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "TealiumFacebook",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "TealiumFacebook", targets: ["TealiumFacebook"])
    ],
    dependencies: [
        .package(url: "https://github.com/tealium/tealium-swift", from: "2.1.0"),
        .package(url: "https://github.com/facebook/facebook-ios-sdk", from: "12.0.0")
    ],
    targets: [
        .target(
            name: "TealiumFacebook",
            dependencies: ["FacebookCore", "TealiumCore", "TealiumRemoteCommands", "TealiumTagManagement"],
            path: "./Sources"),
        .testTarget(
            name: "TealiumFacebookTests",
            dependencies: ["TealiumFacebook"],
            path: "./Tests")
    ]
)

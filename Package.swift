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
        .package(url: "git@github.com:Tealium/tealium-swift-builder.git", .branch("2.1.0")),
        .package(url: "https://github.com/facebook/facebook-ios-sdk", from: "8.0.0")
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

// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "TealiumFacebook",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "TealiumFacebook", targets: ["TealiumFacebook"])
    ],
    dependencies: [
        .package(url: "https://github.com/tealium/tealium-swift", .upToNextMajor(from: "2.16.0")),
        .package(url: "https://github.com/facebook/facebook-ios-sdk", .upToNextMajor(from: "18.0.0"))
    ],
    targets: [
        .target(
            name: "TealiumFacebook",
            dependencies: [
                .product(name: "TealiumCore", package: "tealium-swift"),
                .product(name: "TealiumRemoteCommands", package: "tealium-swift"),
                .product(name: "FacebookCore", package: "facebook-ios-sdk")
            ],
            path: "./Sources",
            exclude: ["Support"]),
        .testTarget(
            name: "TealiumFacebookTests",
            dependencies: ["TealiumFacebook"],
            path: "./Tests",
            exclude: ["Support"])
    ]
)

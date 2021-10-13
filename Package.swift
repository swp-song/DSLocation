// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DSLocation",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "DSLocation", targets: ["DSLocation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swp-song/DSBase.git", .upToNextMajor(from: "3.0.0")),
    ],
    targets: [
        
        .target(
            name: "DSLocation",
            dependencies: ["DSBase"],
            path: "Sources",
            linkerSettings:[
                .linkedFramework("Foundation", .when(platforms: [.iOS])),
                .linkedFramework("CoreLocation", .when(platforms: [.iOS])),
            ]
        ),
        
        .testTarget(name: "DSLocationTests", dependencies: ["DSBase"], path: "Tests"),
    ],
    swiftLanguageVersions: [.v5]
)

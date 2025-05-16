// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Created by Ming on 11/6/2022.
//

import PackageDescription

let package = Package(
    name: "SwiftNEW",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .watchOS(.v8),
        .macOS(.v14),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SwiftNEW",
            targets: ["SwiftNEW"]),
    ],
    dependencies: [
        .package(name: "SwiftVB", url: "https://github.com/1998code/SwiftVBKit.git", .upToNextMinor(from: "1.4.0")),
        .package(name: "Drops", url: "https://github.com/omaralbeik/Drops.git", .upToNextMinor(from: "1.7.0")),
        .package(name: "SwiftGlass", url: "https://github.com/1998code/SwiftGlass.git", .upToNextMinor(from: "1.8.0"))
    ],
    targets: [
        .target(
            name: "SwiftNEW",
            dependencies: [
                "SwiftVB",
                "Drops",
                "SwiftGlass"
            ]
        )
    ]
)

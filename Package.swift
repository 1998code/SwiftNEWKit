// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Created by Ming on 11/6/2022.
//

import PackageDescription

let package = Package(
    name: "SwiftNEW",
    platforms: [
        .iOS(.v14),
        .watchOS(.v7),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "SwiftNEW",
            targets: ["SwiftNEW"]),
    ],
    dependencies: [
        .package(name: "SwiftVB", url: "https://github.com/1998code/SwiftVBKit.git", .upToNextMinor(from: "1.4.0")),
    ],
    targets: [
        .target(
            name: "SwiftNEW",
            dependencies: [
                "SwiftVB"
            ]),
//        .testTarget(
//            name: "SwiftNEWTests",
//            dependencies: ["SwiftNEW"]),
    ]
)

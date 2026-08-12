//
//  BundleExtLogicTests.swift
//  SwiftNEWTests
//

import Foundation
import Testing
@testable import SwiftNEW

@Test func bundleHelpersReadLegacyArraysAndTopLevelAssetNames() throws {
    let temporaryBundle = try makeTemporaryBundle(
        info: [
            "CFBundleIconFiles": ["Legacy20", "Legacy20", "Legacy60"],
            "CFBundleIconName": "LegacyAsset"
        ]
    )
    defer { temporaryBundle.remove() }

    #expect(temporaryBundle.bundle.iconFileNames() == ["Legacy20", "Legacy60"])
    #expect(temporaryBundle.bundle.iconFileName == "Legacy60")
    #expect(temporaryBundle.bundle.appIconAssetName() == "LegacyAsset")
    #expect(temporaryBundle.bundle.appIconAssetName(alternateIconName: "Missing") == nil)
    #expect(temporaryBundle.bundle.declaredAppIconNames == ["LegacyAsset"])
    #expect(
        temporaryBundle.bundle.appStoreListingBundleIdentifier
            == temporaryBundle.bundle.bundleIdentifier
    )
}

@Test func bundleHelpersFallBackToAnIPadOnlyIconDictionary() {
    let info: [String: Any] = [
        "CFBundleIcons~ipad": [
            "CFBundlePrimaryIcon": [
                "CFBundleIconName": "PadIcon",
                "CFBundleIconFiles": ["Pad20", "Pad20", "Pad76"]
            ],
            "CFBundleAlternateIcons": [
                "Green": ["CFBundleIconFiles": ["Green76"]]
            ]
        ]
    ]

    #expect(Bundle.iconFileNames(in: info) == ["Pad20", "Pad76"])
    #expect(
        Bundle.iconFileNames(in: info, prefersIPadIcons: true)
            == ["Pad20", "Pad76"]
    )
    #expect(
        Bundle.iconFileNames(in: info, alternateIconName: "Green")
            == ["Green76"]
    )
    #expect(Bundle.appIconAssetName(in: info) == "PadIcon")
    #expect(Bundle.declaredAppIconNames(in: info) == ["PadIcon", "Green"])
}

@Test func bundleHelpersUseLegacyValuesWhenModernIconEntriesAreEmpty() throws {
    let temporaryBundle = try makeTemporaryBundle(
        info: [
            "CFBundleIcons": [
                "CFBundlePrimaryIcon": [
                    "CFBundleIconName": "",
                    "CFBundleIconFiles": [String]()
                ]
            ],
            "CFBundleIconFiles": ["FallbackIcon"],
            "CFBundleIconName": "FallbackAsset"
        ]
    )
    defer { temporaryBundle.remove() }

    #expect(temporaryBundle.bundle.iconFileNames() == ["FallbackIcon"])
    #expect(temporaryBundle.bundle.appIconAssetName() == "FallbackAsset")
    #expect(temporaryBundle.bundle.iconFileNames(alternateIconName: "Missing").isEmpty)
}

@Test func bundleVersionAndNameHelpersCoverFallbackPrecedence() throws {
    let populatedBundle = try makeTemporaryBundle(
        info: [
            "CFBundleShortVersionString": "9.4",
            "CFBundleVersion": "321",
            "CFBundleDisplayName": "Displayed Name",
            "CFBundleName": "Fallback Name"
        ]
    )
    defer { populatedBundle.remove() }

    #expect(Bundle.versionBuild(in: populatedBundle.bundle) == "9.4 (321)")
    #expect(Bundle.appName(in: populatedBundle.bundle) == "Displayed Name")

    let fallbackBundle = try makeTemporaryBundle(
        info: ["CFBundleName": "Fallback Name"]
    )
    defer { fallbackBundle.remove() }

    #expect(Bundle.versionBuild(in: fallbackBundle.bundle) == "1.0 (1)")
    #expect(Bundle.appName(in: fallbackBundle.bundle) == "Fallback Name")

    let unnamedBundle = try makeTemporaryBundle(info: [:])
    defer { unnamedBundle.remove() }
    #expect(Bundle.appName(in: unnamedBundle.bundle).isEmpty)
}

@Test func bundleIconResourceCandidatesAreOrderedAndDeduplicated() {
    let threeX = Bundle.main.appIconResourceCandidates(
        for: "AppIcon",
        displayScale: 3.2
    )
    #expect(threeX.first == "AppIcon@3x.png")
    #expect(threeX.last == "AppIcon~ipad.png")
    #expect(threeX.count == Set(threeX).count)

    let explicitExtension = Bundle.main.appIconResourceCandidates(
        for: "Legacy.jpeg",
        displayScale: 1
    )
    #expect(explicitExtension.first == "Legacy.jpeg")
    #expect(explicitExtension.contains("Legacy@2x.jpeg"))
    #expect(explicitExtension.count == Set(explicitExtension).count)
}

private struct TemporaryBundle {
    let bundle: Bundle
    let directory: URL

    func remove() {
        try? FileManager.default.removeItem(at: directory)
    }
}

private func makeTemporaryBundle(info: [String: Any]) throws -> TemporaryBundle {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent("SwiftNEWBundle-\(UUID().uuidString).bundle", isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

    var plist = info
    plist["CFBundleIdentifier"] = "com.swiftnew.tests.\(UUID().uuidString)"
    plist["CFBundlePackageType"] = "BNDL"
    let data = try PropertyListSerialization.data(
        fromPropertyList: plist,
        format: .xml,
        options: 0
    )
    try data.write(to: directory.appendingPathComponent("Info.plist"))

    return TemporaryBundle(
        bundle: try #require(Bundle(url: directory)),
        directory: directory
    )
}

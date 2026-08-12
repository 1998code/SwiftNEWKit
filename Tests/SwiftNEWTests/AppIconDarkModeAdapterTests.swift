import Foundation
import Testing
@testable import SwiftNEW

#if os(iOS)
import CoreImage
import SwiftUI
import UIKit
#endif

@Test func appIconDarkModeAdapterDarkensBrightNeutralColors() {
    let white = AppIconDarkModeColorTransform.adaptedComponents(
        red: 1,
        green: 1,
        blue: 1
    )
    let lightGray = AppIconDarkModeColorTransform.adaptedComponents(
        red: 0.8,
        green: 0.8,
        blue: 0.8
    )

    #expect(white.x < 0.11)
    #expect(white.y < 0.11)
    #expect(white.z < 0.11)
    #expect(lightGray.x < 0.3)
    #expect(lightGray.y < 0.3)
    #expect(lightGray.z < 0.3)
}

@Test func appIconDarkModeAdapterPreservesChromaticAndDarkColors() {
    let purple = SIMD3<Float>(0.439, 0.29, 0.937)
    let adaptedPurple = AppIconDarkModeColorTransform.adaptedComponents(
        red: purple.x,
        green: purple.y,
        blue: purple.z
    )
    let dark = SIMD3<Float>(repeating: 0.05)
    let adaptedDark = AppIconDarkModeColorTransform.adaptedComponents(
        red: dark.x,
        green: dark.y,
        blue: dark.z
    )

    #expect(abs(adaptedPurple.x - purple.x) < 0.001)
    #expect(abs(adaptedPurple.y - purple.y) < 0.001)
    #expect(abs(adaptedPurple.z - purple.z) < 0.001)
    #expect(abs(adaptedDark.x - dark.x) < 0.001)
    #expect(abs(adaptedDark.y - dark.y) < 0.001)
    #expect(abs(adaptedDark.z - dark.z) < 0.001)
}

@Test func appIconDarkModeAdapterRequiresBroadLightCoverage() {
    #expect(
        AppIconDarkModeColorTransform.hasEnoughImageCoverage(
            weightedCoverage: 0.8,
            visibleCoverage: 1
        )
    )
    #expect(
        !AppIconDarkModeColorTransform.hasEnoughImageCoverage(
            weightedCoverage: 0.1,
            visibleCoverage: 1
        )
    )
    #expect(
        !AppIconDarkModeColorTransform.hasEnoughImageCoverage(
            weightedCoverage: 0,
            visibleCoverage: 0
        )
    )
}

#if os(iOS)
@MainActor
@Test func appIconDarkModeAdapterReturnsUnsupportedAndChromaticImagesUnchanged() {
    let ciImage = CIImage(color: CIColor(red: 1, green: 1, blue: 1)).cropped(
        to: CGRect(x: 0, y: 0, width: 4, height: 4)
    )
    let unsupportedImage = UIImage(ciImage: ciImage)
    let unsupportedResult = AppIconDarkModeAdapter.shared.adaptedImage(
        unsupportedImage,
        targetSize: CGSize(width: 4, height: 4),
        displayScale: 1,
        cacheKey: "unsupported-\(UUID().uuidString)"
    )

    #expect(unsupportedResult === unsupportedImage)

    let chromaticImage = makeSolidAppIconImage(color: .red)
    let cacheKey = "chromatic-\(UUID().uuidString)"
    let firstResult = AppIconDarkModeAdapter.shared.adaptedImage(
        chromaticImage,
        targetSize: CGSize(width: 8, height: 8),
        displayScale: 1,
        cacheKey: cacheKey
    )
    let cachedResult = AppIconDarkModeAdapter.shared.adaptedImage(
        chromaticImage,
        targetSize: CGSize(width: 8, height: 8),
        displayScale: 1,
        cacheKey: cacheKey
    )

    #expect(firstResult === chromaticImage)
    #expect(cachedResult === chromaticImage)
}

@MainActor
@Test func appIconDarkModeAdapterDarkensRasterAndClampsInvalidOutputDimensions() throws {
    let image = makeSolidAppIconImage(color: .white)
    let cacheKey = "neutral-\(UUID().uuidString)"
    let adapted = AppIconDarkModeAdapter.shared.adaptedImage(
        image,
        targetSize: .zero,
        displayScale: 0,
        cacheKey: cacheKey
    )
    let cached = AppIconDarkModeAdapter.shared.adaptedImage(
        image,
        targetSize: .zero,
        displayScale: 0,
        cacheKey: cacheKey
    )
    let cgImage = try #require(adapted.cgImage)

    #expect(adapted !== image)
    #expect(cached === adapted)
    #expect(cgImage.width == 1)
    #expect(cgImage.height == 1)
    #expect(adapted.scale == 1)
}

@MainActor
@Test func appIconViewResolvesNamedAlternateAndLooseRasterIcons() throws {
    let bundleURL = FileManager.default.temporaryDirectory
        .appendingPathComponent("SwiftNEWAppIconView-\(UUID().uuidString).bundle", isDirectory: true)
    try FileManager.default.createDirectory(
        at: bundleURL,
        withIntermediateDirectories: true
    )
    defer { try? FileManager.default.removeItem(at: bundleURL) }

    let plist: [String: Any] = [
        "CFBundleIdentifier": "com.swiftnew.coverage.app-icon-view.\(UUID().uuidString)",
        "CFBundlePackageType": "BNDL",
        "CFBundleIcons": [
            "CFBundlePrimaryIcon": [
                "CFBundleIconName": "DeclaredIcon",
                "CFBundleIconFiles": ["MissingIcon", "SmallIcon", "LargeIcon", "LargeIcon"]
            ],
            "CFBundleAlternateIcons": [
                "Green": [
                    "CFBundleIconName": "DeclaredGreenIcon",
                    "CFBundleIconFiles": ["LargeIcon"]
                ]
            ]
        ]
    ]
    let plistData = try PropertyListSerialization.data(
        fromPropertyList: plist,
        format: .xml,
        options: 0
    )
    try plistData.write(to: bundleURL.appendingPathComponent("Info.plist"))

    try writeAppIconImage(
        makeSolidAppIconImage(color: .white, size: CGSize(width: 8, height: 8)),
        named: "SmallIcon@2x.png",
        to: bundleURL
    )
    try writeAppIconImage(
        makeSolidAppIconImage(color: .white, size: CGSize(width: 32, height: 32)),
        named: "LargeIcon@2x.png",
        to: bundleURL
    )
    try writeAppIconImage(
        makeSolidAppIconImage(color: .blue),
        named: "NamedAsset.png",
        to: bundleURL
    )
    try writeAppIconImage(
        makeSolidAppIconImage(color: .green),
        named: "SwiftNEWAppIcon-Blue.png",
        to: bundleURL
    )

    let bundle = try #require(Bundle(url: bundleURL))

    let namedAsset = AppIconView(assetName: " NamedAsset ", bundle: bundle)
    let automaticAlternate = AppIconView(alternateIconName: "Blue", bundle: bundle)
    let declaredPrimary = AppIconView(assetName: "DeclaredIcon", bundle: bundle)
    let primaryRaster = AppIconView(assetName: "  ", bundle: bundle)
    let declaredAlternate = AppIconView(
        assetName: "DeclaredGreenIcon",
        alternateIconName: "Green",
        bundle: bundle
    )
    let missingAlternate = AppIconView(alternateIconName: "Missing", bundle: bundle)

    #expect(namedAsset.testingResolvedAssetName == "NamedAsset")
    #expect(automaticAlternate.testingResolvedAssetName == "SwiftNEWAppIcon-Blue")
    #expect(declaredPrimary.testingResolvedAssetName == nil)
    #expect(
        declaredPrimary.testingRasterIconResourceURL(displayScale: 2)?.lastPathComponent
            == "LargeIcon@2x.png"
    )
    #expect(
        primaryRaster.testingRasterIconResourceURL(displayScale: 2)?.lastPathComponent
            == "LargeIcon@2x.png"
    )
    #expect(declaredAlternate.testingResolvedAssetName == nil)
    #expect(
        declaredAlternate.testingRasterIconResourceURL(displayScale: 2)?.lastPathComponent
            == "LargeIcon@2x.png"
    )
    #expect(missingAlternate.testingResolvedAssetName == nil)
    #expect(missingAlternate.testingRasterIconResourceURL(displayScale: 2) == nil)

    renderAppIcon(
        namedAsset
            .environment(\.colorScheme, .light)
    )
    renderAppIcon(
        automaticAlternate
            .environment(\.colorScheme, .light)
    )
    renderAppIcon(
        declaredPrimary
            .environment(\.colorScheme, .light)
            .environment(\.displayScale, 2)
    )
    renderAppIcon(
        primaryRaster
            .environment(\.colorScheme, .dark)
            .environment(\.displayScale, 2)
    )
    renderAppIcon(
        declaredAlternate
            .environment(\.colorScheme, .dark)
            .environment(\.displayScale, 2)
    )
    renderAppIcon(missingAlternate)
}

@MainActor
private func makeSolidAppIconImage(
    color: UIColor,
    size: CGSize = CGSize(width: 8, height: 8)
) -> UIImage {
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1
    format.opaque = color.cgColor.alpha == 1
    return UIGraphicsImageRenderer(size: size, format: format).image { context in
        context.cgContext.setFillColor(color.cgColor)
        context.cgContext.fill(CGRect(origin: .zero, size: size))
    }
}

@MainActor
private func writeAppIconImage(
    _ image: UIImage,
    named name: String,
    to folder: URL
) throws {
    let data = try #require(image.pngData())
    try data.write(to: folder.appendingPathComponent(name))
}

@MainActor
private func renderAppIcon<Content: View>(_ content: Content) {
    let controller = UIHostingController(rootView: content)
    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    window.rootViewController = controller
    window.isHidden = false
    controller.loadViewIfNeeded()
    controller.view.frame = window.bounds
    controller.view.setNeedsLayout()
    controller.view.layoutIfNeeded()
    _ = controller.view.systemLayoutSizeFitting(
        CGSize(width: 100, height: 100)
    )
}
#endif

//
//  AppIconView.swift
//  SwiftNEW
//
//  Created by Ming on 7/1/2025.
//
#if os(iOS)
import SwiftUI
import UIKit

@MainActor
public struct AppIconView: View {
    private static let automaticAssetName = "SwiftNEWAppIcon"
    private static let iconSize: CGFloat = 65

    private struct RasterIcon {
        let image: UIImage
        let resourceURL: URL
    }

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.displayScale) private var displayScale

    private let assetName: String?
    private let alternateIconName: String?
    private let bundle: Bundle

    /// Creates an app-icon view.
    ///
    /// SwiftNEW automatically adapts a bundled static app-icon raster for Dark
    /// Mode. Pass an ordinary adaptive image-set name for art-directed Light
    /// and Dark renditions.
    public init(
        assetName: String? = nil,
        alternateIconName: String? = nil,
        bundle: Bundle = .main
    ) {
        self.assetName = assetName
        self.alternateIconName = alternateIconName
        self.bundle = bundle
    }

    public var body: some View {
        Group {
            if let resolvedAssetName {
                styledIcon(
                    Image(resolvedAssetName, bundle: bundle)
                        .resizable()
                )
            } else if let automaticRasterIcon {
                styledIcon(
                    Image(uiImage: displayedRasterIcon(automaticRasterIcon))
                        .resizable()
                )
            }
        }
        .accessibilityHidden(true)
    }

    private var resolvedAssetName: String? {
        let automaticName = automaticAssetName(for: alternateIconName)
        let requestedNames = [normalizedAssetName, automaticName].compactMap { $0 }

        for requestedName in requestedNames {
            // App-icon and Icon Composer names can resolve to special,
            // non-bitmap renditions. Only ordinary image assets are used here.
            guard !bundle.declaredAppIconNames.contains(requestedName) else {
                continue
            }

            if UIImage(named: requestedName, in: bundle, compatibleWith: nil) != nil {
                return requestedName
            }
        }

        return nil
    }

    private var normalizedAssetName: String? {
        guard let name = assetName?.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty
        else {
            return nil
        }
        return name
    }

    private func automaticAssetName(for alternateIconName: String?) -> String {
        guard let alternateIconName else {
            return Self.automaticAssetName
        }
        return "\(Self.automaticAssetName)-\(alternateIconName)"
    }

    private var automaticRasterIcon: RasterIcon? {
        // App-icon catalog and Icon Composer entries are private UIKit
        // renditions, not general-purpose images. On some host apps,
        // UIImage(named:) returns a placeholder for one of these entries and
        // accessing its cgImage raises NSInternalInconsistencyException
        // ("Need an imageRef") instead of returning nil. Only load the loose
        // raster files declared in the bundle metadata here.
        rasterIcon
    }

    #if DEBUG
    var testingResolvedAssetName: String? {
        resolvedAssetName
    }

    func testingRasterIconResourceURL(
        displayScale: CGFloat,
        prefersIPadIcons: Bool = false
    ) -> URL? {
        rasterIcon(
            displayScale: displayScale,
            prefersIPadIcons: prefersIPadIcons
        )?.resourceURL
    }
    #endif

    private var rasterIcon: RasterIcon? {
        rasterIcon(
            displayScale: displayScale,
            prefersIPadIcons: UIDevice.current.userInterfaceIdiom == .pad
        )
    }

    private func rasterIcon(
        displayScale: CGFloat,
        prefersIPadIcons: Bool
    ) -> RasterIcon? {
        bundle.iconFileNames(
            alternateIconName: alternateIconName,
            prefersIPadIcons: prefersIPadIcons
        )
            .compactMap {
                loadRasterIcon(named: $0, displayScale: displayScale)
            }
            .max { pixelArea(of: $0) < pixelArea(of: $1) }
    }

    private func pixelArea(of rasterIcon: RasterIcon) -> CGFloat {
        let image = rasterIcon.image
        return image.size.width * image.scale * image.size.height * image.scale
    }

    private func displayedRasterIcon(_ rasterIcon: RasterIcon) -> UIImage {
        let image = rasterIcon.image
        guard colorScheme == .dark else {
            return image
        }

        let iconIdentity = alternateIconName.map { "alternate:\($0)" } ?? "primary"
        let sourceWidth = image.cgImage?.width ?? Int(image.size.width * image.scale)
        let sourceHeight = image.cgImage?.height ?? Int(image.size.height * image.scale)
        let scale = Int(displayScale.rounded())
        let cacheKey = [
            bundle.bundleURL.standardizedFileURL.path,
            iconIdentity,
            rasterIcon.resourceURL.standardizedFileURL.path,
            "\(sourceWidth)x\(sourceHeight)",
            "\(scale)x"
        ].joined(separator: "|")
        return AppIconDarkModeAdapter.shared.adaptedImage(
            image,
            targetSize: CGSize(
                width: Self.iconSize,
                height: Self.iconSize
            ),
            displayScale: displayScale,
            cacheKey: cacheKey
        )
    }

    private func loadRasterIcon(
        named fileName: String,
        displayScale: CGFloat
    ) -> RasterIcon? {
        for resourceName in bundle.appIconResourceCandidates(
            for: fileName,
            displayScale: displayScale
        ) {
            let resource = resourceName as NSString
            let fileExtension = resource.pathExtension
            let name = resource.deletingPathExtension

            if let url = bundle.url(
                forResource: name,
                withExtension: fileExtension.isEmpty ? nil : fileExtension
            ), let image = UIImage(contentsOfFile: url.path) {
                return RasterIcon(image: image, resourceURL: url)
            }
        }

        // App-icon stacks and other special renditions aren't general-purpose
        // images. The loose raster path above remains the safe fallback.
        return nil
    }

    private func styledIcon<Content: View>(_ content: Content) -> some View {
        content
            .aspectRatio(1, contentMode: .fit)
            .frame(width: Self.iconSize, height: Self.iconSize)
            .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
    }
}
#endif

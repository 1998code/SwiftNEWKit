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

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.displayScale) private var displayScale

    private let assetName: String?
    private let alternateIconName: String?
    private let bundle: Bundle

    /// Creates an app-icon view.
    ///
    /// On iOS 26 or later, SwiftNEW first attempts to use the flattened Light or
    /// Dark rendition that Xcode compiles from an Icon Composer app icon. Pass
    /// an ordinary adaptive image-set name when a deterministic override is
    /// required.
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
            } else if let rasterIcon {
                styledIcon(
                    Image(uiImage: rasterIcon)
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
            // Declared app-icon names can resolve to special, non-bitmap
            // renditions. The dedicated path below accepts only a raster result.
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

    private var rasterIcon: UIImage? {
        bundle.iconFileNames(
            alternateIconName: alternateIconName,
            prefersIPadIcons: UIDevice.current.userInterfaceIdiom == .pad
        )
            .compactMap { loadRasterIcon(named: $0) }
            .max { pixelArea(of: $0) < pixelArea(of: $1) }
    }

    private func pixelArea(of image: UIImage) -> CGFloat {
        image.size.width * image.scale * image.size.height * image.scale
    }

    private func loadRasterIcon(named fileName: String) -> UIImage? {
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
                return image
            }
        }

        // Legacy asset-catalog icons normally have a concrete bitmap backing.
        // Special/vector renditions are handled only by the dedicated path.
        guard !bundle.declaredAppIconNames.contains(fileName),
              let image = UIImage(named: fileName, in: bundle, compatibleWith: nil),
              image.cgImage != nil || image.ciImage != nil
        else {
            return nil
        }

        return image
    }

    private func styledIcon<Content: View>(_ content: Content) -> some View {
        content
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 65, height: 65)
            .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
    }
}
#endif

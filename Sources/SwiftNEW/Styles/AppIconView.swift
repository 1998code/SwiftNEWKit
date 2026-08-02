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
            } else if let compiledAppIcon {
                styledIcon(
                    Image(uiImage: compiledAppIcon)
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
            // AppIcon and Icon Composer names can resolve to private, non-raster
            // renditions on iOS 26. Only ordinary image assets are safe here.
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

    /// Icon Composer stores generated Light and Dark flat renditions alongside
    /// its system-only icon stack. UIKit can expose the flat rendition through
    /// named asset lookup on iOS 26. Copy its CGImage before handing it to
    /// SwiftUI so a special icon-stack-backed image is never rendered here.
    private var compiledAppIcon: UIImage? {
        guard #available(iOS 26.0, *),
              let name = bundle.appIconAssetName(
                alternateIconName: alternateIconName,
                prefersIPadIcons: UIDevice.current.userInterfaceIdiom == .pad
              )
        else {
            return nil
        }

        let userInterfaceStyle: UIUserInterfaceStyle = colorScheme == .dark
            ? .dark
            : .light
        let traits = UITraitCollection(traitsFrom: [
            UITraitCollection(userInterfaceStyle: userInterfaceStyle),
            UITraitCollection(displayScale: displayScale),
            UITraitCollection(userInterfaceIdiom: UIDevice.current.userInterfaceIdiom)
        ])

        guard let image = UIImage(
            named: name,
            in: bundle,
            compatibleWith: traits
        ), let cgImage = image.cgImage else {
            return nil
        }

        return UIImage(
            cgImage: cgImage,
            scale: image.scale,
            orientation: image.imageOrientation
        )
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
        // Reject special/vector renditions so SwiftUI never receives an image
        // that cannot supply an image reference on iOS 26.
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

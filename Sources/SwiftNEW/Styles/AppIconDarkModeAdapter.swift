//
//  AppIconDarkModeAdapter.swift
//  SwiftNEW
//

#if os(iOS)
import CoreGraphics
import UIKit

/// Produces a Dark Mode fallback from a static app-icon raster.
///
/// Icon Composer renditions are not exposed as general-purpose images on iOS.
/// This adapter leaves chromatic artwork unchanged and smoothly maps only
/// bright, near-neutral pixels toward black.
@MainActor
final class AppIconDarkModeAdapter {
    static let shared = AppIconDarkModeAdapter()

    private static let algorithmVersion = 2

    private let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 16
        cache.totalCostLimit = 8 * 1_024 * 1_024
    }

    func adaptedImage(
        _ image: UIImage,
        targetSize: CGSize,
        displayScale: CGFloat,
        cacheKey: String
    ) -> UIImage {
        guard let sourceCGImage = image.cgImage,
              let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)
        else {
            return image
        }

        let outputScale = Swift.max(displayScale, 1)
        let pixelWidth = Swift.max(
            Int((targetSize.width * outputScale).rounded(.up)),
            1
        )
        let pixelHeight = Swift.max(
            Int((targetSize.height * outputScale).rounded(.up)),
            1
        )
        let key = "\(cacheKey)|\(pixelWidth)x\(pixelHeight)|v\(Self.algorithmVersion)" as NSString

        if let cachedImage = cache.object(forKey: key) {
            return cachedImage
        }

        let bytesPerRow = pixelWidth * 4
        var pixels = [UInt8](
            repeating: 0,
            count: bytesPerRow * pixelHeight
        )
        let outputCGImage = pixels.withUnsafeMutableBytes { rawBuffer -> CGImage? in
            let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue
                | CGImageAlphaInfo.premultipliedLast.rawValue
            guard let context = CGContext(
                data: rawBuffer.baseAddress,
                width: pixelWidth,
                height: pixelHeight,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo
            ) else {
                return nil
            }

            context.interpolationQuality = .high
            context.draw(
                sourceCGImage,
                in: CGRect(
                    x: 0,
                    y: 0,
                    width: CGFloat(pixelWidth),
                    height: CGFloat(pixelHeight)
                )
            )
            context.flush()

            let bytes = rawBuffer.bindMemory(to: UInt8.self)
            var weightedCoverage: Float = 0
            var visibleCoverage: Float = 0

            for offset in stride(from: 0, to: bytes.count, by: 4) {
                let alphaByte = bytes[offset + 3]
                guard alphaByte > 0 else {
                    continue
                }

                let alpha = Float(alphaByte) / 255
                let red = Swift.min(Float(bytes[offset]) / Float(alphaByte), 1)
                let green = Swift.min(Float(bytes[offset + 1]) / Float(alphaByte), 1)
                let blue = Swift.min(Float(bytes[offset + 2]) / Float(alphaByte), 1)
                let weight = AppIconDarkModeColorTransform.adaptationWeight(
                    red: red,
                    green: green,
                    blue: blue
                )
                weightedCoverage += weight * alpha
                visibleCoverage += alpha
            }

            guard AppIconDarkModeColorTransform.hasEnoughImageCoverage(
                weightedCoverage: weightedCoverage,
                visibleCoverage: visibleCoverage
            ) else {
                return nil
            }

            for offset in stride(from: 0, to: bytes.count, by: 4) {
                let alphaByte = bytes[offset + 3]
                guard alphaByte > 0 else {
                    continue
                }

                let alpha = Float(alphaByte) / 255
                let red = Swift.min(Float(bytes[offset]) / Float(alphaByte), 1)
                let green = Swift.min(Float(bytes[offset + 1]) / Float(alphaByte), 1)
                let blue = Swift.min(Float(bytes[offset + 2]) / Float(alphaByte), 1)
                let adapted = AppIconDarkModeColorTransform.adaptedComponents(
                    red: red,
                    green: green,
                    blue: blue
                )

                bytes[offset] = Self.premultipliedByte(adapted.x, alpha: alpha)
                bytes[offset + 1] = Self.premultipliedByte(adapted.y, alpha: alpha)
                bytes[offset + 2] = Self.premultipliedByte(adapted.z, alpha: alpha)
            }

            return context.makeImage()
        }

        guard let outputCGImage else {
            cache.setObject(image, forKey: key)
            return image
        }

        let adaptedImage = UIImage(
            cgImage: outputCGImage,
            scale: outputScale,
            orientation: image.imageOrientation
        )
        cache.setObject(
            adaptedImage,
            forKey: key,
            cost: bytesPerRow * pixelHeight
        )
        return adaptedImage
    }

    private static func premultipliedByte(
        _ component: Float,
        alpha: Float
    ) -> UInt8 {
        let clampedComponent = Swift.min(Swift.max(component, 0), 1)
        return UInt8((clampedComponent * alpha * 255).rounded())
    }
}
#endif

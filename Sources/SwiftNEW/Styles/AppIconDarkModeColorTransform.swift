//
//  AppIconDarkModeColorTransform.swift
//  SwiftNEW
//

/// Platform-independent color transform for the automatic Dark Mode app icon.
enum AppIconDarkModeColorTransform {
    static let minimumImageCoverage: Float = 0.2

    static func adaptedComponents(
        red: Float,
        green: Float,
        blue: Float
    ) -> SIMD3<Float> {
        let source = SIMD3<Float>(red, green, blue)
        let adaptationAmount = adaptationWeight(
            red: red,
            green: green,
            blue: blue
        )

        // The gain matches Icon Composer's near-black Dark material while
        // preserving subtle neutral detail and antialiased edges.
        let target = source * 0.09
        return source + (target - source) * adaptationAmount
    }

    static func adaptationWeight(
        red: Float,
        green: Float,
        blue: Float
    ) -> Float {
        let maximum = Swift.max(red, Swift.max(green, blue))
        let minimum = Swift.min(red, Swift.min(green, blue))
        let chroma = maximum - minimum
        let luminance = red * 0.2126 + green * 0.7152 + blue * 0.0722
        let brightAmount = smoothstep(
            lowerBound: 0.62,
            upperBound: 0.88,
            value: luminance
        )
        let neutralAmount = 1 - smoothstep(
            lowerBound: 0.03,
            upperBound: 0.16,
            value: chroma
        )
        return brightAmount * neutralAmount
    }

    static func hasEnoughImageCoverage(
        weightedCoverage: Float,
        visibleCoverage: Float
    ) -> Bool {
        guard visibleCoverage > 0 else {
            return false
        }
        return weightedCoverage / visibleCoverage >= minimumImageCoverage
    }

    private static func smoothstep(
        lowerBound: Float,
        upperBound: Float,
        value: Float
    ) -> Float {
        let normalized = Swift.min(
            Swift.max((value - lowerBound) / (upperBound - lowerBound), 0),
            1
        )
        return normalized * normalized * (3 - 2 * normalized)
    }
}

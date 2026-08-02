import Testing
@testable import SwiftNEW

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

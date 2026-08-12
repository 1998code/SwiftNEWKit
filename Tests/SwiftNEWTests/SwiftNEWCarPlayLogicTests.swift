//
//  SwiftNEWCarPlayLogicTests.swift
//  SwiftNEWTests
//

import Testing
@testable import SwiftNEW

@Test func carPlaySelectorRequiresTheCurrentReleaseByDefault() {
    let releases = [
        makeCarPlayRelease(version: "3.0.0"),
        makeCarPlayRelease(version: "2.0.0"),
        makeCarPlayRelease(version: "1.0.0")
    ]

    let current = SwiftNEWCarPlayReleaseSelector.releases(
        from: releases,
        currentVersion: "2.0.0",
        includesHistory: false
    )
    let missing = SwiftNEWCarPlayReleaseSelector.releases(
        from: releases,
        currentVersion: "2.1.0",
        includesHistory: false
    )
    let availableHistory = SwiftNEWCarPlayReleaseSelector.releases(
        from: releases,
        currentVersion: "2.1.0",
        includesHistory: true
    )

    #expect(current.map(\.version) == ["2.0.0"])
    #expect(missing.isEmpty)
    #expect(availableHistory.map(\.version) == ["2.0.0", "1.0.0"])
}

@Test func carPlaySelectorKeepsCurrentAndOlderReleasesOnly() {
    let releases = [
        makeCarPlayRelease(version: "1.0.0"),
        makeCarPlayRelease(version: "3.0.0"),
        makeCarPlayRelease(version: "2.0", subVersion: "2.0.0"),
        makeCarPlayRelease(version: "Preview")
    ]

    let selected = SwiftNEWCarPlayReleaseSelector.releases(
        from: releases,
        currentVersion: "2.0.0",
        includesHistory: true
    )

    #expect(selected.map(\.version) == ["2.0", "1.0.0"])
}

@Test func carPlaySelectorFallsBackToAnExactNonSemanticCurrentRelease() {
    let releases = [
        makeCarPlayRelease(version: "1.0.0"),
        makeCarPlayRelease(version: " Preview "),
        makeCarPlayRelease(version: "0.9.0")
    ]

    let selected = SwiftNEWCarPlayReleaseSelector.releases(
        from: releases,
        currentVersion: "Preview",
        includesHistory: true
    )

    #expect(selected.map(\.version) == [" Preview "])
    #expect(
        SwiftNEWCarPlayReleaseSelector.releases(
            from: releases,
            currentVersion: " \n ",
            includesHistory: true
        ).isEmpty
    )
}

@Test func carPlaySelectorUsesVersionWhenSubVersionIsBlank() {
    let releases = [
        makeCarPlayRelease(version: "2.1.0"),
        makeCarPlayRelease(version: " 1.5.0 ", subVersion: "   "),
        makeCarPlayRelease(version: "1.0.0")
    ]

    let selected = SwiftNEWCarPlayReleaseSelector.releases(
        from: releases,
        currentVersion: "2.0.0",
        includesHistory: true
    )

    #expect(selected.map(\.version) == [" 1.5.0 ", "1.0.0"])
}

@Test func carPlaySelectorAppliesPrereleasePrecedence() {
    let releases = [
        makeCarPlayRelease(version: "2.0.0"),
        makeCarPlayRelease(version: "2.0.0-beta.1"),
        makeCarPlayRelease(version: "2.0.0-beta.2"),
        makeCarPlayRelease(version: "1.9.0")
    ]

    let selected = SwiftNEWCarPlayReleaseSelector.releases(
        from: releases,
        currentVersion: "2.0.0-beta.2",
        includesHistory: true
    )

    #expect(
        selected.map(\.version)
            == ["2.0.0-beta.2", "2.0.0-beta.1", "1.9.0"]
    )
}

private func makeCarPlayRelease(
    version: String,
    subVersion: String? = nil
) -> Vmodel {
    Vmodel(
        version: version,
        subVersion: subVersion,
        new: [
            Model(
                icon: "sparkles",
                title: version,
                subtitle: "Summary",
                body: "Details"
            )
        ]
    )
}

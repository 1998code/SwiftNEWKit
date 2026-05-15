//
//  SwiftNEWLogicTests.swift
//  SwiftNEW
//

import Testing
@testable import SwiftNEW

@Test func versionStateDoesNotPresentWhenValuesMatchAfterTrimming() {
    #expect(
        SwiftNEWVersionState.shouldPresent(
            currentVersion: " 1.2.3 ",
            currentBuild: "\n45 ",
            savedVersion: "1.2.3",
            savedBuild: "45"
        ) == false
    )
}

@Test func versionStatePresentsForVersionChanges() {
    #expect(
        SwiftNEWVersionState.shouldPresent(
            currentVersion: "1.2.3-beta",
            currentBuild: "45",
            savedVersion: "1.2.3",
            savedBuild: "45"
        )
    )
}

@Test func versionStatePresentsForBuildChanges() {
    #expect(
        SwiftNEWVersionState.shouldPresent(
            currentVersion: "1.2.3",
            currentBuild: "46",
            savedVersion: "1.2.3",
            savedBuild: "45"
        )
    )
}

@Test func modelIDsAreStable() {
    let model = Model(
        icon: "sparkles",
        title: "Search",
        subtitle: "Fast filtering",
        body: "Matches release notes"
    )
    let version = Vmodel(version: "1.0.0", subVersion: "1.0", new: [model])

    #expect(model.id == "sparkles|Search|Fast filtering|Matches release notes")
    #expect(version.id == "1.0.0|1.0")
}

@Test func searchMatchesTitleSubtitleAndBodyCaseInsensitively() {
    let model = Model(
        icon: "sparkles",
        title: "Search",
        subtitle: "Fast Filtering",
        body: "Matches release notes"
    )

    #expect(SwiftNEWSearch.matches(model, query: "search", isEnabled: true))
    #expect(SwiftNEWSearch.matches(model, query: "filtering", isEnabled: true))
    #expect(SwiftNEWSearch.matches(model, query: "RELEASE", isEnabled: true))
    #expect(SwiftNEWSearch.matches(model, query: "missing", isEnabled: true) == false)
}

@Test func searchReturnsAllWhenDisabledOrEmpty() {
    let model = Model(
        icon: "sparkles",
        title: "Search",
        subtitle: "Fast filtering",
        body: "Matches release notes"
    )

    #expect(SwiftNEWSearch.matches(model, query: "missing", isEnabled: false))
    #expect(SwiftNEWSearch.matches(model, query: "   ", isEnabled: true))
}

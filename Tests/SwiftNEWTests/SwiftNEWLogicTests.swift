//
//  SwiftNEWLogicTests.swift
//  SwiftNEW
//

import Testing
import Foundation
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

@Test func parsedVersionsUseNumericOrderingAndIgnoreTrailingZeroes() {
    #expect(SwiftNEWParsedVersion("1.10")! > SwiftNEWParsedVersion("1.9.9")!)
    #expect(SwiftNEWParsedVersion("2.0")! > SwiftNEWParsedVersion("1.99.99")!)
    #expect(SwiftNEWParsedVersion("1.2") == SwiftNEWParsedVersion("1.2.0.0"))
    #expect(SwiftNEWParsedVersion(" v01.002.000 ") == SwiftNEWParsedVersion("1.2"))
    #expect(
        SwiftNEWParsedVersion("1.999999999999999999999999999999")!
            > SwiftNEWParsedVersion("1.10")!
    )
}

@Test func parsedVersionsFollowPrereleasePrecedenceAndIgnoreBuildMetadata() {
    #expect(SwiftNEWParsedVersion("1.0.0-beta")! < SwiftNEWParsedVersion("1.0.0")!)
    #expect(SwiftNEWParsedVersion("1.0.0-beta.10")! > SwiftNEWParsedVersion("1.0.0-beta.2")!)
    #expect(SwiftNEWParsedVersion("1.0.0+45") == SwiftNEWParsedVersion("1.0.0+99"))
}

@Test func parsedVersionsRejectMalformedValues() {
    #expect(SwiftNEWParsedVersion("") == nil)
    #expect(SwiftNEWParsedVersion("1..2") == nil)
    #expect(SwiftNEWParsedVersion("1.x") == nil)
    #expect(SwiftNEWParsedVersion("1.0b3") == nil)
    #expect(SwiftNEWParsedVersion("version 2") == nil)
}

@Test func releaseSelectorFindsLatestNewerVersionWithoutAssumingJSONOrder() {
    let releases = [
        makeRelease(version: "1.8.0", title: "First"),
        makeRelease(version: "2.0.0", title: "Latest"),
        makeRelease(version: "1.10.0", title: "Middle")
    ]

    let candidate = SwiftNEWReleaseSelector.latestUpdate(
        in: releases,
        currentVersion: "1.5.0"
    )

    #expect(candidate?.version == "2.0.0")
    #expect(candidate?.release.new.first?.title == "Latest")
}

@Test func releaseSelectorPrefersSubVersionAndTreatsEquivalentVersionsAsCurrent() {
    let releases = [
        makeRelease(version: "6.4", subVersion: "6.4.0", title: "Current"),
        makeRelease(version: "6.5", subVersion: "6.5.1", title: "Update")
    ]

    let candidate = SwiftNEWReleaseSelector.latestUpdate(
        in: releases,
        currentVersion: "6.4"
    )

    #expect(candidate?.version == "6.5.1")
    #expect(candidate?.release.version == "6.5")
    #expect(
        SwiftNEWReleaseSelector.latestUpdate(
            in: [releases[0]],
            currentVersion: "6.4"
        ) == nil
    )
}

@Test func releaseSelectorFailsClosedForInvalidAuthoritativeVersions() {
    let releases = [
        makeRelease(version: "9.0", subVersion: "not-a-version", title: "Invalid"),
        makeRelease(version: "2.0", subVersion: "   ", title: "Fallback")
    ]

    let candidate = SwiftNEWReleaseSelector.latestUpdate(
        in: releases,
        currentVersion: "1.0"
    )

    #expect(candidate?.version == "2.0")
    #expect(candidate?.release.new.first?.title == "Fallback")
    #expect(
        SwiftNEWReleaseSelector.latestUpdate(
            in: releases,
            currentVersion: "invalid-current-version"
        ) == nil
    )
}

@Test func remoteSourceRequiresHTTPURLWithAHost() {
    #expect(SwiftNEWRemoteSource.looksRemote(" HTTPS://example.com/releases.json "))
    #expect(SwiftNEWRemoteSource.looksRemote("release-http-data") == false)
    #expect(SwiftNEWRemoteSource.url(from: "https://example.com/releases.json") != nil)
    #expect(SwiftNEWRemoteSource.url(from: "https://") == nil)
}

@Test func updateResolverOnlyReturnsCandidatesForOptedInRemoteSources() {
    let releases = [makeRelease(version: "2.0", title: "Update")]

    #expect(
        SwiftNEWUpdateResolver.candidate(
            in: releases,
            currentVersion: "1.0",
            source: "https://example.com/releases.json",
            checkForUpdates: true
        )?.version == "2.0"
    )
    #expect(
        SwiftNEWUpdateResolver.candidate(
            in: releases,
            currentVersion: "1.0",
            source: "https://example.com/releases.json",
            checkForUpdates: false
        ) == nil
    )
    #expect(
        SwiftNEWUpdateResolver.candidate(
            in: releases,
            currentVersion: "1.0",
            source: "data",
            checkForUpdates: true
        ) == nil
    )
    #expect(
        SwiftNEWUpdateResolver.candidate(
            in: releases,
            currentVersion: "2.0",
            source: "https://example.com/releases.json",
            checkForUpdates: true
        ) == nil
    )
}

@Test func appStoreLookupBuildsBundleIdentifierRequestAndDecodesTrackURL() throws {
    let requestURL = try #require(
        SwiftNEWAppStoreLookup.requestURL(bundleIdentifier: "io.startway.nfc")
    )
    let components = try #require(URLComponents(url: requestURL, resolvingAgainstBaseURL: false))

    #expect(components.scheme == "https")
    #expect(components.host == "itunes.apple.com")
    #expect(components.path == "/lookup")
    #expect(components.queryItems?.count == 1)
    #expect(components.queryItems?.first?.name == "bundleId")
    #expect(components.queryItems?.first?.value == "io.startway.nfc")

    let regionalURL = try #require(
        SwiftNEWAppStoreLookup.requestURL(
            bundleIdentifier: "io.startway.nfc",
            countryCode: " hk "
        )
    )
    let regionalComponents = try #require(
        URLComponents(url: regionalURL, resolvingAgainstBaseURL: false)
    )
    #expect(regionalComponents.queryItems?.last?.name == "country")
    #expect(regionalComponents.queryItems?.last?.value == "HK")
    #expect(SwiftNEWAppStoreLookup.normalizedCountryCode("ß") == nil)
    #expect(SwiftNEWAppStoreLookup.normalizedCountryCode("001") == nil)

    let responseData = """
    {
      "resultCount": 1,
      "results": [
        {
          "bundleId": "io.startway.NFC",
          "trackViewUrl": "https://apps.apple.com/us/app/powernfc/id6748850927?uo=4"
        }
      ]
    }
    """.data(using: .utf8)!

    let appStoreURL = try SwiftNEWAppStoreLookup.appStoreURL(
        from: responseData,
        bundleIdentifier: "io.startway.nfc"
    )
    #expect(appStoreURL?.host == "apps.apple.com")
    #expect(appStoreURL?.path.hasSuffix("/id6748850927") == true)
}

@Test func appStoreLookupRejectsMissingAppsAndNonAppleDestinations() throws {
    let emptyResponse = "{\"resultCount\":0,\"results\":[]}".data(using: .utf8)!
    #expect(
        try SwiftNEWAppStoreLookup.appStoreURL(
            from: emptyResponse,
            bundleIdentifier: "com.example.missing"
        ) == nil
    )

    let unsafeResponse = """
    {
      "results": [
        {
          "bundleId": "com.example.app",
          "trackViewUrl": "https://example.com/not-the-app-store"
        }
      ]
    }
    """.data(using: .utf8)!
    #expect(
        try SwiftNEWAppStoreLookup.appStoreURL(
            from: unsafeResponse,
            bundleIdentifier: "com.example.app"
        ) == nil
    )
}

@Test func appStoreLookupSkipsMismatchesAndInvalidURLsBeforeAValidResult() throws {
    let responseData = """
    {
      "results": [
        {
          "bundleId": "com.example.other",
          "trackViewUrl": "https://apps.apple.com/app/id1"
        },
        {
          "bundleId": "com.example.app",
          "trackViewUrl": "http://apps.apple.com/app/id2"
        },
        {
          "bundleId": "com.example.app",
          "trackViewUrl": "https://apps.apple.com.evil.example/app/id3"
        },
        {
          "bundleId": "COM.EXAMPLE.APP",
          "trackViewUrl": "https://apps.apple.com/app/id4"
        }
      ]
    }
    """.data(using: .utf8)!

    let appStoreURL = try SwiftNEWAppStoreLookup.appStoreURL(
        from: responseData,
        bundleIdentifier: " com.example.app "
    )
    #expect(appStoreURL?.path == "/app/id4")
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

@Test func modelsDecodeIconTransitions() throws {
    let toIconData = """
    {
        "icon": "checkmark.shield",
        "toIcon": "shield.checkered",
        "title": "Compatibility",
        "subtitle": "Fixes",
        "body": "Improved platform support."
    }
    """.data(using: .utf8)!

    let toIconModel = try JSONDecoder().decode(Model.self, from: toIconData)
    #expect(toIconModel.displayedIcon == "checkmark.shield")
    #expect(toIconModel.iconTransitionTarget == "shield.checkered")
    #expect(toIconModel.iconSequence == ["checkmark.shield", "shield.checkered"])

    let iconsData = """
    {
        "icons": ["checkmark.shield", "shield.checkered", "sparkles"],
        "title": "Compatibility",
        "subtitle": "Fixes",
        "body": "Improved platform support."
    }
    """.data(using: .utf8)!

    let iconsModel = try JSONDecoder().decode(Model.self, from: iconsData)
    #expect(iconsModel.icon == "checkmark.shield")
    #expect(iconsModel.displayedIcon == "checkmark.shield")
    #expect(iconsModel.iconTransitionTarget == "shield.checkered")
    #expect(iconsModel.iconSequence == ["checkmark.shield", "shield.checkered", "sparkles"])
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

private func makeRelease(
    version: String,
    subVersion: String? = nil,
    title: String
) -> Vmodel {
    Vmodel(
        version: version,
        subVersion: subVersion,
        new: [
            Model(
                icon: "arrow.up.circle",
                title: title,
                subtitle: "Version \(version)",
                body: "Release notes"
            )
        ]
    )
}

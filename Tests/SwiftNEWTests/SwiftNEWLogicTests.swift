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

@Test func parsedVersionsFollowTheFullSemVerPrereleaseOrderingExample() {
    let orderedVersions = [
        "1.0.0-alpha",
        "1.0.0-alpha.1",
        "1.0.0-alpha.beta",
        "1.0.0-beta",
        "1.0.0-beta.2",
        "1.0.0-beta.11",
        "1.0.0-rc.1",
        "1.0.0"
    ].compactMap(SwiftNEWParsedVersion.init)

    #expect(orderedVersions.count == 8)
    for (earlier, later) in zip(orderedVersions, orderedVersions.dropFirst()) {
        #expect(earlier < later)
    }

    let textIdentifier = SwiftNEWParsedVersion("1.0.0-alpha.beta")!
    let numericIdentifier = SwiftNEWParsedVersion("1.0.0-alpha.1")!
    #expect((textIdentifier < numericIdentifier) == false)
    #expect(SwiftNEWParsedVersion("1.0.0-alpha") == SwiftNEWParsedVersion("1.0.0-alpha"))
}

@Test func parsedVersionsAcceptValidPrefixesAndMetadata() {
    #expect(SwiftNEWParsedVersion("V2.0.0") == SwiftNEWParsedVersion("2"))
    #expect(
        SwiftNEWParsedVersion("1.2.3-rc-1+build.45-linux")
            == SwiftNEWParsedVersion("1.2.3-rc-1+other")
    )
    #expect(SwiftNEWParsedVersion("1.0.0-alpha.0")! < SwiftNEWParsedVersion("1-alpha.1")!)
}

@Test func parsedVersionsRejectMalformedValues() {
    let malformedVersions = [
        "",
        "v",
        "v.1",
        "+build",
        "1.0+",
        "1.0+build..45",
        "1.0+build_45",
        "1..2",
        "1.x",
        "1.0b3",
        "1.0-",
        "1.0-alpha..1",
        "1.0-alpha_beta",
        "version 2",
        "١.٢.٣"
    ]

    for version in malformedVersions {
        #expect(SwiftNEWParsedVersion(version) == nil)
    }
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
    #expect(SwiftNEWRemoteSource.looksRemote("http://example.com/releases.json"))
    #expect(SwiftNEWRemoteSource.looksRemote("release-http-data") == false)
    let uppercaseSchemeURL = SwiftNEWRemoteSource.url(
        from: " HTTPS://example.com/releases.json "
    )
    #expect(uppercaseSchemeURL?.host == "example.com")
    #expect(SwiftNEWRemoteSource.url(from: "https://") == nil)
    #expect(SwiftNEWRemoteSource.url(from: "ftp://example.com/releases.json") == nil)
}

@Test func updateCandidateResolutionAndVersionSnapshotNormalizeTheirInputs() throws {
    let release = makeRelease(version: "2.0", title: "Update")
    let candidate = SwiftNEWUpdateCandidate(release: release, version: "2.0")
    let appStoreURL = try #require(URL(string: "https://apps.apple.com/app/id123"))

    #expect(candidate.appStoreURL == nil)
    #expect(candidate.resolvingAppStoreURL(appStoreURL).appStoreURL == appStoreURL)
    #expect(candidate.resolvingAppStoreURL(appStoreURL).release == release)
    #expect(
        SwiftNEWVersionSnapshot(version: " 2.0\n", build: " 45 ")
            == SwiftNEWVersionSnapshot(version: "2.0", build: "45")
    )
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
    #expect(SwiftNEWAppStoreLookup.requestURL(bundleIdentifier: " \n ") == nil)

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

@Test func appStoreLookupAcceptsOnlyAppleHTTPSHosts() throws {
    let responseData = """
    {
      "results": [
        { "trackViewUrl": "https://apps.apple.com/app/id0" },
        { "bundleId": "com.example.app" },
        {
          "bundleId": "com.example.app",
          "trackViewUrl": "not a valid URL"
        },
        {
          "bundleId": "com.example.app",
          "trackViewUrl": "https://itunes.apple.com/app/id1"
        }
      ]
    }
    """.data(using: .utf8)!

    let appStoreURL = try SwiftNEWAppStoreLookup.appStoreURL(
        from: responseData,
        bundleIdentifier: "com.example.app"
    )
    #expect(appStoreURL?.host == "itunes.apple.com")

    let regionalResponseData = """
    {
      "results": [
        {
          "bundleId": "com.example.app",
          "trackViewUrl": "https://search.itunes.apple.com/app/id2"
        }
      ]
    }
    """.data(using: .utf8)!
    let regionalURL = try SwiftNEWAppStoreLookup.appStoreURL(
        from: regionalResponseData,
        bundleIdentifier: "com.example.app"
    )
    #expect(regionalURL?.host == "search.itunes.apple.com")
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

@Test func modelDecodingRequiresAnIconOrANonemptyIconSequence() throws {
    let missingIconData = """
    {
        "icons": [],
        "title": "Missing icon",
        "subtitle": "Invalid",
        "body": "An icon is required."
    }
    """.data(using: .utf8)!

    do {
        _ = try JSONDecoder().decode(Model.self, from: missingIconData)
        Issue.record("Expected a missing icon decoding error")
    } catch DecodingError.keyNotFound(let key, let context) {
        #expect(key.stringValue == "icon")
        #expect(context.debugDescription.contains("icon"))
    } catch {
        Issue.record("Expected DecodingError.keyNotFound, received \(error)")
    }
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

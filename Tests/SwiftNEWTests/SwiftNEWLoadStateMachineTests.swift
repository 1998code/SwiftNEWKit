//
//  SwiftNEWLoadStateMachineTests.swift
//  SwiftNEWTests
//

import Foundation
import SwiftUI
import Testing
@testable import SwiftNEW

@MainActor
@Test func loadTaskResolvesRemoteUpdateWithRegionalAppStoreFallback() async throws {
    let release = makeLoadTestRelease(version: "2.0", title: "Regional update")
    let lookup = RegionalLookupStub(bundleIdentifier: "com.example.swiftnew")
    let show = LoadTestBox(false)
    let sut = makeLoadTestView(
        show: show,
        releases: [release],
        lookup: { url in try await lookup.load(url) },
        regionCode: { " hk " }
    )
    sut.version = "1.0"
    sut.build = "1"

    await sut.runLoadTask(sut.loadTaskID)

    #expect(sut.items == [release])
    #expect(sut.loading == false)
    #expect(sut.loadErrorMessage == nil)
    #expect(sut.appStoreLookupErrorMessage == nil)
    #expect(sut.availableUpdate?.version == "2.0")
    #expect(sut.availableUpdate?.appStoreURL?.absoluteString == "https://apps.apple.com/app/id200")
    #expect(sut.loadedDataSource == loadTestSource)
    #expect(sut.loadedRequest == sut.loadRequest)
    #expect(sut.loadGeneration == nil)
    #expect(sut.updateCheckPhase == .resolved)
    #expect(show.value)

    let requestedURLs = await lookup.requestedURLs
    #expect(requestedURLs.count == 2)
    #expect(requestedURLs.map { countryCode(in: $0) } == [nil, "HK"])
}

@MainActor
@Test func appStoreLookupCanFailAndRetryWithoutReloadingReleaseNotes() async throws {
    let release = makeLoadTestRelease(version: "2.0", title: "Retry update")
    let loader = RetryLookupStub(bundleIdentifier: "com.example.swiftnew")
    let releases = ReleaseNotesCounter([release])
    let sut = makeLoadTestView(
        releases: [],
        releaseLoader: { source, bundle in
            await releases.load(source: source, bundle: bundle)
        },
        lookup: { url in try await loader.load(url) }
    )
    sut.version = "1.0"
    sut.build = "1"

    await sut.runLoadTask(sut.loadTaskID)

    #expect(sut.availableUpdate?.version == "2.0")
    #expect(sut.availableUpdate?.appStoreURL == nil)
    #expect(sut.appStoreLookupErrorMessage?.isEmpty == false)

    sut.retryAppStoreLookup()
    await sut.runLoadTask(sut.loadTaskID)

    #expect(sut.availableUpdate?.appStoreURL == nil)
    #expect(sut.appStoreLookupErrorMessage?.isEmpty == false)
    #expect(sut.updateCheckPhase == .resolved)

    sut.retryAppStoreLookup()
    await sut.runLoadTask(sut.loadTaskID)

    #expect(sut.availableUpdate?.appStoreURL?.absoluteString == "https://apps.apple.com/app/id201")
    #expect(sut.appStoreLookupErrorMessage == nil)
    #expect(sut.appStoreLookupRetryRequest == nil)
    let releaseLoadCount = await releases.callCount
    let lookupCallCount = await loader.callCount
    #expect(releaseLoadCount == 1)
    #expect(lookupCallCount == 3)
}

@MainActor
@Test func releaseNoteFailureFinishesPreflightAndResolvesPendingPresentation() async {
    let show = LoadTestBox(false)
    let dependencies = makeLoadDependencies(
        releaseLoader: { _, _ in throw LoadTestError.releaseNotes },
        lookup: { _ in throw LoadTestError.unexpectedLookup }
    )
    let sut = SwiftNEW(
        data: loadTestSource,
        presentation: .sheet,
        checkForUpdates: true,
        appStoreBundleIdentifier: "com.example.swiftnew",
        showBinding: show.binding,
        loadDependencies: dependencies
    )
    sut.version = "1.0"
    sut.build = "1"
    sut.pendingSeenVersion = SwiftNEWVersionSnapshot(version: "1.0", build: "1")
    sut.hasPendingPresentation = true

    await sut.runLoadTask(sut.loadTaskID)

    #expect(sut.loading == false)
    #expect(sut.items.isEmpty)
    #expect(sut.availableUpdate == nil)
    #expect(sut.loadErrorMessage?.isEmpty == false)
    #expect(sut.loadedDataSource == loadTestSource)
    #expect(sut.loadedRequest == sut.loadRequest)
    #expect(sut.updateCheckPhase == .resolved)
    #expect(sut.hasPendingPresentation == false)
    #expect(sut.pendingSeenVersion == nil)
    #expect(show.value)
}

@MainActor
@Test func embeddedLocalSourceLoadsWithoutStartingUpdatePreflight() async {
    let release = makeLoadTestRelease(version: "1.0", title: "Local notes")
    let dependencies = makeLoadDependencies(
        releaseLoader: { _, _ in [release] },
        lookup: { _ in throw LoadTestError.unexpectedLookup }
    )
    let sut = SwiftNEW(
        data: "local-notes",
        presentation: .embed,
        loadDependencies: dependencies
    )
    sut.version = "1.0"
    sut.build = "1"
    #expect(sut.loadTaskID.shouldLoad)

    await sut.runLoadTask(sut.loadTaskID)

    #expect(sut.items == [release])
    #expect(sut.loadedDataSource == "local-notes")
    #expect(sut.updateCheckPhase == .inactive)
    #expect(sut.availableUpdate == nil)
    #expect(sut.appStoreLookupErrorMessage == nil)
}

@MainActor
@Test func compareVersionCommitsAndPresentsDeterministicLocalState() {
    let show = LoadTestBox(false)
    let sut = SwiftNEW(
        data: "local-notes",
        presentation: .sheet,
        showBinding: show.binding,
        loadDependencies: makeLoadDependencies(
            currentVersion: { "2.0" },
            currentBuild: { "20" }
        )
    )
    sut.version = "1.0"
    sut.build = "10"

    sut.compareVersion()

    #expect(show.value)
    #expect(sut.version == "2.0")
    #expect(sut.build == "20")
    #expect(sut.pendingSeenVersion == nil)
    #expect(sut.hasPendingPresentation == false)

    show.value = false
    sut.compareVersion()
    #expect(show.value == false)
}

@MainActor
@Test func resolvedRemotePreflightCommitsPendingVersionAndPresentsNotes() {
    let show = LoadTestBox(false)
    let sut = SwiftNEW(
        loadedDataSource: loadTestSource,
        updateCheckPhase: .resolved,
        data: loadTestSource,
        presentation: .sheet,
        checkForUpdates: true,
        appStoreBundleIdentifier: "com.example.swiftnew",
        showBinding: show.binding,
        loadDependencies: makeLoadDependencies(
            currentVersion: { "2.0" },
            currentBuild: { "20" }
        )
    )
    sut.version = "1.0"
    sut.build = "10"

    sut.compareVersion()

    #expect(show.value)
    #expect(sut.version == "2.0")
    #expect(sut.build == "20")
    #expect(sut.pendingSeenVersion == nil)
    #expect(sut.hasPendingPresentation == false)
}

@MainActor
@Test func remoteSourceWithoutUpdateOptInLoadsWithoutAppStoreLookup() async {
    let release = makeLoadTestRelease(version: "2.0", title: "Ordinary remote notes")
    let releaseLoads = ReleaseNotesCounter([release])
    let sut = SwiftNEW(
        data: loadTestSource,
        presentation: .embed,
        checkForUpdates: false,
        loadDependencies: makeLoadDependencies(
            releaseLoader: { source, bundle in
                await releaseLoads.load(source: source, bundle: bundle)
            },
            lookup: { _ in throw LoadTestError.unexpectedLookup }
        )
    )
    sut.version = "1.0"
    sut.build = "1"

    await sut.runLoadTask(sut.loadTaskID)

    let releaseLoadCount = await releaseLoads.callCount
    #expect(sut.items == [release])
    #expect(sut.availableUpdate == nil)
    #expect(sut.appStoreLookupErrorMessage == nil)
    #expect(sut.updateCheckPhase == .inactive)
    #expect(releaseLoadCount == 1)
}

@MainActor
@Test func emptyUSLookupResultPublishesRetryableUpdateWithoutRegionalRequest() async {
    let release = makeLoadTestRelease(version: "2.0", title: "No US listing")
    let lookup = EmptyLookupStub()
    let sut = makeLoadTestView(
        releases: [release],
        lookup: { url in try await lookup.load(url) },
        regionCode: { "US" }
    )
    sut.version = "1.0"
    sut.build = "1"

    await sut.runLoadTask(sut.loadTaskID)

    let lookupCallCount = await lookup.callCount
    #expect(sut.availableUpdate?.version == "2.0")
    #expect(sut.availableUpdate?.appStoreURL == nil)
    #expect(sut.appStoreLookupErrorMessage?.isEmpty == false)
    #expect(lookupCallCount == 1)
}

@MainActor
@Test func missingBundleIdentifierSkipsTheNetworkAndPublishesARetryableUpdate() async {
    let release = makeLoadTestRelease(version: "2.0", title: "Missing identifier")
    let lookup = EmptyLookupStub()
    let sut = SwiftNEW(
        data: loadTestSource,
        presentation: .embed,
        checkForUpdates: true,
        appStoreBundleIdentifier: nil,
        loadDependencies: makeLoadDependencies(
            releaseLoader: { _, _ in [release] },
            lookup: { url in try await lookup.load(url) },
            appStoreBundleIdentifier: { nil }
        )
    )
    sut.version = "1.0"
    sut.build = "1"

    await sut.runLoadTask(sut.loadTaskID)

    let lookupCallCount = await lookup.callCount
    #expect(sut.loadRequest.bundleIdentifier == nil)
    #expect(sut.availableUpdate?.version == "2.0")
    #expect(sut.availableUpdate?.appStoreURL == nil)
    #expect(sut.appStoreLookupErrorMessage?.isEmpty == false)
    #expect(lookupCallCount == 0)
}

@MainActor
@Test func failedReleaseNotesCanRetryWithoutTimingDependencies() async {
    let release = makeLoadTestRelease(version: "1.0", title: "Retried notes")
    let loader = RetryReleaseNotesStub(releases: [release])
    let dependencies = makeLoadDependencies(
        releaseLoader: { _, _ in try await loader.load() },
        lookup: { _ in throw LoadTestError.unexpectedLookup }
    )
    let sut = SwiftNEW(
        data: "local-notes",
        presentation: .embed,
        loadDependencies: dependencies
    )
    sut.version = "1.0"
    sut.build = "1"

    await sut.runLoadTask(sut.loadTaskID)
    #expect(sut.loadErrorMessage?.isEmpty == false)
    #expect(sut.items.isEmpty)

    sut.retryLoadData()
    await sut.runLoadTask(sut.loadTaskID)

    let callCount = await loader.callCount
    #expect(callCount == 2)
    #expect(sut.items == [release])
    #expect(sut.loadErrorMessage == nil)
    #expect(sut.loading == false)
}

@MainActor
@Test func hiddenLocalSourceDoesNotLoadUntilRequested() async {
    let calls = ReleaseNotesCounter([])
    let dependencies = makeLoadDependencies(
        releaseLoader: { source, bundle in
            await calls.load(source: source, bundle: bundle)
        }
    )
    let sut = SwiftNEW(
        data: "local-notes",
        presentation: .sheet,
        loadDependencies: dependencies
    )
    sut.version = "1.0"
    sut.build = "1"
    let taskID = sut.loadTaskID
    #expect(taskID.shouldLoad == false)

    await sut.runLoadTask(taskID)

    let callCount = await calls.callCount
    #expect(callCount == 0)
    #expect(sut.loadedRequest == nil)
    #expect(sut.updateCheckPhase == .inactive)
}

@MainActor
@Test func staleTaskIdentifierReturnsBeforeInvokingTheLoader() async {
    let firstSource = "https://example.com/first.json"
    let data = LoadTestBox(firstSource)
    let loads = ReleaseNotesCounter([])
    let sut = SwiftNEW(
        data: firstSource,
        presentation: .embed,
        dataBinding: data.binding,
        loadDependencies: makeLoadDependencies(
            releaseLoader: { source, bundle in
                await loads.load(source: source, bundle: bundle)
            }
        )
    )
    let staleTaskID = sut.loadTaskID
    data.value = "https://example.com/second.json"

    await sut.runLoadTask(staleTaskID)

    let loadCount = await loads.callCount
    #expect(loadCount == 0)
    #expect(sut.loadedRequest == nil)
}

@MainActor
@Test func alreadyLoadedRequestDoesNotInvokeLoaderAgain() async {
    let release = makeLoadTestRelease(version: "1.0", title: "Cached local notes")
    let calls = ReleaseNotesCounter([])
    let dependencies = makeLoadDependencies(
        releaseLoader: { source, bundle in
            await calls.load(source: source, bundle: bundle)
        }
    )
    let sut = SwiftNEW(
        items: [release],
        loading: false,
        loadedDataSource: "local-notes",
        data: "local-notes",
        presentation: .embed,
        loadDependencies: dependencies
    )
    sut.version = "1.0"
    sut.build = "1"
    let taskID = sut.loadTaskID
    #expect(taskID.shouldLoad)

    await sut.runLoadTask(taskID)

    let callCount = await calls.callCount
    #expect(callCount == 0)
    #expect(sut.items == [release])
    #expect(sut.loadedRequest == taskID.request)
}

@MainActor
@Test func staleReleaseNoteResponseCannotOverwriteNewerRequest() async throws {
    let firstSource = "https://example.com/first.json"
    let secondSource = "https://example.com/second.json"
    let firstRelease = makeLoadTestRelease(version: "1.0", title: "Stale")
    let secondRelease = makeLoadTestRelease(version: "1.0", title: "Current")
    let loader = SuspendedReleaseNotesLoader(
        suspendedSource: firstSource,
        suspendedResult: [firstRelease],
        immediateResult: [secondRelease]
    )
    let data = LoadTestBox(firstSource)
    let dependencies = makeLoadDependencies(
        releaseLoader: { source, _ in await loader.load(source: source) },
        lookup: { _ in throw LoadTestError.unexpectedLookup },
        currentVersion: { "1.0" }
    )
    let sut = SwiftNEW(
        data: firstSource,
        presentation: .sheet,
        checkForUpdates: true,
        appStoreBundleIdentifier: "com.example.swiftnew",
        dataBinding: data.binding,
        loadDependencies: dependencies
    )
    sut.version = "1.0"
    sut.build = "1"

    let firstTaskID = sut.loadTaskID
    let firstTask = Task { @MainActor in
        await sut.runLoadTask(firstTaskID)
    }
    try await loader.waitUntilSuspended()

    data.value = secondSource
    let secondTaskID = sut.loadTaskID
    await sut.runLoadTask(secondTaskID)
    await loader.resumeSuspendedRequest()
    await firstTask.value

    #expect(sut.items == [secondRelease])
    #expect(sut.loadedDataSource == secondSource)
    #expect(sut.loadedRequest == secondTaskID.request)
    #expect(sut.loadErrorMessage == nil)
}

@MainActor
@Test func cancelledLoadDoesNotPublishItsResponse() async throws {
    let source = "https://example.com/cancelled.json"
    let release = makeLoadTestRelease(version: "1.0", title: "Cancelled")
    let loader = SuspendedReleaseNotesLoader(
        suspendedSource: source,
        suspendedResult: [release],
        immediateResult: []
    )
    let dependencies = makeLoadDependencies(
        releaseLoader: { source, _ in await loader.load(source: source) },
        lookup: { _ in throw LoadTestError.unexpectedLookup },
        currentVersion: { "1.0" }
    )
    let sut = SwiftNEW(
        data: source,
        presentation: .sheet,
        checkForUpdates: true,
        appStoreBundleIdentifier: "com.example.swiftnew",
        loadDependencies: dependencies
    )
    sut.version = "1.0"
    sut.build = "1"

    let taskID = sut.loadTaskID
    let task = Task { @MainActor in
        await sut.runLoadTask(taskID)
    }
    try await loader.waitUntilSuspended()
    task.cancel()
    await loader.resumeSuspendedRequest()
    await task.value

    #expect(sut.items.isEmpty)
    #expect(sut.loadedRequest == nil)
    #expect(sut.availableUpdate == nil)
}

@MainActor
@Test func stateMachineTransitionsResetReloadFinishAndFailDeterministically() {
    let request = SwiftNEWLoadRequest(
        source: "data",
        checkForUpdates: false,
        bundleIdentifier: nil
    )
    let release = makeLoadTestRelease(version: "1.0", title: "Local")
    let machine = SwiftNEWLoadStateMachine(
        items: [release],
        loading: false,
        loadErrorMessage: "Old error",
        loadedDataSource: "old-data",
        availableUpdate: SwiftNEWUpdateCandidate(release: release, version: "1.0"),
        appStoreLookupErrorMessage: "Old lookup error",
        dependencies: makeLoadDependencies()
    )

    #expect(machine.resetIfRequestChanged(to: request))
    #expect(machine.resetIfRequestChanged(to: request) == false)
    #expect(machine.items.isEmpty)
    #expect(machine.loadedDataSource == nil)
    #expect(machine.availableUpdate == nil)
    #expect(machine.loadErrorMessage == nil)
    #expect(machine.appStoreLookupErrorMessage == nil)

    machine.requestReload()
    #expect(machine.forceLoadRequested)
    #expect(machine.loadedRequest == nil)

    let generation = machine.beginLoad(isUpdatePreflight: false)
    #expect(machine.loadGeneration == generation)
    #expect(machine.loading)
    #expect(machine.updateCheckPhase == .inactive)

    machine.finishLoad(
        items: [release],
        updateCandidate: nil,
        lookupErrorMessage: nil,
        request: request,
        isUpdatePreflight: false
    )
    #expect(machine.items == [release])
    #expect(machine.loading == false)
    #expect(machine.loadedRequest == request)
    #expect(machine.forceLoadRequested == false)

    _ = machine.beginLoad(isUpdatePreflight: true)
    machine.failLoad(
        request: request,
        isUpdatePreflight: true,
        message: "Unable to load release notes."
    )
    #expect(machine.loadErrorMessage == "Unable to load release notes.")
    #expect(machine.updateCheckPhase == .resolved)
}

@MainActor
@Test func presentationStateTracksSuppressionAndEmbedDismissal() {
    let show = LoadTestBox(false)
    let sut = makeLoadTestView(show: show, releases: [])
    sut.version = "1.0"
    sut.build = "1"

    sut.requestPresentationAfterPreflight()
    #expect(show.value)
    #expect(sut.hasPendingPresentation)

    show.value = false
    sut.handleShowChange(false)
    #expect(sut.hasPendingPresentation == false)
    #expect(sut.suppressedAutomaticUpdateRequests.contains(sut.loadRequest))

    sut.requestPresentationAfterPreflight()
    #expect(sut.suppressedAutomaticUpdateRequests.contains(sut.loadRequest) == false)
    #expect(sut.hasPendingPresentation)

    let candidate = SwiftNEWUpdateCandidate(
        release: makeLoadTestRelease(version: "2.0", title: "Embedded update"),
        version: "2.0"
    )
    let embedded = SwiftNEW(
        availableUpdate: candidate,
        updateCheckPhase: .resolved,
        data: loadTestSource,
        presentation: .embed,
        checkForUpdates: true,
        allowsSkippingUpdate: true,
        appStoreBundleIdentifier: "com.example.swiftnew",
        loadDependencies: makeLoadDependencies()
    )
    embedded.finishUpdatePresentation()
    #expect(embedded.availableUpdate == nil)
}

@MainActor
@Test func availableUpdateOpeningRequiresAResolvedAppStoreURL() throws {
    let openedURL = LoadTestBox<URL?>(nil)
    let unavailable = SwiftNEW(
        availableUpdate: SwiftNEWUpdateCandidate(
            release: makeLoadTestRelease(version: "2.0", title: "No URL"),
            version: "2.0"
        ),
        loadDependencies: makeLoadDependencies()
    )

    unavailable.openAvailableUpdate(using: { openedURL.value = $0 })
    #expect(openedURL.value == nil)

    let appStoreURL = try #require(URL(string: "https://apps.apple.com/app/id123"))
    let available = SwiftNEW(
        availableUpdate: SwiftNEWUpdateCandidate(
            release: makeLoadTestRelease(version: "2.0", title: "Installable"),
            version: "2.0",
            appStoreURL: appStoreURL
        ),
        loadDependencies: makeLoadDependencies()
    )

    available.openAvailableUpdate(using: { openedURL.value = $0 })
    #expect(openedURL.value == appStoreURL)
}

private let loadTestSource = "https://example.com/releases.json"

private enum LoadTestError: Error {
    case releaseNotes
    case unexpectedLookup
    case lookupUnavailable
    case timedOutWaitingForSuspension
}

@MainActor
private func makeLoadTestView(
    show: LoadTestBox<Bool>? = nil,
    releases: [Vmodel],
    releaseLoader: SwiftNEWLoadDependencies.ReleaseNotesLoader? = nil,
    lookup: @escaping SwiftNEWLoadDependencies.URLLoader = { _ in
        throw LoadTestError.unexpectedLookup
    },
    regionCode: @escaping SwiftNEWLoadDependencies.OptionalStringProvider = { "US" }
) -> SwiftNEW {
    let resolvedShow = show ?? LoadTestBox(false)
    return SwiftNEW(
        data: loadTestSource,
        presentation: .sheet,
        checkForUpdates: true,
        appStoreBundleIdentifier: "com.example.swiftnew",
        showBinding: resolvedShow.binding,
        loadDependencies: makeLoadDependencies(
            releaseLoader: releaseLoader ?? { _, _ in releases },
            lookup: lookup,
            regionCode: regionCode
        )
    )
}

private func makeLoadDependencies(
    releaseLoader: @escaping SwiftNEWLoadDependencies.ReleaseNotesLoader = { _, _ in [] },
    lookup: @escaping SwiftNEWLoadDependencies.URLLoader = { _ in
        throw LoadTestError.unexpectedLookup
    },
    regionCode: @escaping SwiftNEWLoadDependencies.OptionalStringProvider = { "US" },
    appStoreBundleIdentifier: @escaping SwiftNEWLoadDependencies.OptionalStringProvider = {
        "com.example.swiftnew"
    },
    currentVersion: @escaping SwiftNEWLoadDependencies.StringProvider = { "1.0" },
    currentBuild: @escaping SwiftNEWLoadDependencies.StringProvider = { "1" }
) -> SwiftNEWLoadDependencies {
    SwiftNEWLoadDependencies(
        loadReleaseNotes: releaseLoader,
        loadURL: lookup,
        regionCode: regionCode,
        appStoreBundleIdentifier: appStoreBundleIdentifier,
        currentVersion: currentVersion,
        currentBuild: currentBuild
    )
}

private func makeLoadTestRelease(version: String, title: String) -> Vmodel {
    Vmodel(
        version: version,
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

private func countryCode(in url: URL) -> String? {
    URLComponents(url: url, resolvingAgainstBaseURL: false)?
        .queryItems?
        .first(where: { $0.name == "country" })?
        .value
}

private func httpResponse(for url: URL, statusCode: Int = 200) throws -> HTTPURLResponse {
    try #require(
        HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
    )
}

private actor RegionalLookupStub {
    private let bundleIdentifier: String
    private(set) var requestedURLs: [URL] = []

    init(bundleIdentifier: String) {
        self.bundleIdentifier = bundleIdentifier
    }

    func load(_ url: URL) throws -> (Data, URLResponse) {
        requestedURLs.append(url)
        let data: Data
        if countryCode(in: url) == nil {
            data = Data(#"{"resultCount":0,"results":[]}"#.utf8)
        } else {
            data = Data(
                """
                {
                  "resultCount": 1,
                  "results": [
                    {
                      "bundleId": "\(bundleIdentifier)",
                      "trackViewUrl": "https://apps.apple.com/app/id200"
                    }
                  ]
                }
                """.utf8
            )
        }
        return (data, try httpResponse(for: url))
    }
}

private actor RetryLookupStub {
    private let bundleIdentifier: String
    private(set) var callCount = 0

    init(bundleIdentifier: String) {
        self.bundleIdentifier = bundleIdentifier
    }

    func load(_ url: URL) throws -> (Data, URLResponse) {
        callCount += 1
        if callCount == 1 {
            return (Data(), try httpResponse(for: url, statusCode: 503))
        }
        guard callCount >= 3 else { throw LoadTestError.lookupUnavailable }

        let data = Data(
            """
            {
              "resultCount": 1,
              "results": [
                {
                  "bundleId": "\(bundleIdentifier)",
                  "trackViewUrl": "https://apps.apple.com/app/id201"
                }
              ]
            }
            """.utf8
        )
        return (data, try httpResponse(for: url))
    }
}

private actor EmptyLookupStub {
    private(set) var callCount = 0

    func load(_ url: URL) throws -> (Data, URLResponse) {
        callCount += 1
        return (
            Data(#"{"resultCount":0,"results":[]}"#.utf8),
            try httpResponse(for: url)
        )
    }
}

private actor ReleaseNotesCounter {
    private let releases: [Vmodel]
    private(set) var callCount = 0

    init(_ releases: [Vmodel]) {
        self.releases = releases
    }

    func load(source: String, bundle: Bundle) -> [Vmodel] {
        _ = source
        _ = bundle
        callCount += 1
        return releases
    }
}

private actor RetryReleaseNotesStub {
    private let releases: [Vmodel]
    private(set) var callCount = 0

    init(releases: [Vmodel]) {
        self.releases = releases
    }

    func load() throws -> [Vmodel] {
        callCount += 1
        guard callCount > 1 else { throw LoadTestError.releaseNotes }
        return releases
    }
}

private actor SuspendedReleaseNotesLoader {
    private let suspendedSource: String
    private let suspendedResult: [Vmodel]
    private let immediateResult: [Vmodel]
    private var continuation: CheckedContinuation<[Vmodel], Never>?
    private var isSuspended = false

    init(
        suspendedSource: String,
        suspendedResult: [Vmodel],
        immediateResult: [Vmodel]
    ) {
        self.suspendedSource = suspendedSource
        self.suspendedResult = suspendedResult
        self.immediateResult = immediateResult
    }

    func load(source: String) async -> [Vmodel] {
        guard source == suspendedSource else { return immediateResult }
        return await withCheckedContinuation { continuation in
            isSuspended = true
            self.continuation = continuation
        }
    }

    func waitUntilSuspended() async throws {
        for _ in 0..<500 {
            if isSuspended {
                return
            }
            try await Task.sleep(nanoseconds: 10_000_000)
        }
        throw LoadTestError.timedOutWaitingForSuspension
    }

    func resumeSuspendedRequest() {
        continuation?.resume(returning: suspendedResult)
        continuation = nil
        isSuspended = false
    }
}

@MainActor
private final class LoadTestBox<Value> {
    var value: Value

    init(_ value: Value) {
        self.value = value
    }

    var binding: Binding<Value> {
        Binding(
            get: { self.value },
            set: { self.value = $0 }
        )
    }
}

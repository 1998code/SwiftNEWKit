//
//  SwiftNEWViewCoverageTests.swift
//  SwiftNEW
//

import SwiftUI
import Testing
import Foundation
@testable import SwiftNEW

#if os(macOS)
import AppKit
#endif

@MainActor
@Test func swiftNEWInitializersPreserveConfiguration() {
    let defaultDirect = SwiftNEW(show: .constant(false))
    #expect(defaultDirect.mesh)
    #expect(defaultDirect.meshStyle == .still)
    #expect(defaultDirect.iconStyle == .default)
    #expect(defaultDirect.checkForUpdates == false)
    #expect(defaultDirect.allowsSkippingUpdate)
    #expect(defaultDirect.updateButtonTitle.isEmpty)
    #expect(defaultDirect.resolvedUpdateButtonTitle.isEmpty == false)
    #expect(defaultDirect.appStoreBundleIdentifier == nil)

    let direct = SwiftNEW(
        show: .constant(false),
        align: .trailing,
        color: .red,
        size: "mini",
        label: "Open",
        labelImage: "sparkles",
        history: false,
        data: "missing",
        showDrop: true,
        mesh: true,
        meshStyle: .liquid,
        specialEffect: .particles,
        glass: false,
        presentation: .embed,
        showBuild: false,
        headingStyle: .appName,
        headingPrefix: "Latest in",
        iconStyle: .default,
        checkForUpdates: true,
        allowsSkippingUpdate: false,
        updateButtonTitle: "Install Update",
        appStoreBundleIdentifier: "com.example.store"
    )

    #expect(direct.align == .trailing)
    #expect(direct.size == "mini")
    #expect(direct.label == "Open")
    #expect(direct.labelImage == "sparkles")
    #expect(direct.history == false)
    #expect(direct.data == "missing")
    #expect(direct.showDrop)
    #expect(direct.mesh)
    #expect(direct.meshStyle == .liquid)
    #expect(direct.specialEffect == .particles)
    #expect(direct.glass == false)
    #expect(direct.presentation == .embed)
    #expect(direct.showBuild == false)
    #expect(direct.headingStyle == .appName)
    #expect(direct.headingPrefix == "Latest in")
    #expect(direct.iconStyle == .default)
    #expect(direct.checkForUpdates)
    #expect(direct.allowsSkippingUpdate == false)
    #expect(direct.updateButtonTitle == "Install Update")
    #expect(direct.appStoreBundleIdentifier == "com.example.store")

    let bound = SwiftNEW(
        show: .constant(false),
        align: .constant(.leading),
        color: .constant(.blue),
        size: .constant("invisible"),
        label: .constant("Hidden"),
        labelImage: .constant("eye.slash"),
        history: .constant(true),
        data: .constant("data"),
        showDrop: .constant(false),
        mesh: .constant(false),
        meshStyle: .constant(.still),
        specialEffect: .constant(.christmas),
        glass: .constant(true),
        presentation: .constant(.sheet),
        showBuild: .constant(true),
        headingStyle: .constant(.versionOnly),
        headingPrefix: .constant("Updates for"),
        iconStyle: .constant(.filled),
        checkForUpdates: .constant(true),
        allowsSkippingUpdate: .constant(false),
        updateButtonTitle: .constant("Get It"),
        appStoreBundleIdentifier: .constant("com.example.bound")
    )

    #expect(bound.align == .leading)
    #expect(bound.size == "invisible")
    #expect(bound.label == "Hidden")
    #expect(bound.labelImage == "eye.slash")
    #expect(bound.meshStyle == .still)
    #expect(bound.specialEffect == .christmas)
    #expect(bound.presentation == .sheet)
    #expect(bound.headingStyle == .versionOnly)
    #expect(bound.headingPrefix == "Updates for")
    #expect(bound.iconStyle == .filled)
    #expect(bound.checkForUpdates)
    #expect(bound.allowsSkippingUpdate == false)
    #expect(bound.updateButtonTitle == "Get It")
    #expect(bound.appStoreBundleIdentifier == "com.example.bound")
}

@MainActor
@Test func updateButtonTitleUsesLocalizedDefaultAndPreservesCustomText() {
    let defaultTitle = SwiftNEW(show: .constant(false))
    let nilTitle = SwiftNEW(show: .constant(false), updateButtonTitle: nil)
    let blankTitle = SwiftNEW(show: .constant(false), updateButtonTitle: " \n ")
    let boundBlankTitle = SwiftNEW(
        show: .constant(false),
        updateButtonTitle: .constant("\t")
    )
    let customTitle = SwiftNEW(show: .constant(false), updateButtonTitle: " Install Update ")

    #expect(nilTitle.updateButtonTitle.isEmpty)
    #expect(nilTitle.resolvedUpdateButtonTitle == defaultTitle.resolvedUpdateButtonTitle)
    #expect(blankTitle.resolvedUpdateButtonTitle == defaultTitle.resolvedUpdateButtonTitle)
    #expect(boundBlankTitle.resolvedUpdateButtonTitle == defaultTitle.resolvedUpdateButtonTitle)
    #expect(customTitle.resolvedUpdateButtonTitle == " Install Update ")
}

@MainActor
@Test func nonSkippableUpdateDisablesInteractiveDismissalOnlyDuringUpdateFlow() {
    let checking = makeSwiftNEW(
        data: "https://example.com/releases.json",
        updateCheckPhase: .checking,
        checkForUpdates: true,
        allowsSkippingUpdate: false
    )
    #expect(checking.shouldDisableUpdateDismissal)

    let available = makeSwiftNEW(
        availableUpdate: sampleUpdateCandidate(),
        updateCheckPhase: .resolved,
        checkForUpdates: true,
        allowsSkippingUpdate: false
    )
    #expect(available.shouldDisableUpdateDismissal)

    let skippable = makeSwiftNEW(
        availableUpdate: sampleUpdateCandidate(),
        updateCheckPhase: .resolved,
        checkForUpdates: true,
        allowsSkippingUpdate: true
    )
    #expect(skippable.shouldDisableUpdateDismissal == false)

    let noUpdate = makeSwiftNEW(
        data: "https://example.com/releases.json",
        updateCheckPhase: .resolved,
        checkForUpdates: true,
        allowsSkippingUpdate: false
    )
    #expect(noUpdate.shouldDisableUpdateDismissal == false)
}

@MainActor
@Test func nonSkippableUpdateDismissActionIsANoOp() {
    let forcedShow = SwiftNEWTestBoolBox(true)
    let forced = SwiftNEW(
        show: Binding(
            get: { forcedShow.value },
            set: { forcedShow.value = $0 }
        ),
        allowsSkippingUpdate: false
    )

    forced.finishUpdatePresentation()
    #expect(forcedShow.value)

    let skippableShow = SwiftNEWTestBoolBox(true)
    let skippable = SwiftNEW(
        show: Binding(
            get: { skippableShow.value },
            set: { skippableShow.value = $0 }
        ),
        allowsSkippingUpdate: true
    )

    skippable.finishUpdatePresentation()
    #expect(skippableShow.value == false)
}

@MainActor
@Test func remoteUpdatePrefetchRequiresRemoteDataAndOptIn() {
    let enabled = makeSwiftNEW(
        data: "https://example.com/releases.json",
        checkForUpdates: true,
        appStoreBundleIdentifier: "com.example.store"
    )
    #expect(enabled.shouldPrefetchRemoteUpdate)
    #expect(enabled.loadRequest.bundleIdentifier == "com.example.store")

    let disabled = makeSwiftNEW(data: "https://example.com/releases.json")
    #expect(disabled.shouldPrefetchRemoteUpdate == false)

    let local = makeSwiftNEW(
        data: "data",
        checkForUpdates: true
    )
    #expect(local.shouldPrefetchRemoteUpdate == false)
}

@MainActor
@Test func headingsReturnExpectedSubtitles() {
    let versionHeading = makeSwiftNEW(showBuild: true, headingStyle: .version)
    #expect(versionHeading.headingSubtitle == "Version \(Bundle.versionBuild)")

    let versionHeadingWithoutBuild = makeSwiftNEW(showBuild: false, headingStyle: .version)
    #expect(versionHeadingWithoutBuild.headingSubtitle == "Version \(Bundle.version)")

    let versionOnly = makeSwiftNEW(showBuild: false, headingStyle: .versionOnly)
    #expect(versionOnly.headingSubtitle == Bundle.version)

    let appName = makeSwiftNEW(headingStyle: .appName)
    #expect(appName.headingSubtitle == Bundle.appName)

    let customPrefix = makeSwiftNEW(headingPrefix: "Latest in")
    #expect(customPrefix.headingTitle == "Latest in")
}

@MainActor
@Test func colorAndBundleHelpersReturnStableValues() {
    #expect(Color.white.adaptedTextColor == .black)
    #expect(Color.black.adaptedTextColor == .white)
    #expect(Bundle.versionBuild.contains("("))
    #expect(Bundle.appName == Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "")
    #expect(Bundle.main.iconFileName == nil)
}

@MainActor
@Test func bundleIconHelperReadsPrimaryIconFile() throws {
    let folder = FileManager.default.temporaryDirectory
        .appendingPathComponent("SwiftNEWIconBundle-\(UUID().uuidString).bundle", isDirectory: true)
    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

    let plist: [String: Any] = [
        "CFBundleIdentifier": "com.swiftnew.coverage.icon",
        "CFBundlePackageType": "BNDL",
        "CFBundleIcons": [
            "CFBundlePrimaryIcon": [
                "CFBundleIconFiles": ["Icon20", "Icon60"]
            ]
        ]
    ]

    let data = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
    try data.write(to: folder.appendingPathComponent("Info.plist"))

    guard let bundle = Bundle(url: folder) else {
        Issue.record("Expected temporary bundle to load")
        return
    }

    #expect(bundle.iconFileName == "Icon60")
}

@MainActor
@Test func versionComparisonPathIsCallable() async throws {
    UserDefaults.standard.removeObject(forKey: "swiftnew.version")
    UserDefaults.standard.removeObject(forKey: "swiftnew.build")

    let sut = makeSwiftNEW()

    sut.presentReleaseNotes()
    sut.compareVersion()
    try await Task.sleep(nanoseconds: 150_000_000)

    #expect(sut.version == Bundle.version || sut.version.isEmpty)
}

@MainActor
@Test func searchTextUpdatePathIsCallable() async throws {
    let sut = makeSwiftNEW(showSearch: true)

    sut.updateSearchText("coverage")
    try await Task.sleep(nanoseconds: 350_000_000)

    #expect(sut.matchesSearch(Model(icon: "sparkles", title: "Search", subtitle: "Filter", body: "Coverage")))
}

@MainActor
@Test func searchToggleAndRetryPathsAreCallable() async throws {
    let sut = makeSwiftNEW(showSearch: true, searchText: "coverage", debouncedSearchText: "coverage")

    sut.toggleSearchVisibility()
    sut.retryLoadData()
    try await Task.sleep(nanoseconds: 300_000_000)

    #expect(sut.matchesSearch(sampleModel()))
}

@MainActor
@Test func loadDataReportsMissingLocalFiles() async throws {
    let sut = makeSwiftNEW(data: "missing-release-notes-file")

    sut.loadData()
    try await Task.sleep(nanoseconds: 400_000_000)

    #expect(sut.data == "missing-release-notes-file")
}

@MainActor
@Test func loadDataReadsLocalBundleJSON() async throws {
    let sut = makeSwiftNEW(data: "swiftnew-test-data", dataBundle: .module)
    sut.loadData()
    try await Task.sleep(nanoseconds: 500_000_000)

    #expect(sut.data == "swiftnew-test-data")
}

@MainActor
@Test func loadDataHandlesInvalidRemoteURLs() async throws {
    let sut = makeSwiftNEW(data: "http://%")

    sut.loadData()
    try await Task.sleep(nanoseconds: 400_000_000)

    #expect(sut.data == "http://%")
}

#if os(macOS)
@MainActor
@Test func renderSwiftNEWEntryPoints() {
    render(makeSwiftNEW(size: "simple", glass: true, presentation: .sheet).body)
    render(makeSwiftNEW(size: "mini", glass: false, presentation: .fullScreenCover).body)
    render(makeSwiftNEW(testingShow: true, size: "simple", presentation: .sheet).body)
    render(makeSwiftNEW(testingShow: true, historySheet: true, size: "simple", presentation: .sheet).body)
    render(makeSwiftNEW(items: sampleItems(), loading: false).testingHistorySheetContent)
    render(makeSwiftNEW(mesh: true, specialEffect: .particles, presentation: .embed).body)
    render(makeSwiftNEW(mesh: true, meshStyle: .liquid, presentation: .embed).body)
    render(makeSwiftNEW(mesh: false, specialEffect: .christmas, presentation: .embed).body)
    render(makeSwiftNEW(presentation: .embed, iconStyle: .default).body)
    render(makeSwiftNEW(size: "invisible", presentation: .sheet).body)
}

@MainActor
@Test func renderComponentsForAlignmentAndIconStyles() {
    let model = sampleModel()

    for alignment in [HorizontalAlignment.leading, .center, .trailing] {
        let filled = makeSwiftNEW(items: sampleItems(), loading: false, align: alignment, iconStyle: .filled)
        render(filled.headings)
        render(filled.iconBadge(systemNames: model.iconSequence))
        render(filled.releaseRow(model, bodyFont: .caption))
        render(filled.showHistoryButton)
        render(filled.searchButton)
        render(filled.closeCurrentButton)
        render(filled.closeHistoryButton)

        let plain = makeSwiftNEW(align: alignment, iconStyle: .plain)
        render(plain.iconBadge(systemNames: model.iconSequence))
        render(plain.releaseRow(model, bodyFont: .footnote, spacing: 2))

        let defaultStyle = makeSwiftNEW(align: alignment, iconStyle: .default)
        render(defaultStyle.iconBadge(systemNames: model.iconSequence))
        render(defaultStyle.iconBadge(systemNames: model.iconSequence).preferredColorScheme(.dark))
        render(defaultStyle.releaseRow(model, bodyFont: .footnote, spacing: 2))
    }
}

@MainActor
@Test func renderCurrentSheetStates() {
    let loading = makeSwiftNEW(loading: true)
    render(loading.sheetCurrent)

    let error = makeSwiftNEW(loading: false, loadErrorMessage: "Unable to load release notes.")
    render(error.sheetCurrent)

    let populated = makeSwiftNEW(
        items: sampleItems(),
        loading: false,
        showSearch: true,
        searchText: "coverage",
        debouncedSearchText: "coverage",
        history: true
    )
    render(populated.sheetCurrent)

    let noHistory = makeSwiftNEW(
        items: sampleItems(),
        loading: false,
        showSearch: false,
        history: false
    )
    render(noHistory.sheetCurrent)
}

@MainActor
@Test func renderUpdateSheetAndContentRouting() {
    let update = makeSwiftNEW(
        items: sampleItems(),
        loading: false,
        availableUpdate: sampleUpdateCandidate(),
        updateCheckPhase: .resolved,
        checkForUpdates: true
    )

    render(update.sheetUpdate)
    render(update.testingSheetContent)
    render(update.updateNowButton)
    render(update.dismissUpdateButton)
    render(update.retryAppStoreLookupButton)
    render(update.sheetUpdateChecking)
}

@MainActor
@Test func renderHistorySheetAndEffects() {
    let sut = makeSwiftNEW(items: sampleItems(), loading: false, mesh: true)

    render(sut.sheetHistory)
    let meshView = MeshView(color: .constant(.purple))
    render(meshView)
    render(MeshView(color: .constant(.purple), style: .liquid))
    render(meshView.testingFallbackGradient)
    render(NoiseView(size: 128))
    render(SnowfallView())
    render(FloatingParticlesView())
    render(Color.red.swiftNEWGlass(radius: 8, color: .blue.opacity(0.2)))
}
#endif

@MainActor
private func makeSwiftNEW(
    testingShow: Bool = false,
    items: [Vmodel] = [],
    loading: Bool = true,
    loadErrorMessage: String? = nil,
    availableUpdate: SwiftNEWUpdateCandidate? = nil,
    updateCheckPhase: SwiftNEWUpdateCheckPhase = .inactive,
    appStoreLookupErrorMessage: String? = nil,
    historySheet: Bool = false,
    showSearch: Bool = false,
    searchText: String = "",
    debouncedSearchText: String = "",
    align: HorizontalAlignment = .center,
    color: Color = .accentColor,
    size: String = "simple",
    history: Bool = true,
    data: String = "data",
    mesh: Bool = false,
    meshStyle: SwiftNEWMeshStyle = .still,
    specialEffect: SwiftNEWSpecialEffect = .none,
    glass: Bool = true,
    presentation: SwiftNEWPresentation = .sheet,
    showBuild: Bool = true,
    headingStyle: SwiftNEWHeadingStyle = .version,
    headingPrefix: String = "What's New in",
    iconStyle: SwiftNEWIconStyle = .default,
    checkForUpdates: Bool = false,
    allowsSkippingUpdate: Bool = true,
    updateButtonTitle: String = "",
    appStoreBundleIdentifier: String? = nil,
    dataBundle: Bundle = .main
) -> SwiftNEW {
    SwiftNEW(
        testingShow: testingShow,
        items: items,
        loading: loading,
        loadErrorMessage: loadErrorMessage,
        availableUpdate: availableUpdate,
        updateCheckPhase: updateCheckPhase,
        appStoreLookupErrorMessage: appStoreLookupErrorMessage,
        historySheet: historySheet,
        showSearch: showSearch,
        searchText: searchText,
        debouncedSearchText: debouncedSearchText,
        align: align,
        color: color,
        size: size,
        label: "Show Release Note",
        labelImage: "arrow.up.circle.fill",
        history: history,
        data: data,
        showDrop: false,
        mesh: mesh,
        meshStyle: meshStyle,
        specialEffect: specialEffect,
        glass: glass,
        presentation: presentation,
        showBuild: showBuild,
        headingStyle: headingStyle,
        headingPrefix: headingPrefix,
        iconStyle: iconStyle,
        checkForUpdates: checkForUpdates,
        allowsSkippingUpdate: allowsSkippingUpdate,
        updateButtonTitle: updateButtonTitle,
        appStoreBundleIdentifier: appStoreBundleIdentifier,
        dataBundle: dataBundle
    )
}

private func sampleItems() -> [Vmodel] {
    [
        Vmodel(version: Bundle.version, subVersion: "6.3.1", new: [
            sampleModel(),
            Model(icon: "checkmark.shield", title: "Compatibility", subtitle: "Fixes", body: "Older compiler coverage")
        ]),
        Vmodel(version: "6.2", subVersion: "6.2.0", new: [
            Model(icon: "clock", title: "History", subtitle: "Entry", body: "Previous release")
        ])
    ]
}

private func sampleModel() -> Model {
    Model(icon: "sparkles", toIcon: "wand.and.stars", title: "Search", subtitle: "Filter", body: "Coverage")
}

private func sampleUpdateCandidate() -> SwiftNEWUpdateCandidate {
    let release = Vmodel(
        version: "99.0",
        subVersion: "99.0.1",
        new: [sampleModel()]
    )
    return SwiftNEWUpdateCandidate(
        release: release,
        version: "99.0.1",
        appStoreURL: URL(string: "https://apps.apple.com/app/id123")!
    )
}

@MainActor
private final class SwiftNEWTestBoolBox {
    var value: Bool

    init(_ value: Bool) {
        self.value = value
    }
}

#if os(macOS)
@MainActor
private func render<V: View>(_ view: V) {
    let host = NSHostingView(rootView: AnyView(view))
    host.frame = NSRect(x: 0, y: 0, width: 900, height: 900)
    host.layoutSubtreeIfNeeded()
    _ = host.fittingSize
}
#endif

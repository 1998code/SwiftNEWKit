//
//  SwiftNEW.swift
//  SwiftNEW
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftVB

#if os(iOS)
import Drops
#endif

// Setup presentation type of the SwiftNEW view
public enum SwiftNEWPresentation {
    case sheet
    case fullScreenCover
    case embed
}

// Special Effect (e.g. Christmas snow)
public enum SwiftNEWSpecialEffect {
    case none
    case christmas
    case particles
}

// Heading subtitle style — controls the second line under "What's New in"
public enum SwiftNEWHeadingStyle {
    case version       // "Version 6.4" / "Version 6.4 (19)"
    case versionOnly   // "6.4" / "6.4 (19)"
    case appName       // "{App Name}"
}

// Icon style for each release-note row
public enum SwiftNEWIconStyle {
    case filled     // colored backdrop, white glyph
    case `default` // adaptive translucent backdrop, adaptive glyph (default)
    case plain      // no backdrop, adaptive glyph
}

// Mesh gradient behavior
public enum SwiftNEWMeshStyle: Equatable {
    case still
    case liquid
}

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
public struct SwiftNEW: View {
    @AppStorage("swiftnew.version") var version = ""
    @AppStorage("swiftnew.build") var build = ""
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) var openURL

    @StateObject private var loadStateMachineStorage: SwiftNEWLoadStateMachine
    #if DEBUG
    private let testingLoadStateMachineStorage: SwiftNEWLoadStateMachine?
    private let testingColorSchemeOverride: ColorScheme?
    #endif

    @Binding var show: Bool
    @Binding var align: HorizontalAlignment
    @Binding var color: Color
    @Binding var size: String
    @Binding var label: String
    @Binding var labelImage: String
    @Binding var history: Bool
    @Binding var search: Bool
    @Binding var data: String
    @Binding var showDrop: Bool
    @Binding var mesh: Bool
    @Binding var meshStyle: SwiftNEWMeshStyle
    @Binding var specialEffect: SwiftNEWSpecialEffect
    @Binding var glass: Bool
    @Binding var buttonCornerRadius: CGFloat
    @Binding var buttonTextColor: Color?
    @Binding var presentation: SwiftNEWPresentation
    @Binding var showBuild: Bool
    @Binding var showDescription: Bool
    @Binding var headingStyle: SwiftNEWHeadingStyle
    @Binding var headingPrefix: String
    @Binding var iconStyle: SwiftNEWIconStyle
    @Binding var appIconName: String?
    @Binding var alternateAppIconName: String?
    @Binding var checkForUpdates: Bool
    @Binding var allowsSkippingUpdate: Bool
    @Binding var updateButtonTitle: String
    @Binding var appStoreBundleIdentifier: String?
    var dataBundle: Bundle = .main

    var loadStateMachine: SwiftNEWLoadStateMachine {
        #if DEBUG
        if let testingLoadStateMachineStorage {
            return testingLoadStateMachineStorage
        }
        #endif
        return loadStateMachineStorage
    }

    var resolvedColorScheme: ColorScheme {
        #if DEBUG
        if let testingColorSchemeOverride {
            return testingColorSchemeOverride
        }
        #endif
        return colorScheme
    }

    var items: [Vmodel] {
        get { loadStateMachine.items }
        nonmutating set { loadStateMachine.items = newValue }
    }

    var loading: Bool {
        get { loadStateMachine.loading }
        nonmutating set { loadStateMachine.loading = newValue }
    }

    var loadErrorMessage: String? {
        get { loadStateMachine.loadErrorMessage }
        nonmutating set { loadStateMachine.loadErrorMessage = newValue }
    }

    var loadedDataSource: String? {
        get { loadStateMachine.loadedDataSource }
        nonmutating set { loadStateMachine.loadedDataSource = newValue }
    }

    var loadedRequest: SwiftNEWLoadRequest? {
        get { loadStateMachine.loadedRequest }
        nonmutating set { loadStateMachine.loadedRequest = newValue }
    }

    var loadGeneration: UUID? {
        get { loadStateMachine.loadGeneration }
        nonmutating set { loadStateMachine.loadGeneration = newValue }
    }

    var reloadID: UUID {
        get { loadStateMachine.reloadID }
        nonmutating set { loadStateMachine.reloadID = newValue }
    }

    var forceLoadRequested: Bool {
        get { loadStateMachine.forceLoadRequested }
        nonmutating set { loadStateMachine.forceLoadRequested = newValue }
    }

    var availableUpdate: SwiftNEWUpdateCandidate? {
        get { loadStateMachine.availableUpdate }
        nonmutating set { loadStateMachine.availableUpdate = newValue }
    }

    var updateCheckPhase: SwiftNEWUpdateCheckPhase {
        get { loadStateMachine.updateCheckPhase }
        nonmutating set { loadStateMachine.updateCheckPhase = newValue }
    }

    var pendingSeenVersion: SwiftNEWVersionSnapshot? {
        get { loadStateMachine.pendingSeenVersion }
        nonmutating set { loadStateMachine.pendingSeenVersion = newValue }
    }

    var hasPendingPresentation: Bool {
        get { loadStateMachine.hasPendingPresentation }
        nonmutating set { loadStateMachine.hasPendingPresentation = newValue }
    }

    var suppressedAutomaticUpdateRequests: Set<SwiftNEWLoadRequest> {
        get { loadStateMachine.suppressedAutomaticUpdateRequests }
        nonmutating set { loadStateMachine.suppressedAutomaticUpdateRequests = newValue }
    }

    var appStoreLookupErrorMessage: String? {
        get { loadStateMachine.appStoreLookupErrorMessage }
        nonmutating set { loadStateMachine.appStoreLookupErrorMessage = newValue }
    }

    var appStoreLookupRetryRequest: SwiftNEWLoadRequest? {
        get { loadStateMachine.appStoreLookupRetryRequest }
        nonmutating set { loadStateMachine.appStoreLookupRetryRequest = newValue }
    }

    var historySheet: Bool {
        get { loadStateMachine.historySheet }
        nonmutating set { loadStateMachine.historySheet = newValue }
    }

    var historySheetBinding: Binding<Bool> {
        Binding(
            get: { historySheet },
            set: { historySheet = $0 }
        )
    }

    var showSearch: Bool {
        get { loadStateMachine.showSearch }
        nonmutating set { loadStateMachine.showSearch = newValue }
    }

    var searchText: String {
        get { loadStateMachine.searchText }
        nonmutating set { loadStateMachine.searchText = newValue }
    }

    var debouncedSearchText: String {
        get { loadStateMachine.debouncedSearchText }
        nonmutating set { loadStateMachine.debouncedSearchText = newValue }
    }

    #if os(iOS)
    var activeDropEpoch: UUID? {
        get { loadStateMachine.activeDropEpoch }
        nonmutating set { loadStateMachine.activeDropEpoch = newValue }
    }
    #endif

    var loadDependencies: SwiftNEWLoadDependencies {
        loadStateMachine.dependencies
    }

    static var defaultButtonCornerRadius: CGFloat {
        #if os(watchOS)
        12
        #elseif os(macOS)
        12
        #else
        20
        #endif
    }

    static var defaultShowDescription: Bool {
        #if os(watchOS)
        false
        #else
        true
        #endif
    }

    static var defaultSearchEnabled: Bool {
        #if os(watchOS)
        false
        #else
        true
        #endif
    }

    public init(
        show: Binding<Bool>,
        align: HorizontalAlignment? = .center,
        color: Color? = .accentColor,
        size: String? = "simple",
        label: String? = "Show Release Note",
        labelImage: String? = "arrow.up.circle.fill",
        history: Bool? = true,
        search: Bool? = nil,
        data: String? = "data",
        showDrop: Bool? = false,
        mesh: Bool? = true,
        meshStyle: SwiftNEWMeshStyle? = .still,
        specialEffect: SwiftNEWSpecialEffect? = SwiftNEWSpecialEffect.none,
        glass: Bool? = true,
        buttonCornerRadius: CGFloat? = nil,
        buttonTextColor: Color? = nil,
        presentation: SwiftNEWPresentation? = .sheet,
        showBuild: Bool? = true,
        showDescription: Bool? = nil,
        headingStyle: SwiftNEWHeadingStyle? = .version,
        headingPrefix: String? = "What's New in",
        iconStyle: SwiftNEWIconStyle? = .default,
        appIconName: String? = nil,
        alternateAppIconName: String? = nil,
        checkForUpdates: Bool? = false,
        allowsSkippingUpdate: Bool? = true,
        updateButtonTitle: String? = nil,
        appStoreBundleIdentifier: String? = nil
    ) {
        let loadStateMachine = SwiftNEWLoadStateMachine()
        _loadStateMachineStorage = StateObject(wrappedValue: loadStateMachine)
        #if DEBUG
        testingLoadStateMachineStorage = nil
        testingColorSchemeOverride = nil
        #endif
        _show = show
        _align = .constant(align ?? .center)
        _color = .constant(color ?? Color.accentColor)
        _size = .constant(size ?? "simple")
        _label = .constant(label ?? "Show Release Note")
        _labelImage = .constant(labelImage ?? "arrow.up.circle.fill")
        _history = .constant(history ?? true)
        _search = .constant(search ?? Self.defaultSearchEnabled)
        _data = .constant(data ?? "data")
        _showDrop = .constant(showDrop ?? false)
        _mesh = .constant(mesh ?? true)
        _meshStyle = .constant(meshStyle ?? .still)
        _specialEffect = .constant(specialEffect ?? .none)
        _glass = .constant(glass ?? true)
        _buttonCornerRadius = .constant(buttonCornerRadius ?? Self.defaultButtonCornerRadius)
        _buttonTextColor = .constant(buttonTextColor)
        _presentation = .constant(presentation ?? .sheet)
        _showBuild = .constant(showBuild ?? true)
        _showDescription = .constant(showDescription ?? Self.defaultShowDescription)
        _headingStyle = .constant(headingStyle ?? .version)
        _headingPrefix = .constant(headingPrefix ?? "What's New in")
        _iconStyle = .constant(iconStyle ?? .default)
        _appIconName = .constant(appIconName)
        _alternateAppIconName = .constant(alternateAppIconName)
        _checkForUpdates = .constant(checkForUpdates ?? false)
        _allowsSkippingUpdate = .constant(allowsSkippingUpdate ?? true)
        _updateButtonTitle = .constant(updateButtonTitle ?? "")
        _appStoreBundleIdentifier = .constant(appStoreBundleIdentifier)
    }

    @_disfavoredOverload
    public init(
        show: Binding<Bool>,
        align: Binding<HorizontalAlignment>? = .constant(.center),
        color: Binding<Color>? = .constant(Color.accentColor),
        size: Binding<String>? = .constant("simple"),
        label: Binding<String>? = .constant("Show Release Note"),
        labelImage: Binding<String>? = .constant("arrow.up.circle.fill"),
        history: Binding<Bool>? = .constant(true),
        search: Binding<Bool>? = nil,
        data: Binding<String>? = .constant("data"),
        showDrop: Binding<Bool>? = .constant(false),
        mesh: Binding<Bool>? = .constant(true),
        meshStyle: Binding<SwiftNEWMeshStyle>? = .constant(.still),
        specialEffect: Binding<SwiftNEWSpecialEffect>? = .constant(.none),
        glass: Binding<Bool>? = .constant(true),
        buttonCornerRadius: Binding<CGFloat>? = nil,
        buttonTextColor: Binding<Color?>? = .constant(nil),
        presentation: Binding<SwiftNEWPresentation>? = .constant(.sheet),
        showBuild: Binding<Bool>? = .constant(true),
        showDescription: Binding<Bool>? = nil,
        headingStyle: Binding<SwiftNEWHeadingStyle>? = .constant(.version),
        headingPrefix: Binding<String>? = .constant("What's New in"),
        iconStyle: Binding<SwiftNEWIconStyle>? = .constant(.default),
        appIconName: Binding<String?>? = .constant(nil),
        alternateAppIconName: Binding<String?>? = .constant(nil),
        checkForUpdates: Binding<Bool>? = .constant(false),
        allowsSkippingUpdate: Binding<Bool>? = .constant(true),
        updateButtonTitle: Binding<String>? = nil,
        appStoreBundleIdentifier: Binding<String?>? = .constant(nil)
    ) {
        let loadStateMachine = SwiftNEWLoadStateMachine()
        _loadStateMachineStorage = StateObject(wrappedValue: loadStateMachine)
        #if DEBUG
        testingLoadStateMachineStorage = nil
        testingColorSchemeOverride = nil
        #endif
        _show = show
        _align = align ?? .constant(.center)
        _color = color ?? .constant(Color.accentColor)
        _size = size ?? .constant("simple")
        _label = label ?? .constant("Show Release Note")
        _labelImage = labelImage ?? .constant("arrow.up.circle.fill")
        _history = history ?? .constant(true)
        _search = search ?? .constant(Self.defaultSearchEnabled)
        _data = data ?? .constant("data")
        _showDrop = showDrop ?? .constant(false)
        _mesh = mesh ?? .constant(true)
        _meshStyle = meshStyle ?? .constant(.still)
        _specialEffect = specialEffect ?? .constant(.none)
        _glass = glass ?? .constant(true)
        _buttonCornerRadius = buttonCornerRadius ?? .constant(Self.defaultButtonCornerRadius)
        _buttonTextColor = buttonTextColor ?? .constant(nil)
        _presentation = presentation ?? .constant(.sheet)
        _showBuild = showBuild ?? .constant(true)
        _showDescription = showDescription ?? .constant(Self.defaultShowDescription)
        _headingStyle = headingStyle ?? .constant(.version)
        _headingPrefix = headingPrefix ?? .constant("What's New in")
        _iconStyle = iconStyle ?? .constant(.default)
        _appIconName = appIconName ?? .constant(nil)
        _alternateAppIconName = alternateAppIconName ?? .constant(nil)
        _checkForUpdates = checkForUpdates ?? .constant(false)
        _allowsSkippingUpdate = allowsSkippingUpdate ?? .constant(true)
        _updateButtonTitle = updateButtonTitle ?? .constant("")
        _appStoreBundleIdentifier = appStoreBundleIdentifier ?? .constant(nil)
    }
}

#if DEBUG
@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {
    init(
        testingShow: Bool = false,
        items: [Vmodel] = [],
        loading: Bool = true,
        loadErrorMessage: String? = nil,
        loadedDataSource: String? = nil,
        availableUpdate: SwiftNEWUpdateCandidate? = nil,
        updateCheckPhase: SwiftNEWUpdateCheckPhase = .inactive,
        appStoreLookupErrorMessage: String? = nil,
        pendingSeenVersion: SwiftNEWVersionSnapshot? = nil,
        hasPendingPresentation: Bool = false,
        suppressedAutomaticUpdateRequests: Set<SwiftNEWLoadRequest> = [],
        historySheet: Bool = false,
        showSearch: Bool = false,
        searchText: String = "",
        debouncedSearchText: String = "",
        align: HorizontalAlignment = .center,
        color: Color = .accentColor,
        size: String = "simple",
        label: String = "Show Release Note",
        labelImage: String = "arrow.up.circle.fill",
        history: Bool = true,
        search: Bool? = nil,
        data: String = "data",
        showDrop: Bool = false,
        mesh: Bool = true,
        meshStyle: SwiftNEWMeshStyle = .still,
        specialEffect: SwiftNEWSpecialEffect = .none,
        glass: Bool = true,
        buttonCornerRadius: CGFloat? = nil,
        buttonTextColor: Color? = nil,
        presentation: SwiftNEWPresentation = .sheet,
        showBuild: Bool = true,
        showDescription: Bool? = nil,
        headingStyle: SwiftNEWHeadingStyle = .version,
        headingPrefix: String = "What's New in",
        iconStyle: SwiftNEWIconStyle = .default,
        appIconName: String? = nil,
        alternateAppIconName: String? = nil,
        checkForUpdates: Bool = false,
        allowsSkippingUpdate: Bool = true,
        updateButtonTitle: String = "",
        appStoreBundleIdentifier: String? = nil,
        dataBundle: Bundle = .main,
        showBinding: Binding<Bool>? = nil,
        dataBinding: Binding<String>? = nil,
        testingColorScheme: ColorScheme = .light,
        loadDependencies: SwiftNEWLoadDependencies = .live
    ) {
        let configuredBundleIdentifier = appStoreBundleIdentifier?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let initialLoadedRequest = loadedDataSource.map { loadedSource in
            let needsAppStoreBundleIdentifier = checkForUpdates
                && SwiftNEWRemoteSource.url(from: loadedSource) != nil
            let resolvedBundleIdentifier = needsAppStoreBundleIdentifier
                ? (configuredBundleIdentifier?.isEmpty == false
                    ? configuredBundleIdentifier
                    : loadDependencies.appStoreBundleIdentifier())
                : nil

            return SwiftNEWLoadRequest(
                source: loadedSource,
                checkForUpdates: checkForUpdates,
                bundleIdentifier: resolvedBundleIdentifier
            )
        }

        _version = AppStorage(wrappedValue: "", "swiftnew.version")
        _build = AppStorage(wrappedValue: "", "swiftnew.build")
        let loadStateMachine = SwiftNEWLoadStateMachine(
            items: items,
            loading: loading,
            loadErrorMessage: loadErrorMessage,
            loadedDataSource: loadedDataSource,
            loadedRequest: initialLoadedRequest,
            currentLoadRequest: initialLoadedRequest,
            availableUpdate: availableUpdate,
            updateCheckPhase: updateCheckPhase,
            pendingSeenVersion: pendingSeenVersion,
            hasPendingPresentation: hasPendingPresentation,
            suppressedAutomaticUpdateRequests: suppressedAutomaticUpdateRequests,
            appStoreLookupErrorMessage: appStoreLookupErrorMessage,
            historySheet: historySheet,
            showSearch: showSearch,
            searchText: searchText,
            debouncedSearchText: debouncedSearchText,
            dependencies: loadDependencies
        )
        _loadStateMachineStorage = StateObject(wrappedValue: loadStateMachine)
        testingLoadStateMachineStorage = loadStateMachine
        testingColorSchemeOverride = testingColorScheme
        _show = showBinding ?? .constant(testingShow)
        _align = .constant(align)
        _color = .constant(color)
        _size = .constant(size)
        _label = .constant(label)
        _labelImage = .constant(labelImage)
        _history = .constant(history)
        _search = .constant(search ?? Self.defaultSearchEnabled)
        _data = dataBinding ?? .constant(data)
        _showDrop = .constant(showDrop)
        _mesh = .constant(mesh)
        _meshStyle = .constant(meshStyle)
        _specialEffect = .constant(specialEffect)
        _glass = .constant(glass)
        _buttonCornerRadius = .constant(buttonCornerRadius ?? Self.defaultButtonCornerRadius)
        _buttonTextColor = .constant(buttonTextColor)
        _presentation = .constant(presentation)
        _showBuild = .constant(showBuild)
        _showDescription = .constant(showDescription ?? Self.defaultShowDescription)
        _headingStyle = .constant(headingStyle)
        _headingPrefix = .constant(headingPrefix)
        _iconStyle = .constant(iconStyle)
        _appIconName = .constant(appIconName)
        _alternateAppIconName = .constant(alternateAppIconName)
        _checkForUpdates = .constant(checkForUpdates)
        _allowsSkippingUpdate = .constant(allowsSkippingUpdate)
        _updateButtonTitle = .constant(updateButtonTitle)
        _appStoreBundleIdentifier = .constant(appStoreBundleIdentifier)
        self.dataBundle = dataBundle
    }
}
#endif

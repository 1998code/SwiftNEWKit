//
//  SwiftNEWLoadStateMachine.swift
//  SwiftNEW
//

import Foundation
import SwiftUI
import SwiftVB

struct SwiftNEWLoadDependencies: Sendable {
    typealias ReleaseNotesLoader = @Sendable (String, Bundle) async throws -> [Vmodel]
    typealias URLLoader = @Sendable (URL) async throws -> (Data, URLResponse)
    typealias StringProvider = @Sendable () -> String
    typealias OptionalStringProvider = @Sendable () -> String?
    typealias BoolProvider = @Sendable () -> Bool
    typealias PurchaseVerifier = @Sendable (SwiftNEWPurchaseRequirement) async throws -> Bool
    typealias PurchaseRestorer = @Sendable () async throws -> Void
    typealias PurchaseUpdates = @Sendable () -> AsyncStream<Void>

    let loadReleaseNotes: ReleaseNotesLoader
    let loadURL: URLLoader
    let regionCode: OptionalStringProvider
    let appStoreBundleIdentifier: OptionalStringProvider
    let currentVersion: StringProvider
    let currentBuild: StringProvider
    let isTestFlight: BoolProvider
    let verifyPurchase: PurchaseVerifier
    let restorePurchases: PurchaseRestorer
    let purchaseUpdates: PurchaseUpdates

    init(
        loadReleaseNotes: @escaping ReleaseNotesLoader,
        loadURL: @escaping URLLoader,
        regionCode: @escaping OptionalStringProvider,
        appStoreBundleIdentifier: @escaping OptionalStringProvider,
        currentVersion: @escaping StringProvider,
        currentBuild: @escaping StringProvider,
        isTestFlight: @escaping BoolProvider = { SwiftNEWTestFlight.isTestFlight(bundle: .main) },
        // LCOV_EXCL_START -- StoreKit is unavailable to the package test runners.
        verifyPurchase: @escaping PurchaseVerifier = { requirement in
            try await SwiftNEWPurchaseVerifier.isSatisfied(requirement)
        },
        restorePurchases: @escaping PurchaseRestorer = {
            try await SwiftNEWPurchaseVerifier.restore()
        },
        purchaseUpdates: @escaping PurchaseUpdates = {
            SwiftNEWPurchaseVerifier.updates()
        }
        // LCOV_EXCL_STOP
    ) {
        self.loadReleaseNotes = loadReleaseNotes
        self.loadURL = loadURL
        self.regionCode = regionCode
        self.appStoreBundleIdentifier = appStoreBundleIdentifier
        self.currentVersion = currentVersion
        self.currentBuild = currentBuild
        self.isTestFlight = isTestFlight
        self.verifyPurchase = verifyPurchase
        self.restorePurchases = restorePurchases
        self.purchaseUpdates = purchaseUpdates
    }

    static let live = Self(
        loadReleaseNotes: { source, bundle in
            try await SwiftNEWReleaseNotesLoader.load(from: source, bundle: bundle)
        },
        loadURL: { url in
            try await URLSession.shared.data(from: url)
        },
        regionCode: {
            if #available(iOS 16.0, watchOS 9.0, macOS 13.0, tvOS 16.0, *) {
                return Locale.current.region?.identifier
            }
            return (Locale.current as NSLocale).object(forKey: .countryCode) as? String // LCOV_EXCL_LINE: Current runners cannot execute the older OS fallback.
        },
        appStoreBundleIdentifier: {
            Bundle.main.appStoreListingBundleIdentifier
        },
        currentVersion: { Bundle.version },
        currentBuild: { Bundle.build }
    )
}

/// Reference-backed state for the release-note/update loading workflow.
///
/// SwiftUI owns this object through `StateObject`, so the same state is used by
/// rendered views and by direct, deterministic tests of the async workflow.
final class SwiftNEWLoadStateMachine: ObservableObject {
    @Published var items: [Vmodel]
    @Published var loading: Bool
    @Published var loadErrorMessage: String?
    @Published var loadedDataSource: String?
    @Published var loadedRequest: SwiftNEWLoadRequest?
    @Published var currentLoadRequest: SwiftNEWLoadRequest?
    @Published var loadGeneration: UUID?
    @Published var reloadID: UUID
    @Published var forceLoadRequested: Bool
    @Published var availableUpdate: SwiftNEWUpdateCandidate?
    @Published var updateCheckPhase: SwiftNEWUpdateCheckPhase
    @Published var pendingSeenVersion: SwiftNEWVersionSnapshot?
    @Published var hasPendingPresentation: Bool
    @Published var suppressedAutomaticUpdateRequests: Set<SwiftNEWLoadRequest>
    @Published var appStoreLookupErrorMessage: String?
    @Published var appStoreLookupRetryRequest: SwiftNEWLoadRequest?
    @Published var historySheet: Bool
    @Published var showSearch: Bool
    @Published var searchText: String
    @Published var debouncedSearchText: String
    @Published var purchaseRequirement: SwiftNEWPurchaseRequirement?
    @Published var purchaseCheckPhase: SwiftNEWPurchaseCheckPhase
    @Published var purchaseErrorMessage: String?
    /// The first check that failed; decides what the purchase screen asks for.
    @Published var purchaseUnmetRequirement: SwiftNEWPurchaseRequirement?
    @Published var purchaseAppStoreURL: URL?
    @Published var purchaseAppIconURL: URL?
    @Published var purchaseReloadID: UUID
    @Published var purchaseRestoreRequested: Bool
    /// The purchase gate presented the sheet itself, so it also closes it.
    @Published var purchasePresentedGate: Bool
    /// The pending dismissal belongs to the purchase gate, not to the user.
    @Published var purchaseClosingGate: Bool
    #if os(iOS)
    @Published var activeDropEpoch: UUID?
    #endif

    let dependencies: SwiftNEWLoadDependencies

    init(
        items: [Vmodel] = [],
        loading: Bool = true,
        loadErrorMessage: String? = nil,
        loadedDataSource: String? = nil,
        loadedRequest: SwiftNEWLoadRequest? = nil,
        currentLoadRequest: SwiftNEWLoadRequest? = nil,
        loadGeneration: UUID? = nil,
        reloadID: UUID = UUID(),
        forceLoadRequested: Bool = false,
        availableUpdate: SwiftNEWUpdateCandidate? = nil,
        updateCheckPhase: SwiftNEWUpdateCheckPhase = .inactive,
        pendingSeenVersion: SwiftNEWVersionSnapshot? = nil,
        hasPendingPresentation: Bool = false,
        suppressedAutomaticUpdateRequests: Set<SwiftNEWLoadRequest> = [],
        appStoreLookupErrorMessage: String? = nil,
        appStoreLookupRetryRequest: SwiftNEWLoadRequest? = nil,
        historySheet: Bool = false,
        showSearch: Bool = false,
        searchText: String = "",
        debouncedSearchText: String = "",
        purchaseRequirement: SwiftNEWPurchaseRequirement? = nil,
        purchaseCheckPhase: SwiftNEWPurchaseCheckPhase = .inactive,
        purchaseErrorMessage: String? = nil,
        purchaseAppStoreURL: URL? = nil,
        purchaseAppIconURL: URL? = nil,
        purchaseReloadID: UUID = UUID(),
        dependencies: SwiftNEWLoadDependencies = .live
    ) {
        self.items = items
        self.loading = loading
        self.loadErrorMessage = loadErrorMessage
        self.loadedDataSource = loadedDataSource
        self.loadedRequest = loadedRequest
        self.currentLoadRequest = currentLoadRequest
        self.loadGeneration = loadGeneration
        self.reloadID = reloadID
        self.forceLoadRequested = forceLoadRequested
        self.availableUpdate = availableUpdate
        self.updateCheckPhase = updateCheckPhase
        self.pendingSeenVersion = pendingSeenVersion
        self.hasPendingPresentation = hasPendingPresentation
        self.suppressedAutomaticUpdateRequests = suppressedAutomaticUpdateRequests
        self.appStoreLookupErrorMessage = appStoreLookupErrorMessage
        self.appStoreLookupRetryRequest = appStoreLookupRetryRequest
        self.historySheet = historySheet
        self.showSearch = showSearch
        self.searchText = searchText
        self.debouncedSearchText = debouncedSearchText
        self.purchaseRequirement = purchaseRequirement
        self.purchaseCheckPhase = purchaseCheckPhase
        self.purchaseErrorMessage = purchaseErrorMessage
        self.purchaseAppStoreURL = purchaseAppStoreURL
        self.purchaseAppIconURL = purchaseAppIconURL
        self.purchaseReloadID = purchaseReloadID
        self.purchaseUnmetRequirement = nil
        self.purchaseRestoreRequested = false
        self.purchasePresentedGate = false
        self.purchaseClosingGate = false
        #if os(iOS)
        self.activeDropEpoch = nil
        #endif
        self.dependencies = dependencies
    }

    @discardableResult
    func resetIfRequestChanged(to request: SwiftNEWLoadRequest) -> Bool {
        guard currentLoadRequest != request else { return false }

        currentLoadRequest = request
        loadedRequest = nil
        loadedDataSource = nil
        items = []
        availableUpdate = nil
        loadErrorMessage = nil
        appStoreLookupErrorMessage = nil
        appStoreLookupRetryRequest = nil
        return true
    }

    func requestReload(retryingAppStoreFor request: SwiftNEWLoadRequest? = nil) {
        if let request {
            appStoreLookupRetryRequest = request
            appStoreLookupErrorMessage = nil
        } else {
            forceLoadRequested = true
            appStoreLookupRetryRequest = nil
        }
        loadGeneration = nil
        loadedRequest = nil
        reloadID = UUID()
    }

    func beginLoad(isUpdatePreflight: Bool) -> UUID {
        let generation = UUID()
        loadGeneration = generation
        loading = true
        loadErrorMessage = nil
        appStoreLookupErrorMessage = nil
        availableUpdate = nil
        updateCheckPhase = isUpdatePreflight ? .checking : .inactive
        return generation
    }

    func finishLoad(
        items: [Vmodel],
        updateCandidate: SwiftNEWUpdateCandidate?,
        lookupErrorMessage: String?,
        request: SwiftNEWLoadRequest,
        isUpdatePreflight: Bool
    ) {
        self.items = items
        availableUpdate = updateCandidate
        appStoreLookupErrorMessage = lookupErrorMessage
        loading = false
        loadedDataSource = request.source
        loadedRequest = request
        loadGeneration = nil
        forceLoadRequested = false
        appStoreLookupRetryRequest = nil
        updateCheckPhase = isUpdatePreflight ? .resolved : .inactive
    }

    func failLoad(request: SwiftNEWLoadRequest, isUpdatePreflight: Bool, message: String) {
        loading = false
        availableUpdate = nil
        appStoreLookupErrorMessage = nil
        loadedDataSource = request.source
        loadedRequest = request
        loadGeneration = nil
        forceLoadRequested = false
        appStoreLookupRetryRequest = nil
        updateCheckPhase = isUpdatePreflight ? .resolved : .inactive
        loadErrorMessage = message
    }

    func beginAppStoreRetry() -> UUID {
        let generation = UUID()
        loadGeneration = generation
        updateCheckPhase = .checking
        appStoreLookupErrorMessage = nil
        return generation
    }

    func finishAppStoreRetry(
        candidate: SwiftNEWUpdateCandidate,
        appStoreURL: URL?,
        errorMessage: String?,
        request: SwiftNEWLoadRequest
    ) {
        availableUpdate = appStoreURL.map(candidate.resolvingAppStoreURL) ?? candidate
        appStoreLookupErrorMessage = errorMessage
        loadedRequest = request
        appStoreLookupRetryRequest = nil
        loadGeneration = nil
        updateCheckPhase = .resolved
    }

    @discardableResult
    func resetPurchaseIfRequirementChanged(to requirement: SwiftNEWPurchaseRequirement?) -> Bool {
        guard purchaseRequirement != requirement else { return false }

        purchaseRequirement = requirement
        purchaseCheckPhase = .inactive
        purchaseErrorMessage = nil
        purchaseAppStoreURL = nil
        purchaseAppIconURL = nil
        purchaseUnmetRequirement = nil
        purchaseRestoreRequested = false
        return true
    }

    func requestPurchaseCheck(restoring: Bool = false) {
        purchaseRestoreRequested = restoring
        purchaseErrorMessage = nil
        purchaseReloadID = UUID()
    }

    /// Starts a check and reports whether it should restore purchases first.
    func beginPurchaseCheck() -> Bool {
        let shouldRestore = purchaseRestoreRequested
        purchaseRestoreRequested = false
        purchaseCheckPhase = .checking
        purchaseErrorMessage = nil
        return shouldRestore
    }

    func requirePurchase(
        _ unmetRequirement: SwiftNEWPurchaseRequirement?,
        listing: SwiftNEWAppStoreListing?,
        errorMessage: String?
    ) {
        purchaseUnmetRequirement = unmetRequirement
        if let listing {
            purchaseAppStoreURL = listing.url
            purchaseAppIconURL = listing.iconURL
        }
        purchaseErrorMessage = errorMessage
        purchaseCheckPhase = .required
    }

    func finishPurchaseVerification() {
        purchaseCheckPhase = .verified
        purchaseUnmetRequirement = nil
        purchaseErrorMessage = nil
        purchasePresentedGate = false
    }
}

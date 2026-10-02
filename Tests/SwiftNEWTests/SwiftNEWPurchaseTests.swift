//
//  SwiftNEWPurchaseTests.swift
//  SwiftNEW
//

import Foundation
import SwiftUI
import Testing
@testable import SwiftNEW

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

@Test func entitlementMatchesDesignatedActiveProductsOnly() {
    let pro = SwiftNEWPurchaseRequirement.subscription(productIDs: [" com.example.pro ", ""])
    let anyProduct = SwiftNEWPurchaseRequirement.subscription(productIDs: [])

    #expect(SwiftNEWPurchaseEntitlement.satisfies(pro, productID: "com.example.pro", isRevoked: false))
    #expect(!SwiftNEWPurchaseEntitlement.satisfies(pro, productID: "com.example.pro", isRevoked: true))
    #expect(!SwiftNEWPurchaseEntitlement.satisfies(pro, productID: "com.example.other", isRevoked: false))
    #expect(SwiftNEWPurchaseEntitlement.satisfies(anyProduct, productID: "com.example.other", isRevoked: false))
    #expect(!SwiftNEWPurchaseEntitlement.satisfies(.appPurchase, productID: "com.example.pro", isRevoked: false))
}

@MainActor
@Test func purchaseStateMachineTransitionsDeterministically() {
    let stateMachine = SwiftNEWLoadStateMachine()
    let requirement = SwiftNEWPurchaseRequirement.appPurchase
    let url = URL(string: "https://apps.apple.com/app/id123")

    #expect(stateMachine.resetPurchaseIfRequirementChanged(to: requirement))
    #expect(stateMachine.resetPurchaseIfRequirementChanged(to: requirement) == false)
    #expect(stateMachine.beginPurchaseCheck() == false)
    #expect(stateMachine.purchaseCheckPhase == .checking)

    stateMachine.requirePurchase(
        .appPurchase,
        listing: url.map { SwiftNEWAppStoreListing(url: $0, iconURL: nil) },
        errorMessage: "Failed"
    )
    #expect(stateMachine.purchaseCheckPhase == .required)
    #expect(stateMachine.purchaseAppStoreURL == url)
    #expect(stateMachine.purchaseErrorMessage == "Failed")

    let reloadID = stateMachine.purchaseReloadID
    stateMachine.requestPurchaseCheck(restoring: true)
    #expect(stateMachine.purchaseReloadID != reloadID)
    #expect(stateMachine.purchaseErrorMessage == nil)
    #expect(stateMachine.beginPurchaseCheck())
    #expect(stateMachine.purchaseRestoreRequested == false)

    stateMachine.purchasePresentedGate = true
    stateMachine.finishPurchaseVerification()
    #expect(stateMachine.purchaseCheckPhase == .verified)
    #expect(stateMachine.purchasePresentedGate == false)

    #expect(stateMachine.resetPurchaseIfRequirementChanged(to: nil))
    #expect(stateMachine.purchaseCheckPhase == .inactive)
    #expect(stateMachine.purchaseAppStoreURL == nil)
}

@MainActor
@Test func verifiedPurchaseNeverPresentsTheGate() async {
    let show = PurchaseTestBox(false)
    let verifier = PurchaseVerifierStub(results: [.success(true)])
    let sut = makePurchaseTestView(show: show, verifier: verifier)

    #expect(sut.isPurchaseGateActive)
    await sut.runPurchaseTask(sut.purchaseTaskID)

    #expect(sut.purchaseCheckPhase == .verified)
    #expect(sut.isPurchaseGateActive == false)
    #expect(show.value == false)

    // A reappearing view reuses the verified result.
    await sut.runPurchaseTask(sut.purchaseTaskID)
    #expect(await verifier.callCount == 1)
}

@MainActor
@Test func missingRequirementAndStaleTasksDoNothing() async {
    let verifier = PurchaseVerifierStub(results: [.success(false)])
    let disabled = makePurchaseTestView(requirement: nil, verifier: verifier)
    await disabled.runPurchaseTask(disabled.purchaseTaskID)
    #expect(disabled.purchaseCheckPhase == .inactive)
    #expect(disabled.isPurchaseGateActive == false)

    let sut = makePurchaseTestView(verifier: verifier)
    await sut.runPurchaseTask(
        SwiftNEWPurchaseTaskID(requirement: .appPurchase, reloadID: UUID())
    )
    #expect(sut.purchaseCheckPhase == .inactive)
    #expect(await verifier.callCount == 0)
}

@MainActor
@Test func unmetRequirementPresentsGateAndClosesItAfterATransactionUpdate() async throws {
    let show = PurchaseTestBox(false)
    let verifier = PurchaseVerifierStub(results: [.success(false), .success(true)])
    let (updates, continuation) = AsyncStream<Void>.makeStream()
    let sut = makePurchaseTestView(
        show: show,
        verifier: verifier,
        updates: { updates },
        lookup: purchaseLookup
    )

    let task = Task { @MainActor in
        await sut.runPurchaseTask(sut.purchaseTaskID)
    }
    try await waitUntil { sut.purchaseCheckPhase == .required }

    #expect(show.value)
    #expect(sut.purchasePresentedGate)
    #expect(sut.purchaseAppStoreURL?.absoluteString == "https://apps.apple.com/app/id123")
    #expect(sut.purchaseAppIconURL?.host == "is1-ssl.mzstatic.com")
    #expect(sut.purchaseErrorMessage == nil)
    #expect(sut.canPerformPurchase)
    #expect(sut.shouldDisableUpdateDismissal)

    continuation.yield()
    await task.value

    #expect(sut.purchaseCheckPhase == .verified)
    #expect(show.value == false)
    #expect(sut.purchaseClosingGate)

    // The gate's own dismissal is not treated as the user declining anything.
    sut.handleShowChange(false)
    #expect(sut.purchaseClosingGate == false)
}

@MainActor
@Test func failedVerificationAndLookupPublishRetryableErrors() async {
    let show = PurchaseTestBox(false)
    let failing = makePurchaseTestView(
        show: show,
        verifier: PurchaseVerifierStub(results: [.failure(PurchaseTestError.storeUnavailable)])
    )
    await failing.runPurchaseTask(failing.purchaseTaskID)

    #expect(failing.purchaseCheckPhase == .required)
    #expect(failing.purchaseErrorMessage != nil)
    #expect(failing.canPerformPurchase == false)
    #expect(show.value)

    let lookupFailure = makePurchaseTestView(
        verifier: PurchaseVerifierStub(results: [.success(false)])
    )
    await lookupFailure.runPurchaseTask(lookupFailure.purchaseTaskID)
    #expect(lookupFailure.purchaseCheckPhase == .required)
    #expect(lookupFailure.purchaseErrorMessage != nil)

    let reloadID = lookupFailure.purchaseReloadID
    lookupFailure.retryPurchaseCheck()
    #expect(lookupFailure.purchaseReloadID != reloadID)
    #expect(lookupFailure.purchaseErrorMessage == nil)
}

@MainActor
@Test func restoreSyncsBeforeCheckingAgain() async {
    let verifier = PurchaseVerifierStub(results: [.success(true)])
    let restorer = PurchaseRestoreCounter()
    let sut = makePurchaseTestView(
        verifier: verifier,
        restore: { try await restorer.restore() },
        purchaseCheckPhase: .required
    )

    sut.restorePurchases()
    await sut.runPurchaseTask(sut.purchaseTaskID)

    #expect(await restorer.count == 1)
    #expect(sut.purchaseCheckPhase == .verified)
}

@MainActor
@Test func purchaseActionRunsHostPurchaseThenReverifies() async throws {
    let show = PurchaseTestBox(true)
    let verifier = PurchaseVerifierStub(results: [.success(true)])
    let purchased = PurchaseTestBox(false)
    let sut = makePurchaseTestView(
        show: show,
        requirement: .subscription(productIDs: ["com.example.pro"]),
        verifier: verifier,
        purchaseAction: { purchased.value = true },
        purchaseCheckPhase: .required
    )

    #expect(sut.canPerformPurchase)
    #expect(sut.resolvedPurchaseButtonTitle.isEmpty == false)
    sut.performPurchase()
    try await waitUntil { sut.purchaseCheckPhase == .verified }

    #expect(purchased.value)
    // The sheet was not opened by the gate, so release notes take over.
    #expect(show.value)
}

@MainActor
@Test func purchaseActionFallsBackToTheResolvedAppStoreURL() async throws {
    let url = try #require(URL(string: "https://apps.apple.com/app/id123"))
    let sut = makePurchaseTestView(
        purchaseCheckPhase: .required,
        purchaseAppStoreURL: url,
        purchaseButtonTitle: "Unlock"
    )
    var opened: URL?

    await sut.runPurchaseAction(using: { opened = $0 })
    #expect(opened == url)
    #expect(sut.resolvedPurchaseButtonTitle == "Unlock")

    let unresolved = makePurchaseTestView(purchaseCheckPhase: .required)
    opened = nil
    await unresolved.runPurchaseAction(using: { opened = $0 })
    await unresolved.runPurchaseAction()
    #expect(opened == nil)
    #expect(unresolved.resolvedPurchaseButtonTitle.isEmpty == false)

    let appAction = makePurchaseTestView(purchaseAction: {}, purchaseCheckPhase: .required)
    #expect(appAction.resolvedPurchaseButtonTitle.isEmpty == false)
}

@MainActor
@Test func gateIsMandatoryAndSurvivesDeveloperDismissal() {
    let show = PurchaseTestBox(true)
    let sut = makePurchaseTestView(show: show, purchaseCheckPhase: .required)
    sut.purchasePresentedGate = true
    #expect(sut.shouldDisableUpdateDismissal)

    // A developer-driven dismissal keeps the gate active for the next presentation.
    show.value = false
    sut.handleShowChange(false)
    #expect(sut.isPurchaseGateActive)
    #expect(sut.purchasePresentedGate == false)
}

@MainActor
@Test func returningToTheAppReverifiesARequiredPurchase() async throws {
    let verifier = PurchaseVerifierStub(results: [.success(true)])
    let sut = makePurchaseTestView(verifier: verifier, purchaseCheckPhase: .required)

    sut.handleScenePhaseChange(.background)
    #expect(sut.purchaseCheckPhase == .required)

    sut.handleScenePhaseChange(.active)
    try await waitUntil { sut.purchaseCheckPhase == .verified }
    #expect(await verifier.callCount == 1)
}

@MainActor
@Test func purchaseSheetRendersEveryState() throws {
    let url = try #require(URL(string: "https://apps.apple.com/app/id123"))
    let alignments: [HorizontalAlignment] = [.leading, .center, .trailing]

    for align in alignments {
        let required = makePurchaseTestView(
            align: align,
            purchaseCheckPhase: .required,
            purchaseErrorMessage: align == .trailing ? "The App Store is unavailable." : nil,
            purchaseAppStoreURL: align == .leading ? nil : url,
            purchaseAppIconURL: align == .center ? url : nil
        )
        renderPurchaseView(required.sheetPurchase)
        renderPurchaseView(required.testingSheetContent)
        #if DEBUG
        renderPurchaseView(required.testingWatchPurchaseContent)
        renderPurchaseView(required.testingPurchaseAppIcon)
        #endif
    }

    renderPurchaseView(
        makePurchaseTestView(
            requirement: .subscription(productIDs: ["com.example.pro"]),
            purchaseAction: {},
            purchaseCheckPhase: .required
        ).sheetPurchase
    )
    renderPurchaseView(
        makePurchaseTestView(purchaseCheckPhase: .checking).sheetPurchase
    )
    let beta = makePurchaseTestView(purchaseCheckPhase: .required, isTestFlight: true)
    renderPurchaseView(beta.sheetPurchase)
    #if DEBUG
    renderPurchaseView(beta.testingWatchPurchaseContent)
    #endif
    renderPurchaseView(
        makePurchaseTestView(
            presentation: .embed,
            purchaseCheckPhase: .checking
        ).sheetPurchaseChecking
    )
}

private enum PurchaseTestError: Error {
    case storeUnavailable
    case unexpectedLookup
    case timedOut
}

@MainActor
private func makePurchaseTestView(
    show: PurchaseTestBox<Bool>? = nil,
    requirement: SwiftNEWPurchaseRequirement? = .appPurchase,
    verifier: PurchaseVerifierStub = PurchaseVerifierStub(results: []),
    restore: @escaping SwiftNEWLoadDependencies.PurchaseRestorer = {},
    updates: @escaping SwiftNEWLoadDependencies.PurchaseUpdates = {
        AsyncStream { $0.finish() }
    },
    lookup: @escaping SwiftNEWLoadDependencies.URLLoader = { _ in
        throw PurchaseTestError.unexpectedLookup
    },
    align: HorizontalAlignment = .center,
    presentation: SwiftNEWPresentation = .sheet,
    purchaseAction: (@MainActor () async -> Void)? = nil,
    purchaseCheckPhase: SwiftNEWPurchaseCheckPhase = .inactive,
    purchaseErrorMessage: String? = nil,
    purchaseAppStoreURL: URL? = nil,
    purchaseAppIconURL: URL? = nil,
    purchaseButtonTitle: String = "",
    environment: SwiftNEWPurchaseEnvironment = .all,
    isTestFlight: Bool = false
) -> SwiftNEW {
    SwiftNEW(
        items: [],
        loading: false,
        align: align,
        presentation: presentation,
        appStoreBundleIdentifier: "com.example.swiftnew",
        purchaseRequirement: requirement,
        purchaseEnvironment: environment,
        purchaseButtonTitle: purchaseButtonTitle,
        purchaseAction: purchaseAction,
        purchaseCheckPhase: purchaseCheckPhase,
        purchaseErrorMessage: purchaseErrorMessage,
        purchaseAppStoreURL: purchaseAppStoreURL,
        purchaseAppIconURL: purchaseAppIconURL,
        showBinding: (show ?? PurchaseTestBox(false)).binding,
        loadDependencies: SwiftNEWLoadDependencies(
            loadReleaseNotes: { _, _ in [] },
            loadURL: lookup,
            regionCode: { "US" },
            appStoreBundleIdentifier: { "com.example.swiftnew" },
            currentVersion: { "1.0" },
            currentBuild: { "1" },
            isTestFlight: { isTestFlight },
            verifyPurchase: { _ in try await verifier.next() },
            restorePurchases: restore,
            purchaseUpdates: updates
        )
    )
}

@Sendable
private func purchaseLookup(_ url: URL) throws -> (Data, URLResponse) {
    let payload = """
    {"results":[{"bundleId":"com.example.swiftnew","trackViewUrl":"https://apps.apple.com/app/id123","artworkUrl512":"https://is1-ssl.mzstatic.com/image/icon.png"}]}
    """
    guard let response = HTTPURLResponse(
        url: url,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    ) else { throw PurchaseTestError.unexpectedLookup }
    return (Data(payload.utf8), response)
}

@MainActor
private func waitUntil(_ condition: @MainActor () -> Bool) async throws {
    for _ in 0..<2_000 {
        if condition() { return }
        try await Task.sleep(nanoseconds: 1_000_000)
    }
    throw PurchaseTestError.timedOut
}

private actor PurchaseVerifierStub {
    private var results: [Result<Bool, PurchaseTestError>]
    private(set) var callCount = 0

    init(results: [Result<Bool, PurchaseTestError>]) {
        self.results = results
    }

    func next() throws -> Bool {
        callCount += 1
        guard !results.isEmpty else { return false }
        return try results.removeFirst().get()
    }
}

private actor PurchaseRestoreCounter {
    private(set) var count = 0

    func restore() throws {
        count += 1
        throw PurchaseTestError.storeUnavailable
    }
}

@MainActor
private final class PurchaseTestBox<Value> {
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

@MainActor
private func renderPurchaseView<ViewUnderTest: View>(_ view: ViewUnderTest) {
    #if os(macOS)
    let host = NSHostingView(rootView: AnyView(view))
    host.frame = NSRect(x: 0, y: 0, width: 900, height: 900)
    host.layoutSubtreeIfNeeded()
    _ = host.fittingSize
    #elseif os(iOS)
    let controller = UIHostingController(rootView: AnyView(view))
    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 900, height: 900))
    window.rootViewController = controller
    window.isHidden = false
    controller.loadViewIfNeeded()
    controller.view.frame = window.bounds
    controller.view.setNeedsLayout()
    controller.view.layoutIfNeeded()
    _ = controller.view.systemLayoutSizeFitting(
        CGSize(width: 900, height: 900)
    )
    #else
    _ = AnyView(view)
    #endif
}

@Test func appStoreIconIsAcceptedOnlyFromApplesArtworkCDN() throws {
    func iconURL(_ fields: String) throws -> URL? {
        try SwiftNEWAppStoreLookup.iconURL(
            from: Data("{\"results\":[{\"bundleId\":\"com.example.swiftnew\",\(fields)}]}".utf8),
            bundleIdentifier: " com.example.swiftnew "
        )
    }

    #expect(try iconURL("\"artworkUrl512\":\"https://is1-ssl.mzstatic.com/a.png\"") != nil)
    #expect(try iconURL("\"artworkUrl100\":\"https://is1-ssl.mzstatic.com/b.png\"")?.lastPathComponent == "b.png")
    #expect(try iconURL("\"artworkUrl512\":\"http://is1-ssl.mzstatic.com/a.png\"") == nil)
    #expect(try iconURL("\"artworkUrl512\":\"https://example.com/a.png\"") == nil)
    #expect(try iconURL("\"trackViewUrl\":\"https://apps.apple.com/app/id123\"") == nil)
}

@MainActor
@Test func requirementIsEnforcedOnlyInTheConfiguredEnvironment() async {
    let verifier = PurchaseVerifierStub(results: [.success(false)])
    let appStore = makePurchaseTestView(verifier: verifier, environment: .testFlight)
    await appStore.runPurchaseTask(appStore.purchaseTaskID)
    #expect(appStore.activePurchaseRequirement == nil)
    #expect(appStore.isPurchaseGateActive == false)
    #expect(appStore.purchaseCheckPhase == .inactive)
    // The silent pass only lets the verifier store proof of a production purchase.
    #expect(await verifier.callCount == 1)

    let testFlight = makePurchaseTestView(
        verifier: verifier,
        purchaseAction: {},
        environment: .testFlight,
        isTestFlight: true
    )
    await testFlight.runPurchaseTask(testFlight.purchaseTaskID)
    #expect(testFlight.purchaseCheckPhase == .required)
}

@Test func testFlightDetectionNeedsASandboxReceiptWithoutAProvisioningProfile() throws {
    let sandbox = URL(fileURLWithPath: "/StoreKit/sandboxReceipt")
    let production = URL(fileURLWithPath: "/StoreKit/receipt")

    #expect(SwiftNEWTestFlight.isTestFlight(receiptURL: sandbox, hasEmbeddedProvisioningProfile: false, isSimulator: false))
    #expect(!SwiftNEWTestFlight.isTestFlight(receiptURL: sandbox, hasEmbeddedProvisioningProfile: true, isSimulator: false))
    #expect(!SwiftNEWTestFlight.isTestFlight(receiptURL: sandbox, hasEmbeddedProvisioningProfile: false, isSimulator: true))
    #expect(!SwiftNEWTestFlight.isTestFlight(receiptURL: production, hasEmbeddedProvisioningProfile: false, isSimulator: false))
    #expect(!SwiftNEWTestFlight.isTestFlight(receiptURL: nil, hasEmbeddedProvisioningProfile: false, isSimulator: false))
    #expect(!SwiftNEWTestFlight.isTestFlight(bundle: .main))
}

@MainActor
@Test func combinedRequirementAsksForEachUnmetPurchaseInTurn() async {
    let requirement = SwiftNEWPurchaseRequirement.appPurchaseAndSubscription(productIDs: ["com.example.pro"])
    #expect(requirement.components == [.appPurchase, .subscription(productIDs: ["com.example.pro"])])
    #expect(SwiftNEWPurchaseRequirement.appPurchase.components == [.appPurchase])

    // App purchase fails first; then it passes and the subscription fails; then both pass.
    let verifier = PurchaseVerifierStub(
        results: [.success(false), .success(true), .success(false), .success(true), .success(true)]
    )
    let sut = makePurchaseTestView(
        show: PurchaseTestBox(true),
        requirement: requirement,
        verifier: verifier,
        purchaseAction: {}
    )
    #expect(sut.displayedPurchaseRequirement == .appPurchase)

    await sut.runPurchaseTask(sut.purchaseTaskID)
    #expect(sut.purchaseCheckPhase == .required)
    #expect(sut.purchaseUnmetRequirement == .appPurchase)

    await sut.refreshPurchaseStatus()
    #expect(sut.purchaseCheckPhase == .required)
    #expect(sut.displayedPurchaseRequirement == .subscription(productIDs: ["com.example.pro"]))

    await sut.refreshPurchaseStatus()
    #expect(sut.purchaseCheckPhase == .verified)
    #expect(sut.purchaseUnmetRequirement == nil)
    #expect(await verifier.callCount == 5)
}

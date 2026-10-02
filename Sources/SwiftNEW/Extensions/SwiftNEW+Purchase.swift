//
//  SwiftNEW+Purchase.swift
//  SwiftNEW
//

import SwiftUI
import SwiftVB

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {
    var purchaseTaskID: SwiftNEWPurchaseTaskID {
        SwiftNEWPurchaseTaskID(
            requirement: activePurchaseRequirement,
            proofRequirement: activePurchaseRequirement == nil ? purchaseRequirement : nil,
            reloadID: purchaseReloadID
        )
    }

    /// The requirement enforced in this build; `nil` outside the configured
    /// `purchaseEnvironment`.
    var activePurchaseRequirement: SwiftNEWPurchaseRequirement? {
        guard purchaseEnvironment == .all || loadDependencies.isTestFlight() else { return nil }
        return purchaseRequirement
    }

    /// The purchase screen replaces every other sheet until the requirement is
    /// verified. It is mandatory: there is no way for the user to skip it.
    var isPurchaseGateActive: Bool {
        activePurchaseRequirement != nil && purchaseCheckPhase != .verified
    }

    var canPerformPurchase: Bool {
        purchaseAction != nil || purchaseAppStoreURL != nil
    }

    private var purchaseBundleIdentifier: String? {
        let configuredBundleIdentifier = appStoreBundleIdentifier?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return configuredBundleIdentifier?.isEmpty == false
            ? configuredBundleIdentifier
            : loadDependencies.appStoreBundleIdentifier()
    }

    // MARK: - Functions
    @MainActor
    func runPurchaseTask(_ taskID: SwiftNEWPurchaseTaskID) async {
        guard isCurrentPurchaseTask(taskID) else { return }
        loadStateMachine.resetPurchaseIfRequirementChanged(to: taskID.requirement)

        guard let requirement = taskID.requirement else {
            await recordPurchaseProof(for: taskID.proofRequirement)
            return
        }
        guard purchaseCheckPhase != .verified else { return }

        if loadStateMachine.beginPurchaseCheck() {
            // A cancelled or failed sync still falls through to the check below.
            try? await loadDependencies.restorePurchases()
            guard isCurrentPurchaseTask(taskID) else { return }
        }

        var isVerified = false
        var unmetRequirement: SwiftNEWPurchaseRequirement?
        var errorMessage: String?
        do {
            unmetRequirement = try await firstUnmetPurchaseRequirement(in: requirement)
            isVerified = unmetRequirement == nil
        } catch {
            guard !Task.isCancelled else { return }
            errorMessage = String(localized: "Unable to verify your purchase.", bundle: .module)
        }
        guard isCurrentPurchaseTask(taskID) else { return }

        if isVerified {
            finishPurchaseVerification()
            return
        }

        // The listing supplies the App Store icon and, without a custom
        // purchase action, the destination of the primary button.
        var listing: SwiftNEWAppStoreListing?
        if purchaseAppStoreURL == nil {
            listing = try? await fetchAppStoreListing(bundleIdentifier: purchaseBundleIdentifier)
            guard isCurrentPurchaseTask(taskID) else { return }

            if listing == nil, purchaseAction == nil, errorMessage == nil {
                errorMessage = String(
                    localized: "Unable to load App Store information.",
                    bundle: .module
                )
            }
        }

        loadStateMachine.requirePurchase(
            unmetRequirement,
            listing: listing,
            errorMessage: errorMessage
        )
        presentPurchaseGate()

        for await _ in loadDependencies.purchaseUpdates() {
            guard isCurrentPurchaseTask(taskID) else { return }
            await refreshPurchaseStatus()
            if purchaseCheckPhase == .verified { return }
        }
    }

    /// Re-verifies quietly, without flashing the checking state, after a
    /// purchase attempt, a StoreKit transaction update, or a return to the app.
    @MainActor
    func refreshPurchaseStatus() async {
        guard let requirement = activePurchaseRequirement,
              purchaseCheckPhase == .required
        else { return }

        let unmetRequirement: SwiftNEWPurchaseRequirement?
        do {
            unmetRequirement = try await firstUnmetPurchaseRequirement(in: requirement)
        } catch {
            return
        }
        guard activePurchaseRequirement == requirement,
              purchaseCheckPhase == .required
        else { return }

        if let unmetRequirement {
            // One of two requirements may now be met; ask for the other.
            purchaseUnmetRequirement = unmetRequirement
        } else {
            finishPurchaseVerification()
        }
    }

    /// Outside the enforced environment the check never shows anything; it
    /// only lets the verifier store proof of a production purchase.
    private func recordPurchaseProof(for requirement: SwiftNEWPurchaseRequirement?) async {
        for component in requirement?.components ?? [] {
            _ = try? await loadDependencies.verifyPurchase(component)
        }
    }

    /// Verifies each component in order and returns the first one that fails.
    private func firstUnmetPurchaseRequirement(
        in requirement: SwiftNEWPurchaseRequirement
    ) async throws -> SwiftNEWPurchaseRequirement? {
        for component in requirement.components
        where try await !loadDependencies.verifyPurchase(component) {
            return component
        }
        return nil
    }

    /// What the purchase screen currently asks the user for.
    var displayedPurchaseRequirement: SwiftNEWPurchaseRequirement? {
        purchaseUnmetRequirement ?? purchaseRequirement?.components.first
    }

    private func isCurrentPurchaseTask(_ taskID: SwiftNEWPurchaseTaskID) -> Bool {
        !Task.isCancelled && purchaseTaskID == taskID
    }

    private func presentPurchaseGate() {
        guard presentation != .embed, !show else { return }

        cancelActiveDrop()
        purchasePresentedGate = true
        withAnimation { show = true }
    }

    private func finishPurchaseVerification() {
        let presentedGate = purchasePresentedGate
        loadStateMachine.finishPurchaseVerification()
        closePurchaseGate(presentedByGate: presentedGate)
    }

    /// Closes the sheet only when the gate opened it and nothing else is
    /// waiting underneath; otherwise the release-note content takes over.
    private func closePurchaseGate(presentedByGate: Bool) {
        guard presentedByGate, presentation != .embed, show, availableUpdate == nil else { return }

        purchaseClosingGate = true
        withAnimation { show = false }
    }

    /// Returns `true` when a dismissal belonged to the purchase gate, so the
    /// update flow does not treat it as the user declining an update.
    func consumePurchaseGateDismissal() -> Bool {
        if purchaseClosingGate {
            purchaseClosingGate = false
            return true
        }

        guard isPurchaseGateActive else { return false }
        purchasePresentedGate = false
        return true
    }

    func performPurchase() {
        Task { @MainActor in
            await runPurchaseAction()
        }
    }

    @MainActor
    func runPurchaseAction() async {
        await runPurchaseAction(using: { url in
            openURL(url)
        })
    }

    @MainActor
    func runPurchaseAction(using openURL: (URL) -> Void) async {
        if let purchaseAction {
            await purchaseAction()
            await refreshPurchaseStatus()
        } else if let purchaseAppStoreURL {
            openURL(purchaseAppStoreURL)
        }
    }

    func retryPurchaseCheck() {
        loadStateMachine.requestPurchaseCheck()
    }

    func restorePurchases() {
        loadStateMachine.requestPurchaseCheck(restoring: true)
    }

    func handleScenePhaseChange(_ phase: ScenePhase) {
        guard phase == .active, purchaseCheckPhase == .required else { return }

        Task { @MainActor in
            await refreshPurchaseStatus()
        }
    }
}

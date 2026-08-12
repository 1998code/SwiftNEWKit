//
//  SwiftNEWUpdateSheetCoverageTests.swift
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

@MainActor
@Test func updateSheetRendersEveryCandidateAndActionState() {
    let installable = updateCandidate(
        appStoreURL: URL(string: "https://apps.apple.com/app/id123")
    )
    let awaitingLookup = updateCandidate(appStoreURL: nil)

    renderUpdateView(
        makeUpdateSheet(
            candidate: installable,
            lookupError: "An ignored lookup error",
            align: .center,
            allowsSkipping: true
        ).sheetUpdate
    )
    renderUpdateView(
        makeUpdateSheet(
            candidate: awaitingLookup,
            align: .leading,
            allowsSkipping: false,
            showDescription: false
        ).sheetUpdate
    )
    renderUpdateView(
        makeUpdateSheet(
            candidate: awaitingLookup,
            lookupError: "The App Store is temporarily unavailable.",
            align: .trailing,
            allowsSkipping: true
        ).sheetUpdate
    )

    // An unresolved update intentionally produces an empty sheet.
    renderUpdateView(makeUpdateSheet(candidate: nil).sheetUpdate)
}

@MainActor
@Test func updateCheckingHonorsSkippingAndEmbeddedPresentation() {
    renderUpdateView(
        makeUpdateSheet(
            candidate: nil,
            presentation: .sheet,
            allowsSkipping: true
        ).sheetUpdateChecking
    )
    renderUpdateView(
        makeUpdateSheet(
            candidate: nil,
            presentation: .sheet,
            allowsSkipping: false
        ).sheetUpdateChecking
    )
    renderUpdateView(
        makeUpdateSheet(
            candidate: nil,
            presentation: .embed,
            allowsSkipping: true
        ).sheetUpdateChecking
    )
}

@MainActor
@Test func updateEntranceMotionResolvesReducedAndAnimatedPolicies() {
    let reduced = SwiftNEWUpdateEntranceMotion(reduceMotion: true, delay: 0.4)
    let animated = SwiftNEWUpdateEntranceMotion(reduceMotion: false, delay: 0.4)

    #expect(reduced == .reduced)
    #expect(animated == .animated(delay: 0.4))
    _ = reduced.animation
    _ = animated.animation
}

#if DEBUG
@MainActor
@Test func watchCompositionCoversURLLookupErrorAndAlignmentStates() {
    let installable = updateCandidate(
        appStoreURL: URL(string: "https://apps.apple.com/app/id123")
    )
    let awaitingLookup = updateCandidate(appStoreURL: nil)

    let leading = makeUpdateSheet(
        candidate: awaitingLookup,
        align: .leading,
        allowsSkipping: false,
        showDescription: true
    )
    renderUpdateView(leading.testingWatchUpdateContent(awaitingLookup))
    renderUpdateView(leading.testingUpdateVersionSummaryRow())

    let trailing = makeUpdateSheet(
        candidate: awaitingLookup,
        lookupError: "Unable to contact the App Store.",
        align: .trailing,
        allowsSkipping: true
    )
    renderUpdateView(trailing.testingWatchUpdateContent(awaitingLookup))
    renderUpdateView(trailing.testingUpdateVersionSummaryRow())

    let centered = makeUpdateSheet(
        candidate: installable,
        align: .center,
        allowsSkipping: true
    )
    renderUpdateView(centered.testingWatchUpdateContent(installable))
    renderUpdateView(centered.testingUpdateVersionSummaryRow())
}

@MainActor
@Test func updateCardFallbacksRemainRenderable() {
    renderUpdateView(makeUpdateSheet(candidate: nil).testingUpdateCardFallbacks)
}
#endif

@MainActor
private func makeUpdateSheet(
    candidate: SwiftNEWUpdateCandidate?,
    lookupError: String? = nil,
    align: HorizontalAlignment = .center,
    presentation: SwiftNEWPresentation = .sheet,
    allowsSkipping: Bool = true,
    showDescription: Bool = true
) -> SwiftNEW {
    SwiftNEW(
        testingShow: false,
        items: [],
        loading: false,
        availableUpdate: candidate,
        updateCheckPhase: candidate == nil ? .checking : .resolved,
        appStoreLookupErrorMessage: lookupError,
        align: align,
        presentation: presentation,
        showDescription: showDescription,
        checkForUpdates: true,
        allowsSkippingUpdate: allowsSkipping
    )
}

private func updateCandidate(appStoreURL: URL?) -> SwiftNEWUpdateCandidate {
    SwiftNEWUpdateCandidate(
        release: Vmodel(
            version: "99.0",
            subVersion: "99.0.1",
            new: [
                Model(
                    icon: "sparkles",
                    toIcon: "wand.and.stars",
                    title: "Coverage",
                    subtitle: "Update flow",
                    body: "Exercises every update-sheet state."
                )
            ]
        ),
        version: "99.0.1",
        appStoreURL: appStoreURL
    )
}

@MainActor
private func renderUpdateView<ViewUnderTest: View>(_ view: ViewUnderTest) {
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

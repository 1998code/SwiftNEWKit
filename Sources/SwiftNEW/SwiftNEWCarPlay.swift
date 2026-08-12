//
//  SwiftNEWCarPlay.swift
//  SwiftNEW
//

#if os(iOS) && canImport(CarPlay) && !targetEnvironment(macCatalyst)
import CarPlay
import Foundation
import SwiftVB
import UIKit

/// Builds a system CarPlay list from SwiftNEW release-note data.
///
/// The host app remains responsible for its CarPlay entitlement, scene
/// configuration, `CPTemplateApplicationSceneDelegate`, and ensuring that the
/// content directly supports its approved in-car category. This factory does
/// not alter SwiftNEW's automatic-presentation or seen-version state.
@available(iOS 15.0, *)
@MainActor
public enum SwiftNEWCarPlayTemplateFactory {
    /// An action the host app performs when the user leaves the release notes.
    ///
    /// Use the supplied interface controller to replace the SwiftNEW root with
    /// the host app's main CarPlay template.
    public typealias ContinueAction = @MainActor (
        _ interfaceController: CPInterfaceController
    ) -> Void

    typealias DetailPresentation = @MainActor (
        _ template: CPListTemplate,
        _ completion: @escaping () -> Void
    ) -> Void

    typealias RootPresentation = @MainActor (
        _ template: CPListTemplate,
        _ animated: Bool
    ) async throws -> Bool

    @MainActor
    final class HistorySwitcher {
        private weak var template: CPListTemplate?
        private let currentSections: [CPListSection]
        private let historySections: [CPListSection]
        private let historyTitle: String
        private let returnTitle: String
        private(set) var isShowingHistory = false

        init(
            template: CPListTemplate,
            currentSections: [CPListSection],
            historySections: [CPListSection],
            historyTitle: String,
            returnTitle: String
        ) {
            self.template = template
            self.currentSections = currentSections
            self.historySections = historySections
            self.historyTitle = historyTitle
            self.returnTitle = returnTitle
        }

        func toggle(using button: CPBarButton) {
            guard let template else { return }
            isShowingHistory.toggle()
            template.updateSections(
                isShowingHistory ? historySections : currentSections
            )
            button.title = isShowingHistory ? returnTitle : historyTitle
            let navigationButtons = template.trailingNavigationBarButtons
            template.trailingNavigationBarButtons = navigationButtons
        }
    }

    /// Builds a CarPlay list template from already-decoded release notes.
    ///
    /// Each release is represented by a section. Selecting a change pushes a
    /// second list template containing its full description.
    ///
    /// - Parameters:
    ///   - releases: Release notes to display.
    ///   - interfaceController: The controller supplied to the host app's CarPlay scene delegate.
    ///   - title: A custom navigation title. Pass `nil` to use a localized default.
    ///   - includesHistory: Whether to expose older releases through a History button.
    ///   - currentVersion: The installed version to prefer. Pass `nil` to use the host app version.
    /// - Returns: A template capped to CarPlay's runtime section and item limits.
    public static func makeTemplate(
        releases: [Vmodel],
        interfaceController: CPInterfaceController,
        title: String? = nil,
        includesHistory: Bool = false,
        currentVersion: String? = nil
    ) -> CPListTemplate {
        makeTemplate(
            releases: releases,
            interfaceController: interfaceController,
            title: title,
            includesHistory: includesHistory,
            currentVersion: currentVersion,
            detailPresentation: nil
        )
    }

    /// Builds a CarPlay list template with a Continue button supplied by SwiftNEW.
    ///
    /// The host app owns the destination and performs its CarPlay transition in
    /// `onContinue`. SwiftNEW weakly binds the action to the connected interface
    /// controller and does not alter its seen-version state.
    public static func makeTemplate(
        releases: [Vmodel],
        interfaceController: CPInterfaceController,
        title: String? = nil,
        includesHistory: Bool = false,
        currentVersion: String? = nil,
        continueButtonTitle: String? = nil,
        onContinue: @escaping ContinueAction
    ) -> CPListTemplate {
        makeTemplate(
            releases: releases,
            interfaceController: interfaceController,
            title: title,
            includesHistory: includesHistory,
            currentVersion: currentVersion,
            detailPresentation: nil,
            continueButtonTitle: continueButtonTitle,
            onContinue: onContinue
        )
    }

    static func makeTemplate(
        releases: [Vmodel],
        interfaceController: CPInterfaceController?,
        title: String?,
        includesHistory: Bool,
        currentVersion: String?,
        detailPresentation: DetailPresentation?,
        continueButtonTitle: String? = nil,
        onContinue: ContinueAction? = nil
    ) -> CPListTemplate {
        let resolvedVersion = normalized(currentVersion) ?? Bundle.version
        let currentReleases = SwiftNEWCarPlayReleaseSelector.releases(
            from: releases,
            currentVersion: resolvedVersion,
            includesHistory: false
        )
        let currentReleaseIDs = Set(currentReleases.map(\.id))
        let historyReleases = includesHistory
            ? SwiftNEWCarPlayReleaseSelector.releases(
                from: releases,
                currentVersion: resolvedVersion,
                includesHistory: true
            ).filter { !currentReleaseIDs.contains($0.id) }
            : []
        let currentSections = makeSections(
            from: currentReleases,
            interfaceController: interfaceController,
            detailPresentation: detailPresentation
        )
        let historySections = makeSections(
            from: historyReleases,
            interfaceController: interfaceController,
            detailPresentation: detailPresentation
        )
        let template = CPListTemplate(
            title: normalized(title) ?? defaultTitle,
            sections: currentSections
        )
        template.emptyViewTitleVariants = [
            String(localized: "No release notes available.", bundle: .module)
        ]
        configureContinueButton(
            on: template,
            interfaceController: interfaceController,
            title: continueButtonTitle,
            action: onContinue
        )
        configureHistoryButton(
            on: template,
            currentSections: currentSections,
            historySections: historySections
        )
        return template
    }

    /// Builds the initial root template to install synchronously when a CarPlay scene connects.
    ///
    /// CarPlay requires the host to set a root template before its scene-connect
    /// callback returns. Install this template first, then load and replace it
    /// asynchronously with ``setRootTemplate(on:from:bundle:title:includesHistory:currentVersion:animated:)``.
    public static func makeLoadingTemplate(title: String? = nil) -> CPListTemplate {
        buildLoadingTemplate(
            title: title,
            interfaceController: nil
        )
    }

    /// Builds an initial loading template with a Continue button.
    ///
    /// The host can use this overload to keep its main CarPlay content
    /// reachable while release notes load.
    public static func makeLoadingTemplate(
        title: String? = nil,
        interfaceController: CPInterfaceController,
        continueButtonTitle: String? = nil,
        onContinue: @escaping ContinueAction
    ) -> CPListTemplate {
        buildLoadingTemplate(
            title: title,
            interfaceController: interfaceController,
            continueButtonTitle: continueButtonTitle,
            onContinue: onContinue
        )
    }

    static func buildLoadingTemplate(
        title: String?,
        interfaceController: CPInterfaceController?,
        continueButtonTitle: String? = nil,
        onContinue: ContinueAction? = nil
    ) -> CPListTemplate {
        let template = CPListTemplate(
            title: normalized(title) ?? defaultTitle,
            sections: []
        )
        template.emptyViewTitleVariants = [
            String(localized: "Loading...", bundle: .module)
        ]
        configureContinueButton(
            on: template,
            interfaceController: interfaceController,
            title: continueButtonTitle,
            action: onContinue
        )
        return template
    }

    /// Loads release notes and builds a CarPlay list template.
    public static func loadTemplate(
        from source: String = "data",
        bundle: Bundle = .main,
        interfaceController: CPInterfaceController,
        title: String? = nil,
        includesHistory: Bool = false,
        currentVersion: String? = nil
    ) async throws -> CPListTemplate {
        try await loadTemplate(
            from: source,
            bundle: bundle,
            interfaceController: interfaceController,
            title: title,
            includesHistory: includesHistory,
            currentVersion: currentVersion,
            detailPresentation: nil
        )
    }

    /// Loads release notes and builds a template with a Continue button.
    public static func loadTemplate(
        from source: String = "data",
        bundle: Bundle = .main,
        interfaceController: CPInterfaceController,
        title: String? = nil,
        includesHistory: Bool = false,
        currentVersion: String? = nil,
        continueButtonTitle: String? = nil,
        onContinue: @escaping ContinueAction
    ) async throws -> CPListTemplate {
        try await loadTemplate(
            from: source,
            bundle: bundle,
            interfaceController: interfaceController,
            title: title,
            includesHistory: includesHistory,
            currentVersion: currentVersion,
            detailPresentation: nil,
            continueButtonTitle: continueButtonTitle,
            onContinue: onContinue
        )
    }

    static func loadTemplate(
        from source: String,
        bundle: Bundle,
        interfaceController: CPInterfaceController?,
        title: String?,
        includesHistory: Bool,
        currentVersion: String?,
        detailPresentation: DetailPresentation?,
        continueButtonTitle: String? = nil,
        onContinue: ContinueAction? = nil
    ) async throws -> CPListTemplate {
        let releases = try await SwiftNEWReleaseNotesLoader.load(
            from: source,
            bundle: bundle
        )
        try Task.checkCancellation()

        return makeTemplate(
            releases: releases,
            interfaceController: interfaceController,
            title: title,
            includesHistory: includesHistory,
            currentVersion: currentVersion,
            detailPresentation: detailPresentation,
            continueButtonTitle: continueButtonTitle,
            onContinue: onContinue
        )
    }

    /// Loads release notes and installs the resulting template as the CarPlay root.
    ///
    /// Call this after synchronously installing an initial root template from
    /// `templateApplicationScene(_:didConnect:)`. Retain the interface controller
    /// for the lifetime of the connected CarPlay scene.
    @discardableResult
    public static func setRootTemplate(
        on interfaceController: CPInterfaceController,
        from source: String = "data",
        bundle: Bundle = .main,
        title: String? = nil,
        includesHistory: Bool = false,
        currentVersion: String? = nil,
        animated: Bool = false
    ) async throws -> CPListTemplate {
        let template = try await loadTemplate(
            from: source,
            bundle: bundle,
            interfaceController: interfaceController,
            title: title,
            includesHistory: includesHistory,
            currentVersion: currentVersion
        )

        return try await installRootTemplate(
            template,
            animated: animated
        ) { template, animated in
            try await interfaceController.setRootTemplate(
                template,
                animated: animated
            )
        }
    }

    /// Loads release notes and installs a root template with a Continue button.
    ///
    /// Replace the root with the host app's main CarPlay template from
    /// `onContinue` so the release-note hierarchy does not remain underneath it.
    @discardableResult
    public static func setRootTemplate(
        on interfaceController: CPInterfaceController,
        from source: String = "data",
        bundle: Bundle = .main,
        title: String? = nil,
        includesHistory: Bool = false,
        currentVersion: String? = nil,
        animated: Bool = false,
        continueButtonTitle: String? = nil,
        onContinue: @escaping ContinueAction
    ) async throws -> CPListTemplate {
        let template = try await loadTemplate(
            from: source,
            bundle: bundle,
            interfaceController: interfaceController,
            title: title,
            includesHistory: includesHistory,
            currentVersion: currentVersion,
            continueButtonTitle: continueButtonTitle,
            onContinue: onContinue
        )

        return try await installRootTemplate(
            template,
            animated: animated
        ) { template, animated in
            try await interfaceController.setRootTemplate(
                template,
                animated: animated
            )
        }
    }

    static func installRootTemplate(
        _ template: CPListTemplate,
        animated: Bool,
        using presentation: RootPresentation
    ) async throws -> CPListTemplate {
        try Task.checkCancellation()

        let succeeded = try await presentation(template, animated)
        guard succeeded else {
            throw SwiftNEWCarPlayError.templatePresentationFailed
        }
        return template
    }

    private static var defaultTitle: String {
        String(localized: "Current Version", bundle: .module)
    }

    private static var defaultContinueButtonTitle: String {
        String(localized: "Continue", bundle: .module)
    }

    private static var defaultHistoryButtonTitle: String {
        String(localized: "History", bundle: .module)
    }

    private static var defaultHistoryReturnButtonTitle: String {
        String(localized: "Return", bundle: .module)
    }

    private static func configureHistoryButton(
        on template: CPListTemplate,
        currentSections: [CPListSection],
        historySections: [CPListSection]
    ) {
        guard !historySections.isEmpty else { return }

        let switcher = HistorySwitcher(
            template: template,
            currentSections: currentSections,
            historySections: historySections,
            historyTitle: defaultHistoryButtonTitle,
            returnTitle: defaultHistoryReturnButtonTitle
        )
        let button = CPBarButton(title: defaultHistoryButtonTitle) { button in
            Task { @MainActor in
                switcher.toggle(using: button)
            }
        }
        button.buttonStyle = .none
        var buttons = template.trailingNavigationBarButtons
        buttons.append(button)
        template.trailingNavigationBarButtons = Array(buttons.prefix(2))
    }

    private static func configureContinueButton(
        on template: CPListTemplate,
        interfaceController: CPInterfaceController?,
        title: String?,
        action: ContinueAction?
    ) {
        guard let action else { return }

        let button = CPBarButton(
            title: normalized(title) ?? defaultContinueButtonTitle
        ) { [weak interfaceController] _ in
            Task { @MainActor [weak interfaceController] in
                guard let interfaceController else { return }
                action(interfaceController)
            }
        }
        button.buttonStyle = .rounded
        var buttons = template.trailingNavigationBarButtons
        buttons.append(button)
        template.trailingNavigationBarButtons = Array(buttons.prefix(2))
    }

    static func makeSections(
        from releases: [Vmodel],
        interfaceController: CPInterfaceController?,
        detailPresentation: DetailPresentation?
    ) -> [CPListSection] {
        let maximumSections = CPListTemplate.maximumSectionCount
        var remainingItems = CPListTemplate.maximumItemCount
        var sections: [CPListSection] = []

        for release in releases where sections.count < maximumSections && remainingItems > 0 {
            let changes = Array(release.new.prefix(remainingItems))
            guard !changes.isEmpty else { continue }

            let items = changes.map {
                makeListItem(
                    for: $0,
                    interfaceController: interfaceController,
                    detailPresentation: detailPresentation
                )
            }
            let version = normalized(release.version)
                ?? normalized(release.subVersion)
                ?? release.version
            sections.append(
                CPListSection(
                    items: items,
                    header: String(localized: "Version \(version)", bundle: .module),
                    sectionIndexTitle: nil
                )
            )
            remainingItems -= items.count
        }

        return sections
    }

    private static func makeListItem(
        for change: Model,
        interfaceController: CPInterfaceController?,
        detailPresentation: DetailPresentation?
    ) -> CPListItem {
        let item = CPListItem(
            text: normalized(change.title),
            detailText: normalized(change.subtitle),
            image: makeListImage(
                systemName: change.displayedIcon,
                traitCollection: interfaceController?.carTraitCollection
                    ?? fallbackCarPlayTraits
            )
        )
        item.accessoryType = .disclosureIndicator
        item.handler = { [weak interfaceController] _, completion in
            if let detailPresentation {
                let detailTemplate = makeDetailTemplate(for: change)
                detailPresentation(detailTemplate, completion)
                return
            }

            guard let interfaceController else {
                completion()
                return
            }

            let detailTemplate = makeDetailTemplate(for: change)
            interfaceController.pushTemplate(
                detailTemplate,
                animated: true
            ) { _, _ in
                completion()
            }
        }
        return item
    }

    private static var fallbackCarPlayTraits: UITraitCollection {
        UITraitCollection(traitsFrom: [
            UITraitCollection(userInterfaceIdiom: .carPlay),
            UITraitCollection(displayScale: 2),
            UITraitCollection(userInterfaceStyle: .light)
        ])
    }

    /// Flattens an SF Symbol into display-ready CarPlay light/dark bitmaps.
    ///
    /// Tinting a symbol-backed `UIImage` is insufficient because CarPlay can
    /// serialize and render it again as a monochrome template image.
    static func makeListImage(
        systemName: String,
        traitCollection: UITraitCollection,
        tintColor: UIColor = .systemBlue,
        canvasSize: CGSize = CPListItem.maximumImageSize
    ) -> UIImage? {
        guard canvasSize.width.isFinite,
              canvasSize.height.isFinite,
              canvasSize.width > 0,
              canvasSize.height > 0
        else { return nil }

        let hasValidDisplayScale = traitCollection.displayScale.isFinite
            && traitCollection.displayScale > 0
        let displayScale = hasValidDisplayScale ? traitCollection.displayScale : 2
        let lightTraits = listImageTraits(
            basedOn: traitCollection,
            style: .light,
            displayScale: displayScale
        )
        let darkTraits = listImageTraits(
            basedOn: traitCollection,
            style: .dark,
            displayScale: displayScale
        )

        guard let lightImage = rasterizedListSymbol(
            systemName: systemName,
            traitCollection: lightTraits,
            tintColor: tintColor,
            canvasSize: canvasSize
        ), let darkImage = rasterizedListSymbol(
            systemName: systemName,
            traitCollection: darkTraits,
            tintColor: tintColor,
            canvasSize: canvasSize
        ) else {
            // Preserve nil for invalid or unavailable SF Symbol names.
            return nil
        }

        let imageAsset = UIImageAsset()
        imageAsset.register(lightImage, with: lightTraits)
        imageAsset.register(darkImage, with: darkTraits)

        let requestedStyle: UIUserInterfaceStyle =
            traitCollection.userInterfaceStyle == .dark ? .dark : .light
        return imageAsset.image(
            with: listImageTraits(
                basedOn: traitCollection,
                style: requestedStyle,
                displayScale: displayScale
            )
        )
        .withRenderingMode(.alwaysOriginal)
    }

    private static func rasterizedListSymbol(
        systemName: String,
        traitCollection: UITraitCollection,
        tintColor: UIColor,
        canvasSize: CGSize
    ) -> UIImage? {
        let configuration = UIImage.SymbolConfiguration(
            pointSize: min(canvasSize.width, canvasSize.height),
            weight: .regular
        )
        guard let symbol = UIImage(
            systemName: systemName,
            compatibleWith: traitCollection
        )?.applyingSymbolConfiguration(configuration),
              symbol.size.width > 0,
              symbol.size.height > 0
        else { return nil }

        let tintedSymbol = symbol.withTintColor(
            tintColor.resolvedColor(with: traitCollection),
            renderingMode: .alwaysOriginal
        )
        let fitScale = min(
            canvasSize.width / symbol.size.width,
            canvasSize.height / symbol.size.height
        )
        guard fitScale.isFinite, fitScale > 0 else { return nil }

        let fittedSize = CGSize(
            width: symbol.size.width * fitScale,
            height: symbol.size.height * fitScale
        )
        let drawingRect = CGRect(
            x: (canvasSize.width - fittedSize.width) / 2,
            y: (canvasSize.height - fittedSize.height) / 2,
            width: fittedSize.width,
            height: fittedSize.height
        )

        let format = UIGraphicsImageRendererFormat(for: traitCollection)
        format.scale = traitCollection.displayScale
        format.opaque = false
        format.preferredRange = .standard
        let renderer = UIGraphicsImageRenderer(
            size: canvasSize,
            format: format
        )

        return renderer.image { context in
            context.cgContext.clear(CGRect(origin: .zero, size: canvasSize))
            tintedSymbol.draw(in: drawingRect)
        }
        .withRenderingMode(.alwaysOriginal)
    }

    private static func listImageTraits(
        basedOn base: UITraitCollection,
        style: UIUserInterfaceStyle,
        displayScale: CGFloat
    ) -> UITraitCollection {
        let idiom: UIUserInterfaceIdiom = base.userInterfaceIdiom == .unspecified
            ? .carPlay
            : base.userInterfaceIdiom
        return UITraitCollection(traitsFrom: [
            base,
            UITraitCollection(userInterfaceIdiom: idiom),
            UITraitCollection(displayScale: displayScale),
            UITraitCollection(userInterfaceStyle: style)
        ])
    }

    private static func makeDetailTemplate(for change: Model) -> CPListTemplate {
        let detailItem = CPListItem(
            text: normalized(change.subtitle) ?? normalized(change.title),
            detailText: normalized(change.body)
        )
        return CPListTemplate(
            title: normalized(change.title),
            sections: [CPListSection(items: [detailItem])]
        )
    }

    private static func normalized(_ value: String?) -> String? {
        guard let value else { return nil }
        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return normalized.isEmpty ? nil : normalized
    }
}

/// Errors produced while presenting SwiftNEW content in CarPlay.
@available(iOS 15.0, *)
public enum SwiftNEWCarPlayError: Error, Equatable {
    /// CarPlay did not install the generated root template.
    case templatePresentationFailed
}

@available(iOS 15.0, *)
extension SwiftNEWCarPlayError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .templatePresentationFailed:
            return String(localized: "Unable to load release notes.", bundle: .module)
        }
    }
}
#endif

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
    /// Builds a CarPlay list template from already-decoded release notes.
    ///
    /// Each release is represented by a section. Selecting a change pushes a
    /// second list template containing its full description.
    ///
    /// - Parameters:
    ///   - releases: Release notes to display.
    ///   - interfaceController: The controller supplied to the host app's CarPlay scene delegate.
    ///   - title: A custom navigation title. Pass `nil` to use a localized default.
    ///   - includesHistory: Whether to include parseable releases no newer than the current app version.
    ///   - currentVersion: The installed version to prefer. Pass `nil` to use the host app version.
    /// - Returns: A template capped to CarPlay's runtime section and item limits.
    public static func makeTemplate(
        releases: [Vmodel],
        interfaceController: CPInterfaceController,
        title: String? = nil,
        includesHistory: Bool = false,
        currentVersion: String? = nil
    ) -> CPListTemplate {
        let resolvedVersion = normalized(currentVersion) ?? Bundle.version
        let visibleReleases = SwiftNEWCarPlayReleaseSelector.releases(
            from: releases,
            currentVersion: resolvedVersion,
            includesHistory: includesHistory
        )
        let sections = makeSections(
            from: visibleReleases,
            interfaceController: interfaceController
        )
        let template = CPListTemplate(
            title: normalized(title) ?? defaultTitle,
            sections: sections
        )
        template.emptyViewTitleVariants = [
            String(localized: "No release notes available.", bundle: .module)
        ]
        return template
    }

    /// Builds the initial root template to install synchronously when a CarPlay scene connects.
    ///
    /// CarPlay requires the host to set a root template before its scene-connect
    /// callback returns. Install this template first, then load and replace it
    /// asynchronously with ``setRootTemplate(on:from:bundle:title:includesHistory:currentVersion:animated:)``.
    public static func makeLoadingTemplate(title: String? = nil) -> CPListTemplate {
        let template = CPListTemplate(
            title: normalized(title) ?? defaultTitle,
            sections: []
        )
        template.emptyViewTitleVariants = [
            String(localized: "Loading...", bundle: .module)
        ]
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
            currentVersion: currentVersion
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
        try Task.checkCancellation()

        let succeeded = try await interfaceController.setRootTemplate(
            template,
            animated: animated
        )
        guard succeeded else {
            throw SwiftNEWCarPlayError.templatePresentationFailed
        }
        return template
    }

    private static var defaultTitle: String {
        String(localized: "Current Version", bundle: .module)
    }

    private static func makeSections(
        from releases: [Vmodel],
        interfaceController: CPInterfaceController
    ) -> [CPListSection] {
        let maximumSections = CPListTemplate.maximumSectionCount
        var remainingItems = CPListTemplate.maximumItemCount
        var sections: [CPListSection] = []

        for release in releases where sections.count < maximumSections && remainingItems > 0 {
            let changes = Array(release.new.prefix(remainingItems))
            guard !changes.isEmpty else { continue }

            let items = changes.map {
                makeListItem(for: $0, interfaceController: interfaceController)
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
        interfaceController: CPInterfaceController
    ) -> CPListItem {
        let item = CPListItem(
            text: normalized(change.title),
            detailText: normalized(change.subtitle),
            image: UIImage(systemName: change.displayedIcon)
        )
        item.accessoryType = .disclosureIndicator
        item.handler = { [weak interfaceController] _, completion in
            guard let interfaceController else {
                completion()
                return
            }

            let detailItem = CPListItem(
                text: normalized(change.subtitle) ?? normalized(change.title),
                detailText: normalized(change.body)
            )
            let detailTemplate = CPListTemplate(
                title: normalized(change.title),
                sections: [CPListSection(items: [detailItem])]
            )
            interfaceController.pushTemplate(
                detailTemplate,
                animated: true
            ) { _, _ in
                completion()
            }
        }
        return item
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

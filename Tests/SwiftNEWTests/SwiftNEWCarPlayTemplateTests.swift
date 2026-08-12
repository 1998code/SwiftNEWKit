//
//  SwiftNEWCarPlayTemplateTests.swift
//  SwiftNEWTests
//

#if os(iOS) && canImport(CarPlay) && !targetEnvironment(macCatalyst)
import CarPlay
import Foundation
import Testing
import UIKit
@testable import SwiftNEW

@MainActor
@Test func carPlayLoadingAndEmptyTemplatesNormalizeTheirTitles() {
    let defaultLoading = SwiftNEWCarPlayTemplateFactory.makeLoadingTemplate()
    let blankLoading = SwiftNEWCarPlayTemplateFactory.makeLoadingTemplate(title: " \n ")
    let customLoading = SwiftNEWCarPlayTemplateFactory.makeLoadingTemplate(
        title: "  Road Notes\n"
    )
    let empty = SwiftNEWCarPlayTemplateFactory.makeTemplate(
        releases: [],
        interfaceController: nil,
        title: "  Road Notes\n",
        includesHistory: false,
        currentVersion: nil,
        detailPresentation: nil
    )

    #expect(customLoading.title == "Road Notes")
    #expect(blankLoading.title == defaultLoading.title)
    #expect(!defaultLoading.emptyViewTitleVariants.isEmpty)
    #expect(defaultLoading.trailingNavigationBarButtons.isEmpty)
    #expect(empty.title == "Road Notes")
    #expect(empty.sections.isEmpty)
    #expect(!empty.emptyViewTitleVariants.isEmpty)
    #expect(empty.trailingNavigationBarButtons.isEmpty)
}

@MainActor
@Test func carPlayContinueButtonIsTrailingOnLoadingAndLoadedTemplates() {
    let onContinue: SwiftNEWCarPlayTemplateFactory.ContinueAction = { _ in }
    let loading = SwiftNEWCarPlayTemplateFactory.buildLoadingTemplate(
        title: "  Loading Notes\n",
        interfaceController: nil,
        continueButtonTitle: " \n ",
        onContinue: onContinue
    )
    let customLoading = SwiftNEWCarPlayTemplateFactory.buildLoadingTemplate(
        title: nil,
        interfaceController: nil,
        continueButtonTitle: "  Enter App\n",
        onContinue: onContinue
    )
    let loaded = SwiftNEWCarPlayTemplateFactory.makeTemplate(
        releases: [
            makeCarPlayTemplateRelease(
                version: "1.0.0",
                changes: [makeCarPlayTemplateChange(title: "Feature")]
            )
        ],
        interfaceController: nil,
        title: nil,
        includesHistory: false,
        currentVersion: "1.0.0",
        detailPresentation: nil,
        onContinue: onContinue
    )

    #expect(loading.title == "Loading Notes")
    #expect(loading.leadingNavigationBarButtons.isEmpty)
    #expect(loading.trailingNavigationBarButtons.count == 1)
    #expect(loading.trailingNavigationBarButtons.first?.title?.isEmpty == false)
    #expect(loading.trailingNavigationBarButtons.first?.buttonStyle == .rounded)
    #expect(customLoading.trailingNavigationBarButtons.first?.title == "Enter App")
    #expect(loaded.leadingNavigationBarButtons.isEmpty)
    #expect(loaded.trailingNavigationBarButtons.count == 1)
    #expect(
        loaded.trailingNavigationBarButtons.first?.title
            == loading.trailingNavigationBarButtons.first?.title
    )
}

@MainActor
@Test func carPlayHistoryButtonSeparatesOlderReleasesAndReturnsToCurrent() throws {
    let releases = [
        makeCarPlayTemplateRelease(
            version: "3.0.0",
            changes: [makeCarPlayTemplateChange(title: "Future")]
        ),
        makeCarPlayTemplateRelease(
            version: "2.0.0",
            changes: [makeCarPlayTemplateChange(title: "Current")]
        ),
        makeCarPlayTemplateRelease(
            version: "1.0.0",
            changes: [makeCarPlayTemplateChange(title: "Previous")]
        )
    ]
    let template = SwiftNEWCarPlayTemplateFactory.makeTemplate(
        releases: releases,
        interfaceController: nil,
        title: "What's New",
        includesHistory: true,
        currentVersion: "2.0.0",
        detailPresentation: nil,
        onContinue: { _ in }
    )

    #expect(template.sections.count == 1)
    #expect(template.sections.first?.header?.hasSuffix("2.0.0") == true)
    #expect(template.trailingNavigationBarButtons.count == 2)
    #expect(
        template.trailingNavigationBarButtons.allSatisfy {
            $0.title?.isEmpty == false
        }
    )
    #expect(template.trailingNavigationBarButtons.first?.buttonStyle == .rounded)
    #expect(template.trailingNavigationBarButtons.last?.buttonStyle == CPBarButtonStyle.none)

    let currentSections = template.sections
    let historySections = SwiftNEWCarPlayTemplateFactory.makeSections(
        from: [releases[2]],
        interfaceController: nil,
        detailPresentation: nil
    )
    let historyButton = CPBarButton(title: "History") { _ in }
    let switcher = SwiftNEWCarPlayTemplateFactory.HistorySwitcher(
        template: template,
        currentSections: currentSections,
        historySections: historySections,
        historyTitle: "History",
        returnTitle: "Return"
    )

    switcher.toggle(using: historyButton)
    #expect(switcher.isShowingHistory)
    #expect(historyButton.title == "Return")
    #expect(template.sections.first?.header?.hasSuffix("1.0.0") == true)

    switcher.toggle(using: historyButton)
    #expect(!switcher.isShowingHistory)
    #expect(historyButton.title == "History")
    #expect(template.sections.first?.header?.hasSuffix("2.0.0") == true)
}

@MainActor
@Test func carPlayHistoryButtonIsHiddenWithoutOlderContent() {
    let template = SwiftNEWCarPlayTemplateFactory.makeTemplate(
        releases: [
            makeCarPlayTemplateRelease(
                version: "1.0.0",
                changes: [makeCarPlayTemplateChange(title: "Current")]
            )
        ],
        interfaceController: nil,
        title: nil,
        includesHistory: true,
        currentVersion: "1.0.0",
        detailPresentation: nil
    )

    #expect(template.sections.count == 1)
    #expect(template.trailingNavigationBarButtons.isEmpty)
}

@MainActor
@Test func carPlayHistoryRemainsReachableWhenCurrentReleaseIsMissing() {
    let template = SwiftNEWCarPlayTemplateFactory.makeTemplate(
        releases: [
            makeCarPlayTemplateRelease(
                version: "1.0.0",
                changes: [makeCarPlayTemplateChange(title: "Previous")]
            )
        ],
        interfaceController: nil,
        title: nil,
        includesHistory: true,
        currentVersion: "2.0.0",
        detailPresentation: nil
    )

    #expect(template.sections.isEmpty)
    #expect(template.trailingNavigationBarButtons.count == 1)
    #expect(template.trailingNavigationBarButtons.first?.buttonStyle == CPBarButtonStyle.none)
}

@MainActor
@Test func carPlayTemplateNormalizesContentAndCompletesWithoutAController() throws {
    let release = makeCarPlayTemplateRelease(
        version: " \n ",
        subVersion: " 2.0.0 ",
        changes: [
            makeCarPlayTemplateChange(
                title: "  Feature  ",
                subtitle: "\n Summary ",
                body: " Details "
            )
        ]
    )
    let template = SwiftNEWCarPlayTemplateFactory.makeTemplate(
        releases: [release],
        interfaceController: nil,
        title: nil,
        includesHistory: false,
        currentVersion: "2.0.0",
        detailPresentation: nil
    )

    let section = try #require(template.sections.first)
    let item = try #require(section.items.first as? CPListItem)
    #expect(section.header?.hasSuffix("2.0.0") == true)
    #expect(item.text == "Feature")
    #expect(item.detailText == "Summary")
    #expect(item.accessoryType == .disclosureIndicator)
    #expect(item.image?.renderingMode == .alwaysOriginal)
    #expect(item.image?.isSymbolImage == false)
    #expect(item.image?.cgImage != nil)

    var didComplete = false
    let handler = try #require(item.handler)
    handler(item) {
        didComplete = true
    }
    #expect(didComplete)
}

@MainActor
@Test func carPlayListImageIsDisplayReadyCarScaleRaster() throws {
    let traits = UITraitCollection(traitsFrom: [
        UITraitCollection(userInterfaceIdiom: .carPlay),
        UITraitCollection(displayScale: 3),
        UITraitCollection(userInterfaceStyle: .dark)
    ])
    let canvasSize = CGSize(width: 24, height: 24)
    let tintColor = UIColor { traits in
        traits.userInterfaceStyle == .dark ? .green : .red
    }
    let image = try #require(
        SwiftNEWCarPlayTemplateFactory.makeListImage(
            systemName: "circle.fill",
            traitCollection: traits,
            tintColor: tintColor,
            canvasSize: canvasSize
        )
    )
    let cgImage = try #require(image.cgImage)
    let imageAsset = try #require(image.imageAsset)

    #expect(!image.isSymbolImage)
    #expect(image.renderingMode == .alwaysOriginal)
    #expect(image.size == canvasSize)
    #expect(image.scale == 3)
    #expect(cgImage.width == 72)
    #expect(cgImage.height == 72)

    let lightTraits = UITraitCollection(traitsFrom: [
        traits,
        UITraitCollection(userInterfaceStyle: .light)
    ])
    let darkTraits = UITraitCollection(traitsFrom: [
        traits,
        UITraitCollection(userInterfaceStyle: .dark)
    ])
    let lightImage = imageAsset.image(with: lightTraits)
    let darkImage = imageAsset.image(with: darkTraits)
    #expect(lightImage.cgImage != nil)
    #expect(darkImage.cgImage != nil)
    #expect(!lightImage.isSymbolImage)
    #expect(!darkImage.isSymbolImage)
    #expect(lightImage.renderingMode == .alwaysOriginal)
    #expect(darkImage.renderingMode == .alwaysOriginal)
    #expect(lightImage.scale == 3)
    #expect(darkImage.scale == 3)
    #expect(lightImage.pngData() != darkImage.pngData())
}

@MainActor
@Test func carPlayListImageKeepsInvalidSymbolsNil() {
    let traits = UITraitCollection(traitsFrom: [
        UITraitCollection(userInterfaceIdiom: .carPlay),
        UITraitCollection(displayScale: 2)
    ])

    #expect(
        SwiftNEWCarPlayTemplateFactory.makeListImage(
            systemName: "swiftnew.symbol.that.does.not.exist",
            traitCollection: traits,
            canvasSize: CGSize(width: 24, height: 24)
        ) == nil
    )
}

@MainActor
@Test func carPlaySelectionBuildsNormalizedDetailTemplates() throws {
    let changes = [
        makeCarPlayTemplateChange(
            title: "  Feature  ",
            subtitle: "  Summary  ",
            body: " \n "
        ),
        makeCarPlayTemplateChange(
            title: "  Title fallback  ",
            subtitle: " \t ",
            body: "  Full details  "
        )
    ]
    var presentedTemplates: [CPListTemplate] = []
    var completionCount = 0
    let template = SwiftNEWCarPlayTemplateFactory.makeTemplate(
        releases: [
            makeCarPlayTemplateRelease(version: "1.0.0", changes: changes)
        ],
        interfaceController: nil,
        title: nil,
        includesHistory: false,
        currentVersion: "1.0.0",
        detailPresentation: { template, completion in
            presentedTemplates.append(template)
            completion()
        }
    )

    let items = try #require(template.sections.first?.items)
    for selectableItem in items {
        let item = try #require(selectableItem as? CPListItem)
        let handler = try #require(item.handler)
        handler(item) {
            completionCount += 1
        }
    }

    #expect(completionCount == 2)
    #expect(presentedTemplates.count == 2)
    #expect(presentedTemplates.first?.title == "Feature")
    #expect(presentedTemplates.last?.title == "Title fallback")

    let firstDetail = try #require(
        presentedTemplates.first?.sections.first?.items.first as? CPListItem
    )
    let secondDetail = try #require(
        presentedTemplates.last?.sections.first?.items.first as? CPListItem
    )
    #expect(firstDetail.text == "Summary")
    #expect(firstDetail.detailText == nil)
    #expect(secondDetail.text == "Title fallback")
    #expect(secondDetail.detailText == "Full details")
}

@MainActor
@Test func carPlayTemplateHonorsSectionAndItemLimits() {
    let maximumSections = CPListTemplate.maximumSectionCount
    let maximumItems = CPListTemplate.maximumItemCount
    let releaseCount = maximumSections + 2
    let sectionReleases = [
        makeCarPlayTemplateRelease(version: "9998.0.0", changes: [])
    ] + (0..<releaseCount).map { index in
        makeCarPlayTemplateRelease(
            version: "\(index + 1).0.0",
            changes: [makeCarPlayTemplateChange(title: "Change \(index)")]
        )
    }
    let sectionLimitedSections = SwiftNEWCarPlayTemplateFactory.makeSections(
        from: sectionReleases,
        interfaceController: nil,
        detailPresentation: nil
    )

    #expect(
        sectionLimitedSections.count
            == min(maximumSections, maximumItems)
    )

    let manyChanges = (0..<(maximumItems + 2)).map { index in
        makeCarPlayTemplateChange(title: "Change \(index)")
    }
    let itemLimitedTemplate = SwiftNEWCarPlayTemplateFactory.makeTemplate(
        releases: [
            makeCarPlayTemplateRelease(
                version: "1.0.0",
                changes: manyChanges
            )
        ],
        interfaceController: nil,
        title: nil,
        includesHistory: false,
        currentVersion: "1.0.0",
        detailPresentation: nil,
        onContinue: { _ in }
    )

    #expect(itemLimitedTemplate.sections.count == 1)
    #expect(itemLimitedTemplate.itemCount == maximumItems)
    #expect(itemLimitedTemplate.trailingNavigationBarButtons.count == 1)
}

@MainActor
@Test func carPlayTemplateLoadsBundledReleaseNotesWithoutAController() async throws {
    let template = try await SwiftNEWCarPlayTemplateFactory.loadTemplate(
        from: "swiftnew-test-data",
        bundle: .module,
        interfaceController: nil,
        title: "  Loaded  ",
        includesHistory: false,
        currentVersion: "1.0",
        detailPresentation: nil,
        onContinue: { _ in }
    )

    #expect(template.title == "Loaded")
    #expect(template.sections.count == 1)
    #expect(template.itemCount == 1)
    #expect(template.trailingNavigationBarButtons.count == 1)
    #expect(template.trailingNavigationBarButtons.first?.title?.isEmpty == false)
}

@MainActor
@Test func carPlayRootInstallationReportsSuccessAndFailure() async throws {
    let template = SwiftNEWCarPlayTemplateFactory.makeLoadingTemplate()
    var receivedAnimatedValue: Bool?
    let installed = try await SwiftNEWCarPlayTemplateFactory.installRootTemplate(
        template,
        animated: true
    ) { receivedTemplate, animated in
        #expect(receivedTemplate === template)
        receivedAnimatedValue = animated
        return true
    }

    #expect(installed === template)
    #expect(receivedAnimatedValue == true)

    do {
        _ = try await SwiftNEWCarPlayTemplateFactory.installRootTemplate(
            template,
            animated: false,
            using: { _, _ in false }
        )
        Issue.record("Expected a failed CarPlay presentation")
    } catch let error as SwiftNEWCarPlayError {
        #expect(error == .templatePresentationFailed)
        #expect(error.errorDescription?.isEmpty == false)
    } catch {
        Issue.record("Expected SwiftNEWCarPlayError, received \(error)")
    }
}

@MainActor
@Test func carPlayRootInstallationChecksCancellationBeforePresentation() async {
    let template = SwiftNEWCarPlayTemplateFactory.makeLoadingTemplate()
    var attemptedPresentation = false
    let task = Task { @MainActor in
        withUnsafeCurrentTask { task in
            task?.cancel()
        }
        return try await SwiftNEWCarPlayTemplateFactory.installRootTemplate(
            template,
            animated: false
        ) { _, _ in
            attemptedPresentation = true
            return true
        }
    }

    do {
        _ = try await task.value
        Issue.record("Expected cancellation before CarPlay presentation")
    } catch is CancellationError {
        #expect(!attemptedPresentation)
    } catch {
        Issue.record("Expected CancellationError, received \(error)")
    }
}

private func makeCarPlayTemplateRelease(
    version: String,
    subVersion: String? = nil,
    changes: [Model]
) -> Vmodel {
    Vmodel(version: version, subVersion: subVersion, new: changes)
}

private func makeCarPlayTemplateChange(
    title: String,
    subtitle: String = "Summary",
    body: String = "Details"
) -> Model {
    Model(
        icon: "sparkles",
        title: title,
        subtitle: subtitle,
        body: body
    )
}
#endif

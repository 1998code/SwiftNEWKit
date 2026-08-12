//
//  CarPlayDemo.swift
//  What's New?
//

#if os(iOS) && canImport(CarPlay) && !targetEnvironment(macCatalyst)
import CarPlay
import SwiftNEW
import UIKit

/// Exercises SwiftNEW's public CarPlay API with the Demo's bundled `data.json`.
///
/// `CarPlayScene-Info.plist` registers this delegate for the CarPlay scene. The
/// Demo must be signed with the approved CarPlay Driving Task capability.
@MainActor
final class CarPlayDemoSceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    private var interfaceController: CPInterfaceController?
    private var loadingTask: Task<Void, Never>?
    private var isPresentingReleaseNotes = false
    private var releaseNotesPresentationID = 0

    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didConnect interfaceController: CPInterfaceController
    ) {
        connect(interfaceController)
    }

    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didDisconnectInterfaceController interfaceController: CPInterfaceController
    ) {
        disconnect(interfaceController)
    }

    private func connect(_ interfaceController: CPInterfaceController) {
        loadingTask?.cancel()
        releaseNotesPresentationID &+= 1
        self.interfaceController = interfaceController
        isPresentingReleaseNotes = false

        presentReleaseNotes(
            on: interfaceController,
            animated: false
        )
    }

    private func presentReleaseNotes(
        on interfaceController: CPInterfaceController,
        animated: Bool,
        selectionCompletion: @escaping () -> Void = {}
    ) {
        guard self.interfaceController === interfaceController,
              !isPresentingReleaseNotes
        else {
            selectionCompletion()
            return
        }

        loadingTask?.cancel()
        loadingTask = nil
        isPresentingReleaseNotes = true
        releaseNotesPresentationID &+= 1
        let presentationID = releaseNotesPresentationID

        let loadingTemplate = SwiftNEWCarPlayTemplateFactory.makeLoadingTemplate(
            title: "What's New",
            interfaceController: interfaceController,
            onContinue: { [weak self] interfaceController in
                self?.showMainContent(on: interfaceController)
            }
        )
        interfaceController.setRootTemplate(
            loadingTemplate,
            animated: animated
        ) { [weak self] succeeded, _ in
            selectionCompletion()
            guard let self,
                  self.interfaceController === interfaceController,
                  self.releaseNotesPresentationID == presentationID,
                  self.isPresentingReleaseNotes
            else { return }
            guard succeeded else {
                self.showMainContent(on: interfaceController)
                return
            }

            self.loadingTask = Task { @MainActor [weak self] in
                do {
                    _ = try await SwiftNEWCarPlayTemplateFactory.setRootTemplate(
                        on: interfaceController,
                        from: "data",
                        bundle: .main,
                        title: "What's New",
                        includesHistory: true,
                        currentVersion: "6.6",
                        onContinue: { [weak self] interfaceController in
                            self?.showMainContent(on: interfaceController)
                        }
                    )
                    guard let self,
                          self.interfaceController === interfaceController
                    else { return }
                    guard self.releaseNotesPresentationID == presentationID else {
                        if !self.isPresentingReleaseNotes {
                            // Continue may have won while CarPlay was replacing the root.
                            self.showMainContent(on: interfaceController)
                        }
                        return
                    }
                    self.loadingTask = nil
                    if !self.isPresentingReleaseNotes {
                        // Continue may have won while CarPlay was replacing the root.
                        self.showMainContent(on: interfaceController)
                    }
                } catch is CancellationError {
                    // Continue or a CarPlay disconnect cancelled loading.
                    guard let self,
                          self.interfaceController === interfaceController,
                          self.releaseNotesPresentationID == presentationID
                            || !self.isPresentingReleaseNotes
                    else { return }
                    self.showMainContent(on: interfaceController)
                } catch {
                    guard let self,
                          self.interfaceController === interfaceController,
                          self.releaseNotesPresentationID == presentationID
                            || !self.isPresentingReleaseNotes
                    else { return }
                    self.showMainContent(on: interfaceController)
                }
            }
        }
    }

    /// Replaces the onboarding stack with the host app's native CarPlay UI.
    ///
    /// A production app should replace this sample template with the root
    /// template appropriate for its approved CarPlay category.
    private func showMainContent(on interfaceController: CPInterfaceController) {
        guard self.interfaceController === interfaceController else { return }

        isPresentingReleaseNotes = false
        releaseNotesPresentationID &+= 1
        loadingTask?.cancel()
        loadingTask = nil
        interfaceController.setRootTemplate(
            makeMainContentTemplate(on: interfaceController),
            animated: true
        ) { _, _ in }
    }

    private func makeMainContentTemplate(
        on interfaceController: CPInterfaceController
    ) -> CPListTemplate {
        let item = CPListItem(
            text: "What's New",
            detailText: "View release notes again"
        )
        item.accessoryType = .disclosureIndicator
        item.handler = { [weak self, weak interfaceController] _, completion in
            guard let self, let interfaceController else {
                completion()
                return
            }
            self.presentReleaseNotes(
                on: interfaceController,
                animated: true,
                selectionCompletion: completion
            )
        }
        return CPListTemplate(
            title: "SwiftNEW for CarPlay",
            sections: [CPListSection(items: [item])]
        )
    }

    private func disconnect(_ interfaceController: CPInterfaceController) {
        guard self.interfaceController === interfaceController else { return }
        isPresentingReleaseNotes = false
        releaseNotesPresentationID &+= 1
        loadingTask?.cancel()
        loadingTask = nil
        self.interfaceController = nil
    }
}
#endif

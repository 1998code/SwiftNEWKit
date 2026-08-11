//
//  CarPlayDemo.swift
//  What's New?
//

#if os(iOS) && canImport(CarPlay) && !targetEnvironment(macCatalyst)
import CarPlay
import SwiftNEW
import UIKit

/// Registers the Demo's CarPlay scene for the test host.
///
/// Add the CarPlay category Apple approves to the Demo entitlement file and
/// use a provisioning profile containing that same managed capability.
@MainActor
final class CarPlayDemoAppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(
            name: nil,
            sessionRole: connectingSceneSession.role
        )

        if connectingSceneSession.role == .carTemplateApplication {
            configuration.sceneClass = CPTemplateApplicationScene.self
            configuration.delegateClass = CarPlayDemoSceneDelegate.self
        }

        return configuration
    }
}

/// Exercises SwiftNEW's public CarPlay API with the Demo's bundled `data.json`.
@MainActor
final class CarPlayDemoSceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    private var interfaceController: CPInterfaceController?
    private var loadingTask: Task<Void, Never>?

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
        self.interfaceController = interfaceController

        let loadingTemplate = SwiftNEWCarPlayTemplateFactory.makeLoadingTemplate(
            title: "SwiftNEW Demo"
        )
        interfaceController.setRootTemplate(
            loadingTemplate,
            animated: false
        ) { [weak self] succeeded, _ in
            guard succeeded,
                  self?.interfaceController === interfaceController
            else { return }

            self?.loadingTask = Task { @MainActor [weak self] in
                do {
                    try await SwiftNEWCarPlayTemplateFactory.setRootTemplate(
                        on: interfaceController,
                        from: "data",
                        bundle: .main,
                        title: "SwiftNEW Demo",
                        includesHistory: true,
                        currentVersion: "6.6"
                    )
                } catch is CancellationError {
                    // The CarPlay scene disconnected while data was loading.
                } catch {
                    guard self?.interfaceController === interfaceController else { return }

                    let fallback = CPListTemplate(
                        title: "SwiftNEW Demo",
                        sections: []
                    )
                    fallback.emptyViewTitleVariants = [
                        "Unable to load release notes."
                    ]
                    _ = try? await interfaceController.setRootTemplate(
                        fallback,
                        animated: false
                    )
                }
            }
        }
    }

    private func disconnect(_ interfaceController: CPInterfaceController) {
        guard self.interfaceController === interfaceController else { return }
        loadingTask?.cancel()
        loadingTask = nil
        self.interfaceController = nil
    }
}
#endif

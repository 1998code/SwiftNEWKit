[← Back to README](../README.md)

# 🚘 CarPlay Integration

SwiftNEW provides an iOS-only `CPListTemplate` adapter for approved CarPlay host apps whose update content directly supports their approved in-car use case. It uses the same local or remote JSON format as the SwiftUI view, but presents it with system CarPlay templates:

- the current release is shown by default when the JSON contains an exact installed-version match;
- each change opens a second list with its full description;
- `includesHistory: true` adds older release sections;
- runtime section and item limits are respected automatically;
- opening the CarPlay template does not change SwiftNEW's seen-version state.

> [!IMPORTANT]
> CarPlay is a managed capability. Apple must approve the host app for an eligible CarPlay category before this integration can run on a device or ship on the App Store, and the content shown must still belong to that approved category and be useful while driving. A general product changelog or developer-tools app is not eligible merely because its host already has a CarPlay entitlement. Confirm the intended content with Apple and do not add an unrelated audio, navigation, or other entitlement to work around this requirement. See [Requesting CarPlay Entitlements](https://developer.apple.com/documentation/carplay/requesting-carplay-entitlements).

## 1. Configure the host app

After Apple approves the host app:

1. Enable the approved CarPlay capability for the app's App ID.
2. Let Xcode refresh the managed-capability profile when using automatic signing, or regenerate and download it when using manual signing.
3. Add only the entitlement Apple granted to the iOS app target.
4. Add a CarPlay scene configuration to the iOS app's `Info.plist` scene manifest.

For projects that generate their `Info.plist`, add these values in the target's **Info** settings. For a source plist, merge the CarPlay role into the existing `UIApplicationSceneManifest > UISceneConfigurations` dictionary; do not replace existing phone, Dashboard, or Instrument Cluster scene entries. The CarPlay scene configuration is:

```xml
<key>UIApplicationSceneManifest</key>
<dict>
    <key>UIApplicationSupportsMultipleScenes</key>
    <true/>
    <key>UISceneConfigurations</key>
    <dict>
        <key>CPTemplateApplicationSceneSessionRoleApplication</key>
        <array>
            <dict>
                <key>UISceneClassName</key>
                <string>CPTemplateApplicationScene</string>
                <key>UISceneConfigurationName</key>
                <string>CarPlay</string>
                <key>UISceneDelegateClassName</key>
                <string>$(PRODUCT_MODULE_NAME).CarPlaySceneDelegate</string>
            </dict>
        </array>
    </dict>
</dict>
```

Keep this configuration and the approved entitlement scoped to the iOS target. A Swift package cannot add either one on behalf of its host app.

## 2. Add a CarPlay scene delegate

The example below is for a non-navigation template app. Navigation apps receive `templateApplicationScene(_:didConnect:to:)` with a `CPWindow` and must preserve their navigation window setup; follow Apple's [navigation callback requirements](https://developer.apple.com/documentation/carplay/cptemplateapplicationscenedelegate/templateapplicationscene%28_%3Adidconnect%3Ato%3A%29) instead of copying this lifecycle unchanged.

CarPlay requires the root template request before the connect callback returns. Submit SwiftNEW's loading-template request before returning, then load and replace it asynchronously. Retain the interface controller for the connected scene and cancel in-flight loading when CarPlay disconnects:

```swift
#if os(iOS) && canImport(CarPlay) && !targetEnvironment(macCatalyst)
import CarPlay
import SwiftNEW
import UIKit

@MainActor
final class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    private var interfaceController: CPInterfaceController?
    private var loadingTask: Task<Void, Never>?

    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didConnect interfaceController: CPInterfaceController
    ) {
        self.interfaceController = interfaceController
        let loadingTemplate = SwiftNEWCarPlayTemplateFactory.makeLoadingTemplate()
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
                        includesHistory: false
                    )
                } catch is CancellationError {
                    // The CarPlay scene disconnected while data was loading.
                } catch {
                    guard self?.interfaceController === interfaceController else { return }

                    let fallback = CPListTemplate(title: "What's New", sections: [])
                    fallback.emptyViewTitleVariants = ["Unable to load release notes."]
                    _ = try? await interfaceController.setRootTemplate(
                        fallback,
                        animated: false
                    )
                }
            }
        }
    }

    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didDisconnectInterfaceController interfaceController: CPInterfaceController
    ) {
        guard self.interfaceController === interfaceController else { return }
        loadingTask?.cancel()
        loadingTask = nil
        self.interfaceController = nil
    }
}
#endif
```

Add a local `data.json` file to the iOS app target's bundle, just as you would for the SwiftUI view. A remote source works too:

```swift
// Inside the scene delegate's MainActor loading task:
try await SwiftNEWCarPlayTemplateFactory.setRootTemplate(
    on: interfaceController,
    from: "https://api.example.com/releases.json"
)
```

## 3. Build from decoded data

If the host already owns its data-loading layer, pass decoded models directly. This excerpt runs inside the scene delegate's MainActor loading task and uses its retained `interfaceController`:

```swift
let releases = try await SwiftNEWReleaseNotesLoader.load(
    from: "data",
    bundle: .main
)
let template = SwiftNEWCarPlayTemplateFactory.makeTemplate(
    releases: releases,
    interfaceController: interfaceController,
    title: "Product Updates",
    includesHistory: true,
    currentVersion: "2.4.0"
)

let succeeded = try await interfaceController.setRootTemplate(
    template,
    animated: false
)
guard succeeded else {
    throw SwiftNEWCarPlayError.templatePresentationFailed
}
```

Alternatively, `SwiftNEWReleaseNotesLoader.load(from:bundle:)` loads the shared JSON format without creating either a SwiftUI view or a CarPlay template.

## Scope and safety

The adapter deliberately uses `CPListTemplate` rather than rendering SwiftUI or using `CPInformationTemplate`. The latter is restricted to entitlement-specific categories and use cases, while a list template is available across eligible template-app categories. The root and detail flow stays within two levels and leaves fonts, sizing, interaction limits, and truncation to CarPlay.

Keep the content short and useful while driving. SwiftNEW does not automatically present release notes, open App Store update links, show search, or run visual effects on the vehicle display.

See Apple's [Displaying Content in CarPlay](https://developer.apple.com/documentation/carplay/displaying-content-in-carplay), [`CPListTemplate`](https://developer.apple.com/documentation/carplay/cplisttemplate), and [CarPlay design guidance](https://developer.apple.com/design/human-interface-guidelines/carplay) for the host app's remaining requirements.

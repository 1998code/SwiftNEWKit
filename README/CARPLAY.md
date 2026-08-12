[← Back to README](../README.md)

# 🚘 CarPlay Integration

SwiftNEW provides an iOS-only `CPListTemplate` adapter for approved CarPlay host apps whose update content directly supports their approved in-car use case. It uses the same local or remote JSON format as the SwiftUI view, but presents it with system CarPlay templates:

- the current release is shown by default when the JSON contains an exact installed-version match;
- each change opens a second list with its full description;
- `includesHistory: true` adds a **History** button when older content exists;
  it switches the root list between the current and older releases;
- loading and loaded templates can expose a trailing **Continue** button
  supplied by the host app;
- Continue replaces the release-note root with the host app's native CarPlay
  content template;
- SF Symbol row icons are pre-rasterized as display-ready system-blue light/dark
  bitmaps at the CarPlay display scale, so the remote renderer can't turn them
  into black template glyphs;
- runtime section and item limits are respected automatically;
- opening the CarPlay template does not change SwiftNEW's seen-version state.

> [!IMPORTANT]
> CarPlay is a managed capability. Apple must approve the host app for an eligible CarPlay category before this integration can run on a device or ship on the App Store, and the content shown must still belong to that approved category and be useful while driving. A general product changelog or developer-tools app is not eligible merely because its host already has a CarPlay entitlement. Confirm the intended content with Apple and do not add an unrelated audio, navigation, or other entitlement to work around this requirement. See [Requesting CarPlay Entitlements](https://developer.apple.com/documentation/carplay/requesting-carplay-entitlements).

## Test SwiftNEW with the Demo host

The Xcode Demo is a consumer of the local SwiftNEW package and includes an
iOS-only CarPlay integration harness in `CarPlayDemo.swift`. The harness
registers `CarPlayDemoSceneDelegate` through its iOS-only
`CarPlayScene-Info.plist`, loads the Demo's localized
`data.json`, and exercises `SwiftNEWCarPlayTemplateFactory` loading, history,
detail, Continue-to-content, and repeat What's New flows, with failure and
disconnect handling included. Continue opens the Demo's native
**SwiftNEW for CarPlay** template, whose **What's New** row loads the release
notes again.
It models a non-navigation template host; a navigation app should exercise the
package inside its own `templateApplicationScene(_:didConnect:to:)` lifecycle
so it can preserve the app's real `CPWindow` setup.

The Demo's iOS-only `What_s_New_CarPlay.entitlements` contains Apple's approved
`com.apple.developer.carplay-driving-task` capability. How it is applied is
controlled by `Demo/Signing.xcconfig` (see
[Running the Demo](CONTRIBUTING.md#running-the-demo)):

- **iOS Simulator builds always embed the CarPlay entitlements.** Simulator
  builds are not checked against a provisioning profile, so anyone can run the
  CarPlay demo in a simulator — no Apple CarPlay grant needed. Run the Demo in
  an iOS Simulator and attach the CarPlay display from the Simulator app's
  **I/O** menu.
- **Device builds carry no CarPlay entitlement by default.** Including it
  would make automatic signing fail for every team Apple hasn't approved for
  CarPlay — the Demo wouldn't install on an iPhone at all. With the default,
  the Demo auto-signs and runs on any iPhone with any team (without the
  CarPlay scene). The physical-iPhone flow below requires a team that Apple
  has approved for a CarPlay capability; opt in via
  `Demo/Signing.local.xcconfig` with an App ID and provisioning profile
  containing that same managed capability:

  ```
  CODE_SIGN_ENTITLEMENTS[sdk=iphoneos*] = What's New?/What_s_New_CarPlay.entitlements
  DEMO_BUNDLE_ID = your.approved.bundle.id
  ```

  CarPlay is approved per App ID, so `DEMO_BUNDLE_ID` must be an identifier
  Apple approved for your team, and the entitlement key must match your
  granted category (the Demo's file declares `carplay-driving-task`; use your
  own gitignored entitlements file if your category differs).

With Xcode 27:

1. Connect a physical iPhone by USB and run the **What's New?** Demo on it.
2. Choose **Xcode > Open Developer Tool > Device Hub**.
3. Select the connected iPhone and choose **CarPlay Simulator** from its device
   actions or diagnostics menu.
4. Open **Demo** from the CarPlay Home screen.
5. Select **History**, open an older release-note detail, return, then select
   **Return** to show Version 6.6 again.
6. Select **Continue** to enter the Demo's native **SwiftNEW for CarPlay**
   template.
7. Select its **What's New** row and confirm the loading template and release
   notes appear again.

The Demo deliberately passes `currentVersion: "6.6"` so its bundled fixture
has an exact current release, and enables the History/Return toggle for older
sections. Change those two arguments in `CarPlayDemo.swift` to exercise empty
or current-only states. Apple doesn't provide a category-neutral package
entitlement; if the signing profile doesn't contain the Demo's entitlement,
signing fails or the Demo doesn't appear on the CarPlay Home screen.

## 1. Configure the host app

After Apple approves the host app:

1. Enable the approved CarPlay capability for the app's App ID.
2. Let Xcode refresh the managed-capability profile when using automatic signing, or regenerate and download it when using manual signing.
3. Add only the entitlement Apple granted to the iOS app target.
4. Register a CarPlay scene in the iOS app's scene manifest or app delegate.

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

As an alternative to the manifest, a SwiftUI host can use
`UIApplicationDelegateAdaptor` and return a configuration whose scene class is
`CPTemplateApplicationScene` and delegate class is its CarPlay scene delegate
from `application(_:configurationForConnecting:options:)`. The Demo uses the
manifest approach; don't register the same CarPlay scene both ways.

## 2. Add a CarPlay scene delegate

The example below is for a non-navigation template app. Navigation apps receive `templateApplicationScene(_:didConnect:to:)` with a `CPWindow` and must preserve their navigation window setup; follow Apple's [navigation callback requirements](https://developer.apple.com/documentation/carplay/cptemplateapplicationscenedelegate/templateapplicationscene%28_%3Adidconnect%3Ato%3A%29) instead of copying this lifecycle unchanged.

CarPlay requires the root template request before the connect callback returns.
Submit SwiftNEW's loading-template request before returning, then load and
replace it asynchronously. Give both templates the same Continue callback so
the driver can enter the app while loading or after reading the notes. The
callback cancels in-flight work and replaces the release-note root with the
host's native `CPTemplate`; a phone SwiftUI `ContentView` cannot be placed on a
CarPlay display. A non-cancellation loading failure should also return to that
content rather than strand the driver on an error template. Retain the
interface controller for the connected scene and cancel loading when CarPlay
disconnects. The button title defaults to SwiftNEW's localized **Continue**;
pass `continueButtonTitle:` to customize it, with an empty or whitespace-only
value falling back to that default:

```swift
#if os(iOS) && canImport(CarPlay) && !targetEnvironment(macCatalyst)
import CarPlay
import SwiftNEW
import UIKit

@MainActor
final class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    private var interfaceController: CPInterfaceController?
    private var loadingTask: Task<Void, Never>?
    private var isPresentingReleaseNotes = false

    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didConnect interfaceController: CPInterfaceController
    ) {
        self.interfaceController = interfaceController
        isPresentingReleaseNotes = true

        let continueToContent: SwiftNEWCarPlayTemplateFactory.ContinueAction = {
            [weak self] controller in
            self?.showContent(on: controller)
        }
        let loadingTemplate = SwiftNEWCarPlayTemplateFactory.makeLoadingTemplate(
            interfaceController: interfaceController,
            onContinue: continueToContent
        )
        interfaceController.setRootTemplate(
            loadingTemplate,
            animated: false
        ) { [weak self] succeeded, _ in
            guard self?.interfaceController === interfaceController else { return }
            guard succeeded else {
                self?.showContent(on: interfaceController)
                return
            }
            guard self?.isPresentingReleaseNotes == true else { return }

            self?.loadingTask = Task { @MainActor [weak self] in
                do {
                    _ = try await SwiftNEWCarPlayTemplateFactory.setRootTemplate(
                        on: interfaceController,
                        from: "data",
                        bundle: .main,
                        includesHistory: true,
                        onContinue: continueToContent
                    )
                    guard self?.interfaceController === interfaceController else { return }
                    if self?.isPresentingReleaseNotes == false {
                        // Continue may have won while CarPlay was replacing the root.
                        self?.showContent(on: interfaceController)
                    }
                } catch is CancellationError {
                    // Continue or a CarPlay disconnect cancelled loading.
                    guard self?.interfaceController === interfaceController,
                          self?.isPresentingReleaseNotes == false
                    else { return }
                    self?.showContent(on: interfaceController)
                } catch {
                    guard self?.interfaceController === interfaceController else { return }
                    self?.showContent(on: interfaceController)
                }
            }
        }
    }

    private func showContent(on interfaceController: CPInterfaceController) {
        guard self.interfaceController === interfaceController else { return }
        isPresentingReleaseNotes = false
        loadingTask?.cancel()
        loadingTask = nil

        interfaceController.setRootTemplate(
            makeContentTemplate(),
            animated: true
        ) { _, _ in }
    }

    private func makeContentTemplate() -> CPTemplate {
        // Return the host app's real, category-approved CarPlay root here.
        let template = CPListTemplate(title: "Home", sections: [])
        template.emptyViewTitleVariants = ["Your app's CarPlay content"]
        return template
    }

    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didDisconnectInterfaceController interfaceController: CPInterfaceController
    ) {
        guard self.interfaceController === interfaceController else { return }
        isPresentingReleaseNotes = false
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
    from: "https://api.example.com/releases.json",
    onContinue: continueToContent
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
    currentVersion: "2.4.0",
    onContinue: continueToContent
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

The adapter deliberately uses `CPListTemplate` rather than rendering SwiftUI
or using `CPInformationTemplate`. The latter is restricted to
entitlement-specific categories and use cases, while a list template is
available across eligible template-app categories. Continue is a trailing
`CPBarButton`, so it doesn't consume the runtime list-item allowance. Its host
callback replaces the What's New root with the app's native `CPTemplate`; it
does not and cannot reveal the phone's SwiftUI `ContentView` on the vehicle
display.

Keeping What's New as the root and each selected detail as the second level
also keeps this adapter within the strict two-level hierarchy available to
quick-ordering apps. Don't put a host root underneath What's New and then push a
detail, because that creates a third level. Navigation apps have category-
specific root and `CPWindow` requirements and must integrate the adapter into
their permitted hierarchy instead of replacing their required map root. Fonts,
sizing, interaction limits, and truncation remain under CarPlay's control.
History uses `CPListTemplate.updateSections(_:)` on that same root rather than
pushing another template, so a historical detail remains the second level.

Keep the content short and useful while driving. SwiftNEW does not automatically present release notes, open App Store update links, show search, or run visual effects on the vehicle display.

See Apple's [Displaying Content in CarPlay](https://developer.apple.com/documentation/carplay/displaying-content-in-carplay), [`CPListTemplate`](https://developer.apple.com/documentation/carplay/cplisttemplate), and [CarPlay design guidance](https://developer.apple.com/design/human-interface-guidelines/carplay) for the host app's remaining requirements.

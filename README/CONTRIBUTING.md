[← Back to README](../README.md)

# 🤝 Contributing

Contributions are welcome — bug reports, features, translations, or doc improvements.

## Ways to Contribute

- 🐛 **Report bugs** — open an issue with reproduction steps
- 💡 **Request features** — describe the use case, not just the solution
- 🔧 **Submit pull requests** — see the [PR Guidelines](#pr-guidelines) below
- 📚 **Improve docs** — typos, clarifications, examples
- 🌍 **Add translations** — see existing translations under `README/`

## Development Setup

```bash
git clone https://github.com/1998code/SwiftNEWKit.git
cd SwiftNEWKit
open Package.swift   # in Xcode
```

Test your changes against as many platforms as possible (iOS, macOS, visionOS, tvOS, watchOS).

The CI watchOS compile gate uses a generic device destination and does not launch a simulator:

```bash
xcodebuild -scheme SwiftNEW -destination 'generic/platform=watchOS' build CODE_SIGNING_ALLOWED=NO
```

## Running the Demo

The `Demo/What's New?.xcodeproj` host app consumes the local package. Its code
signing is driven by `Demo/Signing.xcconfig`, and no development team is
committed to the repo:

- **Simulator** — just build and run; no team or extra setup needed. This
  includes the CarPlay demo, because simulator builds are not checked against
  a provisioning profile.
- **Physical device** — create `Demo/Signing.local.xcconfig` (gitignored) next
  to `Demo/Signing.xcconfig` with your own team:

  ```
  DEVELOPMENT_TEAM = YOUR_TEAM_ID
  ```

  Device builds carry no CarPlay entitlement by default. This is deliberate:
  CarPlay is a managed capability, and automatic signing fails for any team
  Apple hasn't approved — the app wouldn't even install. With the default,
  any paid or free team can auto-sign and run the Demo on an iPhone (the
  CarPlay part only appears in simulator builds). If Apple has granted your
  team a CarPlay capability, opt in by adding to the same file:

  ```
  CODE_SIGN_ENTITLEMENTS[sdk=iphoneos*] = What's New?/What_s_New_CarPlay.entitlements
  DEMO_BUNDLE_ID = your.approved.bundle.id
  ```

  CarPlay is granted **per App ID**, so `DEMO_BUNDLE_ID` must be the bundle
  identifier Apple approved for your team — the watch app and test bundles
  re-derive their identifiers from it automatically. The tracked entitlements
  file uses `com.apple.developer.carplay-driving-task`; if Apple granted you a
  different CarPlay category, point `CODE_SIGN_ENTITLEMENTS[sdk=iphoneos*]` at
  your own (gitignored) entitlements file instead.

Set the team via `Signing.local.xcconfig`, **not** Xcode's Signing &
Capabilities tab — the tab writes your team ID into the tracked
`project.pbxproj`. Don't commit pbxproj signing changes in PRs.

## PR Guidelines

- **Keep PRs focused.** One feature or bug fix per PR. Avoid bundling unrelated refactors, formatting changes, or dependency updates.
- **Don't reformat unrelated code.** If a file uses 4-space indentation, don't switch it to 2 in a feature PR. Style-only changes belong in their own PR.
- **Maintain backward compatibility.** New initializer parameters should have defaults. Public API removals require a deprecation cycle.
- **Match the minimum platform versions** declared in `Package.swift` and the `@available` annotations.
- **Test on multiple platforms** when the change touches view code or platform-conditional code (`#if os(...)`).
- **Localization changes** — when adding/renaming a string, update all locales in `Localizable.xcstrings` (or mark them `needs_review`).
- **Remote Update preview** — keep `Demo/remote-update-preview.json` separate from the localized release-note files. Its deliberately high version makes the `Remote Update` preview deterministic; the preview's raw GitHub URL works after the fixture is pushed to `main`.

## 📂 Project Structure

```
Sources/SwiftNEW/
├── SwiftNEW.swift                # Main struct + init overloads
├── Model.swift                   # Vmodel, Model (Codable, Sendable)
├── Bundle+Ext.swift              # App icon helper
├── Localizable.xcstrings         # Localization catalog
├── Views/
│   ├── SwiftNEW+View.swift       # body + presentation modifiers
│   ├── Sheets/
│   │   ├── CurrentVersionSheet.swift
│   │   ├── HistorySheet.swift
│   │   └── UpdateSheet.swift
│   └── Components/
│       ├── HeaderView.swift
│       └── ButtonComponents.swift
├── Extensions/
│   └── SwiftNEW+Functions.swift  # compareVersion, loadData, drop
├── Styles/
│   ├── AppIconView.swift
│   ├── MeshView.swift            # Mesh gradient background
│   └── NoiseView.swift           # Noise overlay
└── Animations/
    ├── SnowfallView.swift            # .christmas effect
    └── FloatingParticlesView.swift   # .particles effect
```

### Architecture at a Glance

- **Core**: `SwiftNEW` struct holds all configuration via `@Binding`s; multiple `init` overloads accept either direct values or bindings (cross-platform variants for iOS/macOS/watchOS/tvOS/visionOS).
- **View layer**: `body` resolves to either an embedded view or a button that triggers a sheet / fullScreenCover. Sheets compose `MeshView` + optional `SnowfallView` / `FloatingParticlesView` on top of `sheetCurrent`, `sheetHistory`, or `sheetUpdate`.
- **Data**: `loadData()` parses local or remote JSON into `[Vmodel]` using Swift Concurrency. `compareVersion()` reads `Bundle.version` / `Bundle.build` and toggles `show` on mismatch. When `checkForUpdates` is enabled for a remote source, the loader selects the highest newer release, resolves `trackViewUrl` through Apple's iTunes Lookup API using the configured App Store bundle identifier (`WKCompanionAppBundleIdentifier` on watchOS when present, otherwise `Bundle.main.bundleIdentifier`), and routes to `sheetUpdate`.

## 🔧 Troubleshooting

### Nothing appears

- Check that `show` is bound to a `@State` (or equivalent) `Bool` and gets set to `true`.
- Confirm the data source resolves: local JSON exists in the bundle, or the remote URL returns 200 with the expected schema.

### Data never loads

- **Local**: the file must be added to the *target* (not just the project) so it ends up in the bundle.
- **Remote**: check the URL scheme starts with `http`/`https` and that the device has network access.
- **Schema**: the JSON must be a top-level array of `Vmodel`. Validate with `xcrun swift run` or any JSON linter.

### Build errors after installing

- Clean build folder (⌘⇧K) and resolve packages (File → Packages → Reset Package Caches).
- Confirm Xcode and target deployment versions meet the minimums in [PLATFORM.md](PLATFORM.md).

## Getting Help

- 💬 [GitHub Discussions](https://github.com/1998code/SwiftNEWKit/discussions) — questions, ideas, community
- 🐛 [GitHub Issues](https://github.com/1998code/SwiftNEWKit/issues) — bug reports, feature requests

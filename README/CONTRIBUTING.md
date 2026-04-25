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

## PR Guidelines

- **Keep PRs focused.** One feature or bug fix per PR. Avoid bundling unrelated refactors, formatting changes, or dependency updates.
- **Don't reformat unrelated code.** If a file uses 4-space indentation, don't switch it to 2 in a feature PR. Style-only changes belong in their own PR.
- **Maintain backward compatibility.** New initializer parameters should have defaults. Public API removals require a deprecation cycle.
- **Match the minimum platform versions** declared in `Package.swift` and the `@available` annotations.
- **Test on multiple platforms** when the change touches view code or platform-conditional code (`#if os(...)`).
- **Localization changes** — when adding/renaming a string, update all locales in `Localizable.xcstrings` (or mark them `needs_review`).

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
│   │   └── HistorySheet.swift
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
- **View layer**: `body` resolves to either an embedded view or a button that triggers a sheet / fullScreenCover. Sheets compose `MeshView` + optional `SnowfallView` / `FloatingParticlesView` on top of `sheetCurrent` or `sheetHistory`.
- **Data**: `loadData()` parses local or remote JSON into `[Vmodel]` using Swift Concurrency. `compareVersion()` reads `Bundle.version` / `Bundle.build` and toggles `show` on mismatch.

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

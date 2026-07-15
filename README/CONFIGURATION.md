[← Back to README](../README.md)

# ⚙️ Configuration

## Available Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `show` * | `Binding<Bool>` | `false` | Controls the presentation state |
| `align` | `Binding<HorizontalAlignment>` | `.center` | Content alignment (`.leading`, `.center`, `.trailing`) |
| `color` | `Binding<Color>` | `.accentColor` | Primary theme color |
| `size` | `Binding<String>` | `"simple"` | Button size: `"invisible"`, `"mini"`, `"simple"`, `"normal"` |
| `label` | `Binding<String>` | `"Show Release Note"` | Button display text |
| `labelImage` | `Binding<String>` | `"arrow.up.circle.fill"` | SF Symbol icon name |
| `history` | `Binding<Bool>` | `true` | Enable version history navigation |
| `data` | `Binding<String>` | `"data"` | Local JSON filename or remote URL |
| `showDrop` | `Binding<Bool>` | `false` | Use iOS drop notification style |
| `mesh` | `Binding<Bool>` | `true` | Enable mesh gradient backgrounds |
| `meshStyle` | `Binding<SwiftNEWMeshStyle>` | `.still` | Mesh behavior: `.still` or `.liquid` |
| `specialEffect` | `Binding<SwiftNEWSpecialEffect>` | `.none` | Special effects: `.none`, `.christmas`, `.particles` |
| `glass` | `Binding<Bool>` | `true` | Enable glass morphism effects |
| `presentation` | `Binding<SwiftNEWPresentation>` | `.sheet` | Presentation style: `.sheet`, `.fullScreenCover`, `.embed` |
| `showBuild` | `Binding<Bool>` | `true` | Show build number alongside the version in the header |
| `headingStyle` | `Binding<SwiftNEWHeadingStyle>` | `.version` | Subtitle line style: `.version` (`Version 6.4 (19)`), `.versionOnly` (`6.4`), `.appName` (app's display name) |
| `headingPrefix` | `Binding<String>` | `"What's New in"` | Header title line shown above the version/app name |
| `iconStyle` | `Binding<SwiftNEWIconStyle>` | `.default` | Row icon style: `.default` (top-leading white/black-to-bottom-trailing-clear gradient, glyph in theme color), `.filled` (colored backdrop, white glyph), or `.plain` (no backdrop, glyph in theme color) |
| `checkForUpdates` | `Binding<Bool>` | `false` | Check remote release notes for a newer app version and resolve its App Store URL automatically |
| `allowsSkippingUpdate` | `Binding<Bool>` | `true` | Show **Not Now** and allow user-initiated dismissal of the Update presentation |
| `updateButtonTitle` | `String?` / `Binding<String>` | `nil` / blank → `"Download Now"` | Primary App Store action text; a `nil` direct value or blank text uses the package-localized default |
| `appStoreBundleIdentifier` | `Binding<String?>` | `nil` | Optional App Store listing bundle ID override for extensions, companion apps, or previews |

\* Required parameter

## Examples

### Minimal

```swift
SwiftNEW(show: $showNew)
```

### Custom Styling

```swift
SwiftNEW(
    show: $showNew,
    color: .purple,
    size: "normal",
    mesh: true,
    meshStyle: .still,
    glass: true
)
```

### Liquid Mesh

```swift
SwiftNEW(
    show: $showNew,
    meshStyle: .liquid
)
```

Liquid mesh keeps the same readable full-screen background treatment, but moves the mesh control points slowly over time.

### Hide Build Number

```swift
SwiftNEW(
    show: $showNew,
    showBuild: false
)
```

### Heading Style

```swift
SwiftNEW(show: $showNew)                                  // "What's New in / Version 6.4 (19)"
SwiftNEW(show: $showNew, headingStyle: .versionOnly)      // "What's New in / 6.4"
SwiftNEW(show: $showNew, headingStyle: .appName)          // "What's New in / {App Name}"
SwiftNEW(show: $showNew, headingPrefix: "Latest in")      // "Latest in / Version 6.4 (19)"
```

### Icon Style

```swift
SwiftNEW(show: $showNew)                              // .default — white/black-to-clear gradient backdrop
SwiftNEW(show: $showNew, iconStyle: .filled)          // colored backdrop, white glyph
SwiftNEW(show: $showNew, iconStyle: .plain)           // no backdrop, glyph uses theme color
```

### Special Effects

```swift
SwiftNEW(show: $showNew, specialEffect: .christmas)   // Snowfall
SwiftNEW(show: $showNew, specialEffect: .particles)   // Floating rainbow particles
```

### Drop Notification (iOS only)

```swift
SwiftNEW(
    show: $showNew,
    label: "New Update",
    labelImage: "bell.badge",
    showDrop: true
)
```

## 🔧 Data Sources

SwiftNEW reads release notes from a JSON source. The same parameter (`data`) is used for both local and remote inputs — if it starts with `http`, it is fetched over the network; otherwise it is loaded as a bundled resource by name.

If loading fails, SwiftNEW shows an inline error state with a retry button. Successful data loads are cached for the current view lifetime, so repeated appearances do not re-fetch the same source unnecessarily.

### Local JSON

Add a JSON file (typically `data.json`) to your app bundle:

```json
[
  {
    "version": "1.2.0",
    "new": [
      {
        "icon": "hammer.fill",
        "title": "Bug Fixes",
        "subtitle": "Stability Improvements",
        "body": "Resolved critical issues and improved overall app performance."
      },
      {
        "icon": "sparkles",
        "title": "New Features",
        "subtitle": "Enhanced Experience",
        "body": "Improved animations and modern UI components."
      }
    ]
  }
]
```

### Remote JSON

Pass any reachable JSON URL:

```swift
SwiftNEW(show: $showNew, data: "https://api.example.com/releases.json")
```

### Remote Update Screen

Provide a remote release-notes source and opt in to update checks:

```swift
SwiftNEW(
    show: $showNew,
    data: "https://api.example.com/releases.json",
    checkForUpdates: true,
    updateButtonTitle: "Install Update"
)
```

`updateButtonTitle` defaults to the package-localized **Download Now** label. A non-empty custom value is displayed verbatim, so localize it in your app before passing it if needed. Passing `nil` to the direct-value initializer, or passing an empty/whitespace-only string through either initializer, restores the localized default.

To require the update, disable skipping:

```swift
SwiftNEW(
    show: $showNew,
    data: "https://api.example.com/releases.json",
    checkForUpdates: true,
    allowsSkippingUpdate: false
)
```

`checkForUpdates` is opt-in and defaults to `false`. When enabled, SwiftNEW checks the remote JSON before presentation and compares every release against the installed app's `CFBundleShortVersionString`:

- A non-empty `subVersion` is the precise comparison version; otherwise SwiftNEW uses `version`.
- The JSON array does not need to be sorted. SwiftNEW selects the highest valid version.
- Numeric components are compared numerically, so `1.10` is newer than `1.9`, while `1.2` and `1.2.0` are equal.
- A newer version presents the Update screen automatically, even if the current What's New screen was already seen. The screen includes the newest release notes.
- SwiftNEW requests `https://itunes.apple.com/lookup?bundleId=<resolved bundle identifier>`, matches the returned `bundleId`, and opens its HTTPS Apple `trackViewUrl` from **Download Now** (or the developer's custom `updateButtonTitle`). If the default US storefront has no result, it retries with the device's current region. Developers do not provide or trust an update URL from the release-notes JSON.
- By default, the lookup uses `Bundle.main.bundleIdentifier`. If an extension, companion app, or preview host has a different bundle ID, pass the App Store listing ID with `appStoreBundleIdentifier`. Unpublished development bundle identifiers can still show the retry state.
- If the App Store lookup fails or has no matching result, the Update screen remains visible with a retry action instead of opening an unverified destination. Retrying repeats only the App Store lookup and keeps the already loaded release notes.
- `allowsSkippingUpdate` defaults to `true`. Set it to `false` to hide **Not Now** and disable user-initiated presentation dismissal while checking for or presenting an update. Developer-controlled state changes, removing the view, and quitting the app remain possible. If App Store lookup fails in this mode, the user must retry.
- When skipping is allowed, **Not Now** closes a sheet/full-screen presentation. In `.embed`, it returns to the normal What's New content.
- Equal, older, or malformed versions keep the normal What's New flow. Local JSON never triggers the Update screen.
- If the remote request or decoding fails, SwiftNEW keeps the existing retryable error state and never presents a stale update.

### Firebase Realtime Database

Firebase exposes data over plain HTTPS, so the remote form works directly:

```swift
SwiftNEW(show: $showNew, data: "https://your-project.firebaseio.com/releases.json")
```

## Data Model Reference

```swift
public struct Vmodel: Codable, Hashable, Identifiable, Sendable {
    public var id: String       // derived from version + subVersion
    public var version: String  // e.g., "1.2.0"
    public var subVersion: String?
    public var new: [Model]
}

public struct Model: Codable, Hashable, Identifiable, Sendable {
    public var id: String       // derived from icon sequence + title + subtitle + body
    public var icon: String     // SF Symbol name
    public var toIcon: String?  // optional target SF Symbol for replace transition
    public var icons: [String]? // optional symbol loop: [firstIcon, secondIcon, ...]
    public var title: String
    public var subtitle: String
    public var body: String
}
```

Icon transitions can be declared either with `icon` + `toIcon`:

```json
{
  "icon": "checkmark.shield",
  "toIcon": "shield.checkered",
  "title": "Compatibility",
  "subtitle": "Fixes",
  "body": "Improved platform support."
}
```

Or with `icons`:

```json
{
  "icons": ["checkmark.shield", "shield.checkered", "sparkles"],
  "title": "Compatibility",
  "subtitle": "Fixes",
  "body": "Improved platform support."
}
```

When `icons` has multiple values, SwiftNEW loops through the full array in order. Otherwise, it falls back to `icon` and `toIcon`.

## Auto-Trigger Storage

SwiftNEW remembers the last displayed app version/build in `@AppStorage` using namespaced keys:

| Key | Value |
|-----|-------|
| `swiftnew.version` | Last displayed `CFBundleShortVersionString` |
| `swiftnew.build` | Last displayed `CFBundleVersion` |

Version/build comparison is string-safe, so non-numeric bundle values such as `1.0-beta` or `1.0b3` will not crash.

## Tips

- Keep `title` short; put detail in `body`.
- Use semantic versioning (`1.2.3`) for clearer history.
- For frequently changing release notes, prefer remote/Firebase over rebuilding the app.

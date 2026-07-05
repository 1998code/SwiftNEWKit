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
    public var id: String       // derived from icon/transition target + title + subtitle + body
    public var icon: String     // SF Symbol name
    public var toIcon: String?  // optional target SF Symbol for replace transition
    public var icons: [String]? // optional shorthand: [fromIcon, toIcon]
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
  "icons": ["checkmark.shield", "shield.checkered"],
  "title": "Compatibility",
  "subtitle": "Fixes",
  "body": "Improved platform support."
}
```

When `icons` has at least two values, SwiftNEW uses `icons[0]` as the starting icon and `icons[1]` as the replacement icon. Otherwise, it falls back to `icon` and `toIcon`.

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

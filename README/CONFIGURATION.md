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
| `specialEffect` | `Binding<SwiftNEWSpecialEffect>` | `.none` | Special effects: `.none`, `.christmas`, `.particles` |
| `glass` | `Binding<Bool>` | `true` | Enable glass morphism effects |
| `presentation` | `Binding<SwiftNEWPresentation>` | `.sheet` | Presentation style: `.sheet`, `.fullScreenCover`, `.embed` |
| `showBuild` | `Binding<Bool>` | `true` | Show build number alongside the version in the header |
| `headingStyle` | `Binding<SwiftNEWHeadingStyle>` | `.version` | Subtitle line style: `.version` (`Version 6.3 (18)`), `.versionOnly` (`6.3`), `.appName` (app's display name) |
| `iconStyle` | `Binding<SwiftNEWIconStyle>` | `.filled` | Row icon style: `.filled` (colored backdrop, white glyph) or `.plain` (no backdrop, glyph in theme color) |

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
    glass: true
)
```

### Hide Build Number

```swift
SwiftNEW(
    show: $showNew,
    showBuild: false
)
```

### Heading Style

```swift
SwiftNEW(show: $showNew)                                  // "What's New in / Version 6.3 (18)"
SwiftNEW(show: $showNew, headingStyle: .versionOnly)      // "What's New in / 6.3"
SwiftNEW(show: $showNew, headingStyle: .appName)          // "What's New in / {App Name}"
```

### Icon Style

```swift
SwiftNEW(show: $showNew)                              // .filled — colored backdrop, white glyph (default)
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
public struct Vmodel: Codable, Hashable, Sendable {
    var version: String         // e.g., "1.2.0"
    var subVersion: String?     // optional
    var new: [Model]
}

public struct Model: Codable, Hashable, Sendable {
    var icon: String            // SF Symbol name
    var title: String
    var subtitle: String
    var body: String
}
```

## Tips

- Keep `title` short; put detail in `body`.
- Use semantic versioning (`1.2.3`) for clearer history.
- For frequently changing release notes, prefer remote/Firebase over rebuilding the app.

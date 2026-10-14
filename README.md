# SwiftNEW for Android

[SwiftNEWKit](https://github.com/1998code/SwiftNEWKit) on Android — a Jetpack Compose **"What's New"** UI that uses the same release-notes JSON as the Apple platforms.

> Not on Maven Central yet. Include the `:swiftnew` module in your Gradle project (see below).

<img width="2880" height="2160" alt="275" src="https://github.com/user-attachments/assets/95a76362-6a82-4ff7-91ee-260190d3e5d7" />

## Modules

| Module | Role |
| --- | --- |
| `:swiftnew` | Compose library — `SwiftNew`, sheets, JSON loader, Play Billing & In-App Updates |
| `:app` | Demo app (`io.startway.whatsnew`) |

## Add the library

In `settings.gradle.kts`:

```kotlin
include(":swiftnew")
// project(":swiftnew").projectDir = file("path/to/SwiftNEWKit/swiftnew")
```

In your app module:

```kotlin
dependencies {
  implementation(project(":swiftnew"))
}
```

## Quick start

```bash
./gradlew :app:assembleDebug :swiftnew:test
```

**1. Add `data.json` to your app `assets/`** (same schema as iOS):

```json
[
  {
    "version": "1.0",
    "new": [
      {
        "icon": "star.fill",
        "title": "Welcome",
        "subtitle": "Get Started",
        "body": "Thanks for downloading our app!"
      }
    ]
  }
]
```

**2. Present it:**

```kotlin
var show by rememberSaveable { mutableStateOf(false) }

SwiftNew(
  show = show,
  onShowChange = { show = it },
  data = "data",
  history = true,
  search = true,
)
```

Current-version rows match the host `versionName` (or `subVersion`) to each JSON `version` / `subVersion`. Asset name `"data"` loads `assets/data.json`; you can also pass a remote HTTPS URL.

## API highlights

| Parameter | Notes |
| --- | --- |
| `presentation` | `Sheet` (Material 3 bottom sheet), `FullScreen`, or `Embed` |
| `history` / `search` | Version history sheet and in-sheet search (250ms debounce) |
| `mesh` / `glass` / `specialEffect` | Backdrop and chrome |
| `appIconName` | Optional drawable/mipmap name above the heading; otherwise the launcher icon |
| `checkForUpdates` | Play In-App Updates, with JSON version fallback |
| `purchaseRequirement` | Play purchase / subscription gate before entering |
| `playStorePackageName` | Package used for Play Store links (defaults to the host app) |

Props and defaults mirror the Apple `SwiftNEW` API where practical.

## Purchase

- `purchaseEnvironment = All` always enforces the gate; `InternalTesting` enforces only on debuggable builds.
- Without a host `purchaseAction`, the primary button opens the Play Store listing.
- **Restore** queries Play Billing (`INAPP` / `SUBS`). Sideloaded builds with no Play products will fail — expected.
- A host `purchaseAction` can complete a custom or demo unlock when the action returns.

## Updates

With `checkForUpdates = true`, Android checks **Play In-App Updates** first. If Play reports no update (common for local debug installs), it compares release-notes JSON versions and still attaches a Play Store URL when the package name is known.

## License

MIT — same as the repository on `main`.

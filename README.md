# SwiftNEW for Android

Jetpack Compose port of [SwiftNEWKit](https://github.com/1998code/SwiftNEWKit) — a **"What's New"** presentation UI driven by the same release-notes JSON shape used on Apple platforms.

This branch is an **orphan** Android tree (no Swift/SPM history).

## Modules

| Module | Role |
| --- | --- |
| `:swiftnew` | Reusable Compose library (`SwiftNew`, sheets, JSON loader, Play helpers) |
| `:app` | Demo host app (`applicationId` `io.startway.whatsnew`, from iOS `media.1998.WhatsNew`) |

## Quick start

```bash
./gradlew :app:assembleDebug :swiftnew:test
```

Drop a `data.json` into your app `assets/` (same schema as iOS), then:

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

Current-version rows match `versionName` (or `subVersion`) against each JSON `version` / `subVersion`.

## Port coverage

| Surface | Status |
| --- | --- |
| Current version sheet | Done |
| History nested sheet + version capsules | Done |
| Search glass field + 250ms debounce | Done |
| SF Symbol → Material mapping / icon badges | Done |
| Glass / mesh / soft scroll chrome | Done (Compose approximation) |
| Sheet / FullScreen / Embed | Done |
| Local + remote JSON loader | Done |
| Play In-App Updates check (`checkForUpdates`) | Done (falls back to JSON version compare) |
| Play Store listing URL for purchase / update | Done (package → Play URL) |
| Play Billing purchase verify + Restore | Done (BillingClient; requires Play products) |
| Purchase gate UI | Done |
| Host `purchaseAction` demo unlock | Done (host-authoritative) |
| CarPlay / watch / tv / mac | N/A |
| Maven / package publish | Not published yet |

### Purchase notes

- `purchaseEnvironment = All` always enforces; `InternalTesting` enforces on debuggable builds (TestFlight analogue).
- Without a host `purchaseAction`, the primary button opens the Play Store listing.
- **Restore** queries Play Billing entitlements (`INAPP` / `SUBS`). It will fail on sideloaded debug builds with no products — that is expected.
- Providing `purchaseAction` lets the host complete a custom / demo unlock after the action returns.

### Update notes

- With `checkForUpdates = true`, Android first asks **Play In-App Updates**; if Play reports no update (typical for local debug installs), it falls back to comparing release-notes JSON versions and still attaches the Play Store URL when a package name is known.

## License

MIT — see the main repository license on `main`.

[← Back to README](../README.md)

# 🛠️ Platform Support & Installation

## Supported Platforms

| Platform | Latest Tested | Minimum Required |
|----------|---------------|------------------|
| iOS | 18.2 | 15.0+ |
| iPadOS | 18.2 | 15.0+ |
| macOS | 15.2 | 14.0+ |
| visionOS | 2.1 | 1.0+ |
| tvOS | 18.2 | 17.0+ |

## Development Requirements

| Tool | Version |
|------|---------|
| Xcode | 15.0+ |
| macOS host | 14.0+ |
| Swift | 5.9 / 6.1+ |

## Feature Availability

| Feature | iOS | iPadOS | macOS | visionOS | tvOS |
|---------|:---:|:------:|:-----:|:--------:|:----:|
| Basic presentation | ✅ | ✅ | ✅ | ✅ | ✅ |
| Mesh gradients | ✅ | ✅ | ✅ | ✅ | ✅ |
| Glass effects | ✅ | ✅ | ✅ | ✅ | ❌ |
| Drop notifications | ✅ | ✅ | ❌ | ❌ | ❌ |
| History navigation | ✅ | ✅ | ✅ | ✅ | ✅ |
| Remote JSON | ✅ | ✅ | ✅ | ✅ | ✅ |
| Special effects | ✅ | ✅ | ✅ | ✅ | ✅ |
| Auto-versioning | ✅ | ✅ | ✅ | ✅ | ✅ |

## 📦 Installation Guide

SwiftNEW is distributed via Swift Package Manager.

### In Xcode

1. **File → Add Package Dependencies…**
2. Paste the package URL:
   ```
   https://github.com/1998code/SwiftNEWKit
   ```
3. Choose a version rule (typically `Up to Next Major`).
4. Add the `SwiftNEW` library to your target.

| Step | Screenshot |
|------|------------|
| 1. Open project | <img width="274" alt="Project Navigator" src="https://user-images.githubusercontent.com/54872601/173182521-27481cf2-c9bf-4f87-95cc-76f5d1c05094.png"> |
| 2. Select target | <img width="174" alt="Target Selection" src="https://user-images.githubusercontent.com/54872601/173182523-6a24c67a-8f27-4ef7-a3f4-ea63cfd8436f.png"> |
| 3. Package Dependencies tab | <img width="309" alt="Package Dependencies" src="https://user-images.githubusercontent.com/54872601/173182526-e5660b7f-c50c-4173-81f5-83c10c514659.png"> |
| 4. Add package | <img width="614" alt="Add Package" src="https://user-images.githubusercontent.com/54872601/173182527-2a151198-7ac0-4735-8257-11580ada3d5e.png"> |

### In `Package.swift`

```swift
dependencies: [
    .package(url: "https://github.com/1998code/SwiftNEWKit", from: "6.3.0")
]
```

### After Installing

```swift
import SwiftNEW

SwiftNEW(show: $showNew)
```

See [CONFIGURATION.md](CONFIGURATION.md) for data source setup and customization.

<img width="150" alt="SNK" src="https://github.com/user-attachments/assets/1121ae03-cf96-455e-8119-596f6f5eb58e" />

# SwiftNEW

![Stable](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=03A791&label=Stable)
![Beta](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?include_prereleases&color=3A59D1&label=Beta)
[![Validate JSON Files](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml/badge.svg)](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml)
![Swift Version](https://img.shields.io/badge/Swift-5.9/6.1-teal.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2015.0+%20|%20macOS%2014.0+%20|%20tvOS%2017.0+%20|%20visionOS%201.0+-15437D.svg)
![License](https://img.shields.io/badge/License-MIT-C8ECFE.svg)

**English** · [繁中](README/README_tc.md) · [简中](README/README_zh.md) · [粵語](README/README_hc.md) · [日本語](README/README_ja.md) · [한국어](README/README_ko.md)

A modern, SwiftUI-native **"What's New"** presentation framework for all Apple platforms — animated gradient backgrounds, glass effects, remote data loading, and full RTL/localization support out of the box.

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

## 🎨 Gallery

| Light | Dark |
|:-----:|:----:|
| ![Light](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![Dark](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG) |

## 🚀 Quick Start

**1. Add the package** in Xcode → *File → Add Package Dependencies…*

> [!TIP]
> **Package URL:** [`https://github.com/1998code/SwiftNEWKit`](https://github.com/1998code/SwiftNEWKit)

**2. Add a `data.json`** to your app bundle:

```json
[
  {
    "version": "1.0",
    "new": [
      { "icon": "star.fill", "title": "Welcome", "subtitle": "Get Started", "body": "Thanks for downloading our app!" }
    ]
  }
]
```

**3. Drop it in your view:**

```swift
import SwiftNEW

struct ContentView: View {
    @State private var showNew = false
    var body: some View {
        SwiftNEW(show: $showNew)
    }
}
```

That's it — SwiftNEW auto-triggers when the app version changes.

## ✨ Features

| Feature | Since | Description |
|---------|:-----:|-------------|
| 🔢 Optional Build Number | 6.3.0 | Hide build number via `showBuild: false` |
| 🎨 Floating Particles Effect | 6.3.0 | New `.particles` special effect (TimelineView + Canvas) |
| 🎯 Flexible Presentations | 6.2.0 | `.sheet`, `.fullScreenCover`, `.embed` |
| 🌈 Adaptive Text Color | 6.2.0 | Button text auto-contrasts with background |
| 🛠️ Simplified Initializer | 6.2.0 | Direct values — no `.constant()` wrapping needed |
| 🪟 Glass Morphism | 5.5.0 | Modern blur with customizable transparency |
| 🌈 Mesh & Linear Gradients | 5.3.0 | Animated gradient backgrounds |
| 🥽 visionOS Support | 4.1.0 | Native spatial computing |
| 🔄 Auto-trigger | 4.0.0 | Shows automatically when version/build changes |
| 🎄 Special Effects | 3.9.0 | `.christmas` snowfall, `.particles` rainbow |
| 📱 Drop Notifications | 3.5.0 | iOS-style banner notifications |
| 🔥 Firebase Realtime DB | 3.0.0 | Live content updates |
| 🌐 Remote JSON | 3.0.0 | Load from any REST endpoint |
| 📚 Version History | 2.0.0 | Browse all previous releases |

### Feature Showcase

| Mesh Gradient (5.3+) | visionOS (4.1+) |
|:--------------------:|:---------------:|
| <img alt="Mesh" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508"> | ![visionOS](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) |

| App Icon (3.9.6+) | History (2.0+) |
|:-----------------:|:--------------:|
| ![App Icon](https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png) | <img width="300" alt="History" src="https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png"> |

## 📚 Learn More

| Guide | Covers |
|-------|--------|
| [Configuration](README/CONFIGURATION.md) | All parameters, examples, data sources (local / remote / Firebase), data model |
| [Platform Support & Installation](README/PLATFORM.md) | Supported OS versions, requirements, feature matrix, SPM setup |
| [Contributing](README/CONTRIBUTING.md) | Project structure, dev setup, PR guidelines, troubleshooting |

## 📄 License

SwiftNEW is released under the **MIT License** — one of the most permissive open-source licenses.

| | Details |
|---|---------|
| ✅ **You can** | Use it in commercial apps (including paid App Store apps), modify it, redistribute it, and ship it inside closed-source software |
| 📝 **You must** | Keep the original copyright and license notice in your project |
| ⚠️ **No warranty** | The software is provided "as is" — the author is not liable for any issues arising from its use |

See [LICENSE](LICENSE) for the full text.

## 💖 Supported By

| Sponsor | Resource |
|---------|----------|
| <a href="https://m.do.co/c/ce873177d9ab"><img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/SVG/DO_Logo_horizontal_blue.svg" width="160px" alt="Digital Ocean"></a> | Cloud infrastructure |
| [![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/1998code/SwiftNEWKit) | AI-powered docs Q&A |

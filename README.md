<img width="150" alt="SNK" src="https://github.com/user-attachments/assets/1121ae03-cf96-455e-8119-596f6f5eb58e" />

# SwiftNEW

![Stable](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=03A791&label=Stable)
![Beta](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?include_prereleases&color=3A59D1&label=Beta)
[![Validate JSON Files](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml/badge.svg)](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml)
![Swift Version](https://img.shields.io/badge/Swift-5.9/6.1-teal.svg)

![Platforms](https://img.shields.io/badge/Platforms-iOS%2015.0+%20|%20macOS%2014.0+%20|%20tvOS%2017.0+%20|%20visionOS%201.0+-15437D.svg)
![License](https://img.shields.io/badge/License-MIT-C8ECFE.svg)

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

A modern, SwiftUI-native "What's New" presentation framework designed for all Apple platforms. Featuring beautiful animations, gradient backgrounds, remote data loading, and comprehensive customization options for creating engaging release notes and feature announcements.

## 📋 Table of Contents

- [✨ Features](#-features)
- [🎯 Quick Start](#-quick-start)
- [🎨 Preview & Gallery](#-preview--gallery)
- [⚙️ Configuration](#️-configuration)
- [🔧 Data Sources](#-data-sources)
- [🛠️ Platform Support](#️-platform-support)
- [📁 Installation Guide](#-installation-guide)
- [🔧 Troubleshooting](#-troubleshooting)
- [📂 Project Structure](#-project-structure)
- [🤝 Contributing](#-contributing)

## 🎨 Preview & Gallery

![CleanShot 2022-06-11 at 22 54 15@2x](https://user-images.githubusercontent.com/54872601/173192927-ca2a8bef-2114-44f8-8d4d-47baadb8b4a8.png)

### Light & Dark Mode
![IMG_3472](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![IMG_3471](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG)
:---: | :---:
Light Native | Dark Native

### Advanced Features
![Simulator Screen Shot - iPhone 13 Pro Max](https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png) | ![CleanShot 2022-12-11 at 12 46 30@2x](https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png)
:---: | :---:
History View (2.0.0+) | App Icon Support (3.9.6+)

### Platform Support
![CleanShot 2023-06-22 at 14 24 07@2x](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) | <img alt="Screenshot 2024-07-01 at 10 18 33 PM" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508">
:---: | :---:
VisionOS Support (4.1.0+) | Mesh Gradient Background (5.3.0+)

## ✨ Features

| Feature | Version | Description |
|---------|---------|-------------|
| 🎨 **Glass Morphism Effects** | 5.5.0+ | Modern glass blur effects with customizable transparency |
| 🌈 **Mesh & Linear Gradients** | 5.3.0+ | Beautiful animated gradient backgrounds |
| 🥽 **visionOS & Vision Pro** | 4.1.0+ | Native spatial computing support |
| 🔄 **Auto-trigger on Version Change** | 4.0.0+ | Automatically shows when app version or build changes |
| 📊 **Flexible Version Numbers** | 4.0.0+ | Supports semantic versioning (x.y.z) and simplified (x.y) formats |
| 🎄 **Special Effects** | 3.9.0+ | Seasonal animations (Christmas snowfall) |
| 📱 **Drop Notifications** | 3.5.0+ | iOS-style notification banners |
| 🔥 **Firebase Real-Time Database** | 3.0.0+ | Live content updates from Firebase |
| 🌐 **Remote JSON Support** | 3.0.0+ | Load content from any REST API endpoint |
| 📚 **Version History** | 2.0.0+ | Browse all previous releases with navigation |

## 🎯 Quick Start

### Installation via Swift Package Manager

Add SwiftNEW to your project by adding the package URL in Xcode:

```
https://github.com/1998code/SwiftNEWKit
```

### Basic Implementation

1. **Import the framework**
```swift
import SwiftNEW
```

2. **Create a simple "What's New" view**
```swift
struct ContentView: View {
    @State private var showNew = false
    
    var body: some View {
        VStack {
            Text("My App")
                .font(.largeTitle)
            
            SwiftNEW(show: $showNew)
        }
    }
}
```

3. **Add your content**
Create a `data.json` file in your app bundle with your release notes:

```json
[
  {
    "version": "1.0",
    "new": [
      {
        "icon": "star.fill",
        "title": "Welcome",
        "subtitle": "Get Started",
        "body": "Thanks for downloading our app! Here's what's new."
      }
    ]
  }
]
```

### Advanced Example with Customization

```swift
struct ContentView: View {
    @State private var showNew = false
    
    var body: some View {
        SwiftNEW(
            show: $showNew,
            color: .constant(.blue),
            size: .constant("normal"),
            label: .constant("What's New"),
            labelImage: .constant("sparkles"),
            history: .constant(true),
            mesh: .constant(true),
            glass: .constant(true)
        )
    }
}
```

## 🎨 Preview & Gallery

![CleanShot 2022-06-11 at 22 54 15@2x](https://user-images.githubusercontent.com/54872601/173192927-ca2a8bef-2114-44f8-8d4d-47baadb8b4a8.png)

### Light & Dark Mode
![IMG_3472](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![IMG_3471](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG)
:---: | :---:
Light Native | Dark Native

### Advanced Features
![Simulator Screen Shot - iPhone 13 Pro Max](https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png) | ![CleanShot 2022-12-11 at 12 46 30@2x](https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png)
:---: | :---:
History View (2.0.0+) | App Icon Support (3.9.6+)

### Platform Support
![CleanShot 2023-06-22 at 14 24 07@2x](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) | <img alt="Screenshot 2024-07-01 at 10 18 33 PM" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508">
:---: | :---:
VisionOS Support (4.1.0+) | Mesh Gradient Background (5.3.0+)

## ⚙️ Configuration

### Available Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `show` * | `Binding<Bool>` | `false` | Controls the presentation state |
| `align` | `Binding<HorizontalAlignment>` | `.center` | Content alignment (`.leading`, `.center`, `.trailing`) |
| `color` | `Binding<Color>` | `.accentColor` | Primary theme color |
| `size` | `Binding<String>` | `"simple"` | Button size: `"invisible"`, `"mini"`, `"simple"`, `"normal"` |
| `labelColor` | `Binding<Color>` | System color | Button text color |
| `label` | `Binding<String>` | `"Show Release Note"` | Button display text |
| `labelImage` | `Binding<String>` | `"arrow.up.circle.fill"` | SF Symbol icon name |
| `history` | `Binding<Bool>` | `true` | Enable version history navigation |
| `data` | `Binding<String>` | `"data"` | Local JSON filename or remote URL |
| `showDrop` | `Binding<Bool>` | `false` | Use iOS drop notification style |
| `mesh` | `Binding<Bool>` | `true` | Enable mesh gradient backgrounds |
| `specialEffect` | `Binding<String>` | `""` | Special effects: `"Christmas"` or `""` |
| `glass` | `Binding<Bool>` | `true` | Enable glass morphism effects |

*Required parameter

### Configuration Examples

#### Minimal Setup
```swift
SwiftNEW(show: $showNew)
```

#### Custom Styling
```swift
SwiftNEW(
    show: $showNew,
    color: .constant(.purple),
    size: .constant("normal"),
    mesh: .constant(true),
    glass: .constant(true)
)
```

#### Remote Data Source
```swift
SwiftNEW(
    show: $showNew,
    data: .constant("https://api.example.com/releases.json")
)
```

#### Drop Notification Style (iOS only)
```swift
SwiftNEW(
    show: $showNew,
    label: .constant("New Update"),
    labelImage: .constant("bell.badge"),
    showDrop: .constant(true)
)
```

## 🔧 Data Sources

SwiftNEW supports multiple data sources for maximum flexibility:

### Local JSON Files

Create a JSON file in your app bundle (typically named `data.json`):

```json
[
  {
    "version": "1.2.0",
    "new": [
      {
        "icon": "hammer.fill",
        "title": "Bug Fixes",
        "subtitle": "Stability Improvements", 
        "body": "Resolved critical issues and improved overall app performance across all supported platforms."
      },
      {
        "icon": "sparkles",
        "title": "New Features",
        "subtitle": "Enhanced Experience",
        "body": "Introduced exciting new capabilities including improved animations and modern UI components."
      },
      {
        "icon": "shield.checkered",
        "title": "Security Updates",
        "subtitle": "Enhanced Protection",
        "body": "Strengthened security measures and updated encryption protocols for better data protection."
      }
    ]
  }
]
```

### Remote JSON APIs

Load content from any REST API endpoint:

```swift
SwiftNEW(
    show: $showNew,
    data: .constant("https://api.myapp.com/releases.json")
)
```

### Firebase Realtime Database

Direct integration with Firebase:

```swift
SwiftNEW(
    show: $showNew,
    data: .constant("https://your-project.firebaseio.com/releases.json")
)
```

### Data Structure Reference

The JSON structure follows this model:

```swift
// Reference only - you don't need to implement this
public struct Vmodel: Codable, Hashable {
    var version: String         // Version number (e.g., "1.2.0")
    var subVersion: String?     // Optional sub-version or build info
    var new: [Model]           // Array of release items
}

public struct Model: Codable, Hashable {
    var icon: String           // SF Symbol name (e.g., "star.fill")
    var title: String          // Feature title
    var subtitle: String       // Brief description
    var body: String           // Detailed explanation
}
```

### Best Practices

- **Local Files**: Best for static content and faster loading
- **Remote APIs**: Ideal for dynamic content and A/B testing
- **Firebase**: Perfect for real-time updates and content management
- **Version Format**: Use semantic versioning (1.2.3) for better organization
- **Content Length**: Keep titles short, use body for detailed descriptions

## 🛠️ Platform Support

### Supported Platforms

| Platform | Latest Tested | Minimum Required | Key Features |
|----------|---------------|------------------|--------------|
| **iOS** | 18.2 | 15.0+ | Full feature support, drop notifications, glass effects |
| **iPadOS** | 18.2 | 15.0+ | Optimized layouts, multitasking support |
| **macOS** | 15.2 | 14.0+ | Native macOS styling, menu bar integration |
| **visionOS** | 2.1 | 1.0+ | Spatial computing, immersive presentations |
| **tvOS** | 18.2 | 17.0+ | Remote-friendly navigation, living room UI |

### Development Requirements

| Tool | Version | Notes |
|------|---------|-------|
| **Xcode** | 15.0+ | Required for building and development |
| **macOS** | 14.0+ | Host development environment |
| **Swift** | 5.9+ / 6.1+ | Language compatibility and features |

### Feature Availability Matrix

| Feature | iOS | iPadOS | macOS | visionOS | tvOS |
|---------|-----|--------|--------|----------|------|
| Basic Presentations | ✅ | ✅ | ✅ | ✅ | ✅ |
| Mesh Gradients | ✅ | ✅ | ✅ | ✅ | ✅ |
| Glass Effects | ✅ | ✅ | ✅ | ✅ | ❌ |
| Drop Notifications | ✅ | ✅ | ❌ | ❌ | ❌ |
| History Navigation | ✅ | ✅ | ✅ | ✅ | ✅ |
| Remote JSON | ✅ | ✅ | ✅ | ✅ | ✅ |
| Special Effects | ✅ | ✅ | ✅ | ✅ | ✅ |
| Auto-versioning | ✅ | ✅ | ✅ | ✅ | ✅ |

## 📁 Installation Guide

Follow these steps to add SwiftNEW to your Xcode project:

### Step-by-Step Installation

| Step | Action | Screenshot |
|------|--------|------------|
| 1 | Open your Xcode project and select the project file | <img width="274" alt="Project Navigator" src="https://user-images.githubusercontent.com/54872601/173182521-27481cf2-c9bf-4f87-95cc-76f5d1c05094.png"> |
| 2 | Select your project target | <img width="174" alt="Target Selection" src="https://user-images.githubusercontent.com/54872601/173182523-6a24c67a-8f27-4ef7-a3f4-ea63cfd8436f.png"> |
| 3 | Go to "Package Dependencies" tab | <img width="309" alt="Package Dependencies" src="https://user-images.githubusercontent.com/54872601/173182526-e5660b7f-c50c-4173-81f5-83c10c514659.png"> |
| 4 | Click "+" and paste the repository URL | <img width="614" alt="Add Package" src="https://user-images.githubusercontent.com/54872601/173182527-2a151198-7ac0-4735-8257-11580ada3d5e.png"> |
| 5 | Choose your data source approach | See [Data Sources](#-data-sources) section |

### Package URL
```
https://github.com/1998code/SwiftNEWKit
```

### Post-Installation Setup

1. **Import the framework** in your Swift files:
```swift
import SwiftNEW
```

2. **Create your data source** (choose one):
   - **Local**: Add `data.json` to your app bundle
   - **Remote**: Use any JSON API endpoint  
   - **Firebase**: Configure Firebase Realtime Database

3. **Add to your view** with minimal configuration:
```swift
SwiftNEW(show: $showNewVersion)
```

## 🔧 Troubleshooting

### Common Issues

#### SwiftNEW doesn't appear
- Ensure the `show` binding is set to `true`
- Check that your data source (JSON file or URL) is accessible
- Verify the JSON format matches the expected structure

#### Data not loading
- For local files: Ensure `data.json` is added to your app bundle
- For remote URLs: Check network connectivity and URL validity
- Verify JSON structure matches the [sample format](#sample)

#### Build errors after installation
- Clean build folder (⌘+Shift+K)
- Update to latest Xcode version
- Ensure minimum platform requirements are met

#### Performance issues
- For large datasets, consider pagination
- Optimize image assets in your JSON data
- Use remote loading for better memory management

### Getting Help

- Check [GitHub Issues](https://github.com/1998code/SwiftNEWKit/issues) for known problems
- Search [GitHub Discussions](https://github.com/1998code/SwiftNEWKit/discussions) for community solutions
- Create a new issue with detailed information about your problem

## 📂 Project Structure

```
Sources/SwiftNEW/
├── SwiftNEW.swift                          # Main struct with initializers
├── Model.swift                             # Data models (Vmodel, Model)
├── Bundle+Ext.swift                        # Bundle extensions
├── Localizable.xcstrings                   # Localization support
├── 📁 Views/
│   ├── SwiftNEW+View.swift                # Main body view implementation
│   ├── 📁 Sheets/
│   │   ├── CurrentVersionSheet.swift       # Current version display
│   │   └── HistorySheet.swift             # Version history display
│   └── 📁 Components/
│       ├── HeaderView.swift               # Header components
│       └── ButtonComponents.swift         # Button components
├── 📁 Extensions/
│   └── SwiftNEW+Functions.swift           # Utility functions
├── 📁 Styles/
│   ├── AppIconView.swift                  # App icon display
│   ├── MeshView.swift                     # Gradient backgrounds
│   └── NoiseView.swift                    # Noise effects
└── 📁 Animations/
    └── SnowfallView.swift                 # Special effects (Christmas)
```

### Architecture Overview

SwiftNEW is built with a modular architecture that separates concerns for better maintainability:

- **Core Components**: Main struct and data models
- **View Layer**: Presentation components organized by functionality  
- **Extensions**: Utility functions and framework extensions
- **Styles**: Visual components and gradient effects
- **Animations**: Special effects and interactive elements

## 🤝 Contributing

We welcome contributions to SwiftNEW! Here's how you can help:

### Ways to Contribute

- 🐛 **Report Bugs**: Open an issue with detailed reproduction steps
- 💡 **Request Features**: Suggest new features or improvements
- 🔧 **Submit Pull Requests**: Fix bugs or implement new features
- 📚 **Improve Documentation**: Help make our docs clearer
- 🌍 **Add Translations**: Help us support more languages

### Development Setup

1. Fork the repository
2. Clone your fork locally
3. Open `Package.swift` in Xcode
4. Make your changes
5. Test thoroughly across platforms
6. Submit a pull request

### Coding Guidelines

- Follow Swift naming conventions
- Maintain compatibility with minimum platform versions
- Add appropriate documentation comments
- Test on multiple platforms when possible
- Keep changes focused and atomic

### Getting Help

- 💬 [GitHub Discussions](https://github.com/1998code/SwiftNEWKit/discussions) - Questions and community support
- 🐛 [GitHub Issues](https://github.com/1998code/SwiftNEWKit/issues) - Bug reports and feature requests
- 📧 Contact the maintainer for complex questions

## 📄 License

SwiftNEW is available under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🌍 Translations

This documentation is available in multiple languages:

English | [繁中](README/README_tc.md) / [简中](README/README_zh.md) / [粵語](README/README_hc.md) | [日本語](README/README_ja.md) | [한국어](README/README_ko.md)

Help us add more languages by submitting translation pull requests!

## 💖 Supported By

<a href="https://m.do.co/c/ce873177d9ab">
    <img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/SVG/DO_Logo_horizontal_blue.svg" width="201px" alt="Digital Ocean">
</a>

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/1998code/SwiftNEWKit)

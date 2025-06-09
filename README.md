<img width="150" alt="SNK" src="https://github.com/user-attachments/assets/1121ae03-cf96-455e-8119-596f6f5eb58e" />

# SwiftNEW

![Stable](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=03A791&label=Stable)
![Beta](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?include_prereleases&color=3A59D1&label=Beta)
[![Validate JSON Files](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml/badge.svg)](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml)
![Swift Version](https://img.shields.io/badge/Swift-5.9/6.1-teal.svg)

![Platforms](https://img.shields.io/badge/Platforms-iOS%2015.0+%20|%20macOS%2014.0+%20|%20tvOS%2017.0+%20|%20visionOS%201.0+-15437D.svg)
![License](https://img.shields.io/badge/License-MIT-C8ECFE.svg)

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

A modern, SwiftUI-native "What's New" presentation framework for iOS, macOS, tvOS, and visionOS apps. Built with a modular architecture for easy customization and maintenance.

## 📋 Table of Contents

- [🎨 Preview & Gallery](#-preview--gallery)
- [✨ Features](#-features)
- [🎯 Quick Start](#-quick-start)
- [⚙️ Configuration Parameters](#️-configuration-parameters)
- [🔧 Data Configuration](#-data-configuration)
- [🛠️ Platform Compatibility](#️-platform-compatibility)
- [🔧 Troubleshooting](#-troubleshooting)
- [📂 Project Structure](#-project-structure)
- [Contributing](#contributing)

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
| 🎨 **Mesh Gradient & Linear Gradient** | 5.3.0 | Beautiful gradient backgrounds |
| 🥽 **Apple visionOS & Vision Pro** | 4.1.0 | Full visionOS support |
| 🔄 **Auto-trigger on Version Change** | 4.0.0 | Automatically shows when app version or build changes |
| 📊 **Flexible Version Numbers** | 4.0.0 | Supports x.y.z and x.y version formats |
| 📱 **Remote Drop Notifications** | 3.5.0 | iOS notification-style alerts |
| 🔥 **Firebase Real-Time Database** | 3.0.0 | Live content updates |
| 🌐 **Remote JSON Support** | 3.0.0 | Load content from any URL |
| 📚 **Version History** | 2.0.0 | View all previous releases |

## 🎯 Quick Start

### 1. Installation

#### Swift Package Manager
```
https://github.com/1998code/SwiftNEWKit
```

### 2. Basic Usage

```swift
import SwiftNEW

struct ContentView: View {
    @State private var showNew = false
    
    var body: some View {
        VStack {
            // Your app content
            Text("My App")
            
            Button("Show What's New") {
                showNew = true
            }
        }
        .sheet(isPresented: $showNew) {
            SwiftNEW(show: $showNew)
        }
    }
}
```

### 3. Advanced Configuration

```swift
struct ContentView: View {
    @State private var showNew = false
    @State private var color: Color = .blue
    @State private var align: HorizontalAlignment = .center
    
    var body: some View {
        SwiftNEW(
            show: $showNew,
            align: $align,
            color: $color,
            size: .constant("normal"),
            label: .constant("What's New"),
            history: .constant(true),
            data: .constant("data"), // or remote URL
            mesh: .constant(true)
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

## ⚙️ Configuration Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `show` * | `Binding<Bool>` | `false` | `true`, `false` | Controls sheet presentation |
| `align` | `Binding<HorizontalAlignment>` | `.center` | `.leading`, `.center`, `.trailing` | Content alignment |
| `color` | `Binding<Color>` | `.accentColor` | Any Color | Primary theme color |
| `size` | `Binding<String>` | `"simple"` | `"invisible"`, `"mini"`, `"simple"`, `"normal"` | Button size variant |
| `labelColor` | `Binding<Color>` | System Background | Any Color | Button text color |
| `label` | `Binding<String>` | `"Show Release Note"` | Any String | Button display text |
| `labelImage` | `Binding<String>` | `"arrow.up.circle.fill"` | Any SF Symbol | Button icon |
| `history` | `Binding<Bool>` | `true` | `true`, `false` | Enable history view |
| `data` | `Binding<String>` | `"data"` | Local filename or URL | Data source location |
| `showDrop` | `Binding<Bool>` | `false` | `true`, `false` | iOS drop notification style |
| `mesh` | `Binding<Bool>` | `true` | `true`, `false` | Enable gradient background |
| `specialEffect` | `Binding<String>` | `""` | `"Christmas"`, `""` | Special animation effects |

*Required parameter

### Parameter Usage Examples

```swift
// Minimal configuration
SwiftNEW(show: $showNew)

// Custom styling
SwiftNEW(
    show: $showNew,
    color: .constant(.blue),
    mesh: .constant(false)
)

// Remote data source
SwiftNEW(
    show: $showNew,
    data: .constant("https://api.example.com/releases.json")
)

// Complete customization
SwiftNEW(
    show: $showNew,
    align: .constant(.leading),
    color: .constant(.purple),
    size: .constant("normal"),
    label: .constant("See Updates"),
    labelImage: .constant("star.fill"),
    history: .constant(true),
    data: .constant("releases"),
    mesh: .constant(true),
    specialEffect: .constant("Christmas")
)
```

## 🔧 Data Configuration

### Local JSON File
Create a `data.json` file in your app bundle:

```json
[
  {
    "version": "1.2",
    "new": [
      {
        "icon": "hammer.fill",
        "title": "Bug Fixes",
        "subtitle": "Stability Improvements",
        "body": "Fixed crashes and improved performance across all platforms"
      },
      {
        "icon": "sparkles",
        "title": "New Features",
        "subtitle": "Enhanced Experience",
        "body": "Added new animations and improved user interface"
      }
    ]
  }
]
```

### Remote JSON/Firebase
```swift
SwiftNEW(
    show: $showNew,
    data: .constant("https://your-server.com/releases.json")
)
```

### Firebase Realtime Database
```swift
SwiftNEW(
    show: $showNew,
    data: .constant("https://your-project.firebaseio.com/releases.json")
)
```

## 🛠️ Platform Compatibility

| Platform | Latest Tested | Minimum Required | Key Features |
|----------|---------------|------------------|--------------|
| **iOS** | 18.5 | 15.0+ | Full feature support, drop notifications |
| **iPadOS** | 18.5 | 15.0+ | Optimized layouts, full feature support |
| **macOS** | 15.5 | 14.0+ | Native macOS styling, full feature support |
| **visionOS** | 2.0 | 1.0+ | Spatial computing support, immersive UI |
| **tvOS** | 18.5 | 17.0+ | Remote-friendly navigation, adapted layouts |

### Development Environment
| Tool | Version | Notes |
|------|---------|-------|
| **Xcode** | 13.4+ (13F17a) | Minimum required for package resolution |
| **macOS** | 12.3.1+ (21E258) | Host development environment |
| **Swift** | 5.9+ / 6.1+ | Language compatibility |

### Feature Availability by Platform
| Feature | iOS | iPadOS | macOS | visionOS | tvOS |
|---------|-----|--------|--------|----------|------|
| Basic What's New | ✅ | ✅ | ✅ | ✅ | ✅ |
| Mesh Gradients | ✅ | ✅ | ✅ | ✅ | ✅ |
| Drop Notifications | ✅ | ✅ | ❌ | ❌ | ❌ |
| History View | ✅ | ✅ | ✅ | ✅ | ✅ |
| Remote JSON | ✅ | ✅ | ✅ | ✅ | ✅ |
| Special Effects | ✅ | ✅ | ✅ | ✅ | ✅ |

### Setup
Steps | Description | Screenshot
------| ----------- | ----------
1 | Navigate to root project | <img width="274" alt="CleanShot 2022-06-11 at 17 39 39@2x" src="https://user-images.githubusercontent.com/54872601/173182521-27481cf2-c9bf-4f87-95cc-76f5d1c05094.png">
2 | Select Project | <img width="174" alt="CleanShot 2022-06-11 at 17 39 48@2x" src="https://user-images.githubusercontent.com/54872601/173182523-6a24c67a-8f27-4ef7-a3f4-ea63cfd8436f.png">
3 | Select Package Dependencies | <img width="309" alt="CleanShot 2022-06-11 at 17 39 53@2x" src="https://user-images.githubusercontent.com/54872601/173182526-e5660b7f-c50c-4173-81f5-83c10c514659.png">
4 | Click + and paste <code>https://github.com/1998code/SwiftNEWKit</code> to the searchbox | <img width="614" alt="CleanShot 2022-06-11 at 17 39 32@2x" src="https://user-images.githubusercontent.com/54872601/173182527-2a151198-7ac0-4735-8257-11580ada3d5e.png">
5L | Create a new local file called `data.json` | You may copy this [JSON sample](https://github.com/1998code/SwiftNEWKit#sample). 
5R | You can use remote JSON / firebase realtime database too. | Sample: https://testground-a937f-default-rtdb.firebaseio.com/0.json?print=pretty

### Major Usage
1. Import Package.
```swift
import SwiftNEW
```

2. Add States before `body` or any `some View`.
### States
var         | Suggested                       | Options                       | Type
----------- | ------------------------------- | ----------------------------- | ----
showNew *   | false                           | false, true                   | Bool
align       | .center                         | .leading, .center, .trailing  | HorizontalAlignment
color       | .accentColor                    | All Colors Supported          | Color
size        | "simple"                        | "invisible", "mini", "simple" | String
labelColor  | UIColor.systemBackground or NSColor.windowBackgroundColor | All Colors Supported          | Color
label       | "Show Release Note"             | All Strings                   | String
labelImage  | "arrow.up.circle.fill"          | All SF Symbols                | String
history     | true                            | true, false                   | Bool
data        | "data" or "https://.../{}.json" | "{LOCAL_JSON_FILE}" or Remote | String
showDrop    | false                           | false, true                   | Bool
mesh        | true                            | false, true                   | Bool


##### Samples:
```swift
// Required
@State var showNew: Bool = false

// Optional (5.2.0 or above)
@State var align: HorizontalAlignment = .center
@State var color: Color = .accentColor
@State var size: String = "normal"
#if os(iOS)
@State var labelColor: Color = Color(UIColor.systemBackground)
#elseif os(macOS)
@State var labelColor: Color = Color(NSColor.windowBackgroundColor)
#endif
@State var label: String = "Show Release Note"
@State var labelImage: String = "arrow.up.circle.fill"
@State var history: Bool = true
@State var data: String = "data"
@State var showDrop: Bool = false
@State var mesh: Bool = false
```

3. Then, paste this code inside `body` or any `some View`.
```swift
// Simplified with default options in 5.2.0 or above
SwiftNEW(show: $showNew)

// 5.1.0 or below
SwiftNEW(show: $showNew, align: $align, color: $color, size: $size, labelColor: $labelColor, label: $label, labelImage: $labelImage, history: $history, data: $data, showDrop: $showDrop)
```
Instead of using separate states, inline states work too. (No longer required after 5.2.0)

*`Show Bool` cannot be inline.
```swift
SwiftNEW(show: $showNew, align: .constant(.center), color: .constant(.accentColor), size: .constant("normal"), labelColor: .constant(Color(UIColor.systemBackground)), label: .constant("Show Release Note"), labelImage: .constant("arrow.up.circle.fill"), history: .constant(true), data: .constant("data"), showDrop: .constant(false))
```

4. Your code should look similar to the following, including the minimum features and default styles.
```swift
struct ContentView: View {
    @State var showNew: Bool = false
    var body: some View {
        SwiftNEW(show: $showNew)
    }
}
```

### JSON
#### Structure / Model (REF)
* The below code is just for reference only. You don't need to copy the structure or model.
```swift
public struct Vmodel: Codable, Hashable {
    var version: String
    var new: [Model]
}
public struct Model: Codable, Hashable {
    var icon: String
    var title: String
    var subtitle: String
    var body: String
}
```

#### Sample
Copy the JSON sample to `data.json` file (If you don't have it, create a new file.)

![68747470733a2f2f76616c696461746f722e737761676765722e696f2f76616c696461746f723f75726c3d68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f4f41492f4f70656e4150492d53706563696669636174696f6e2f6d61737465722f6578616d706c65732f76](https://user-images.githubusercontent.com/54872601/173190828-8ee763b9-4e33-4231-92ac-eb81b556c462.png)
```json
[
  {
    "version": "1.2",
    "new": [
      {
        "body": "Available for iOS 16, iPadOS 16, macOS 13",
        "icon": "hammer.fill",
        "subtitle": "Broken UI",
        "title": "Bug fixes"
      },
      {
        "body": "Direct load via remote storage. Easy!",
        "icon": "square.and.arrow.down.fill",
        "subtitle": "Supported",
        "title": "Firebase Remote"
      },
      {
        "body": "Free and open source! Created by Ming with ❤️‍🔥",
        "icon": "macpro.gen3.server",
        "subtitle": "Design",
        "title": "Serverless"
      },
      {
        "body": "Pull requests and make it better for everyone!",
        "icon": "arrow.triangle.pull",
        "subtitle": "Together",
        "title": "Contribute"
      }
    ]
  },
  {
   "version": "1.1",
    "new": [
      {
        "body": "Available for iOS 16, iPadOS 16, macOS 13",
        "icon": "hammer.fill",
        "subtitle": "Broken UI",
        "title": "Bug fixes"
      },
      {
        "body": "Direct load via local storage. Super fast!",
        "icon": "square.and.arrow.down.fill",
        "subtitle": "Supported",
        "title": "Local File"
      },
      {
        "body": "Free and open source! Created by Ming with ❤️‍🔥",
        "icon": "macpro.gen3.server",
        "subtitle": "Design",
        "title": "Serverless"
      },
      {
        "body": "Pull requests and make it better for everyone!",
        "icon": "arrow.triangle.pull",
        "subtitle": "Together",
        "title": "Contribute"
      }
    ]
  }
]
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

## Contributing

Contributions to SwiftNEW are welcome!

- To report bugs or request features, please open an issue on GitHub
- When submitting a pull request, please follow the coding style of the project

## License

MIT. Read the LICENSE file for details.

## Translation

This doc is also available in:

English | [繁中](README/README_tc.md) / [简中](README/README_zh.md) / [粵語](README/README_hc.md) | [日本語](README/README_ja.md) | [한국어](README/README_ko.md)

Please feel free to open a pull request and add new language(s) or fix any typos/mistakes.

## Supported By
<a href="https://m.do.co/c/ce873177d9ab">
    <img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/SVG/DO_Logo_horizontal_blue.svg" width="201px" alt="Digital Ocean Logo">
</a>
<br/>
<br/>

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/1998code/SwiftNEWKit)

<img width="150" alt="SNK" src="https://github.com/user-attachments/assets/1121ae03-cf96-455e-8119-596f6f5eb58e" />

# SwiftNEW

![Stable](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=03A791&label=稳定版)
![Beta](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?include_prereleases&color=3A59D1&label=测试版)
[![Validate JSON Files](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml/badge.svg)](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml)
![Swift Version](https://img.shields.io/badge/Swift-5.9/6.1-teal.svg)

![Platforms](https://img.shields.io/badge/Platforms-iOS%2015.0+%20|%20macOS%2014.0+%20|%20tvOS%2017.0+%20|%20visionOS%201.0+-15437D.svg)
![License](https://img.shields.io/badge/License-MIT-C8ECFE.svg)

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

现代化的 SwiftUI 原生「最新功能」展示框架，专为所有 Apple 平台设计。具备美观动画、渐变背景、远程数据加载和全面定制选项，用于创建引人入胜的版本说明和功能公告。

## 📋 目录

- [✨ 功能特色](#-功能特色)
- [🎯 快速开始](#-快速开始)
- [🎨 预览与展示](#-预览与展示)
- [⚙️ 配置](#️-配置)
- [🔧 数据源](#-数据源)
- [🛠️ 平台支持](#️-平台支持)
- [📁 安装指南](#-安装指南)
- [🔧 疑难解答](#-疑难解答)
- [📂 项目结构](#-项目结构)
- [🤝 贡献](#-贡献)

## 🎨 预览与展示

![CleanShot 2022-06-11 at 22 54 15@2x](https://user-images.githubusercontent.com/54872601/173192927-ca2a8bef-2114-44f8-8d4d-47baadb8b4a8.png)

### 浅色与深色主题
![IMG_3472](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![IMG_3471](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG)
:---: | :---:
浅色原生 | 深色原生

### 高级功能
![Simulator Screen Shot - iPhone 13 Pro Max](https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png) | ![CleanShot 2022-12-11 at 12 46 30@2x](https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png)
:---: | :---:
历史视图 (2.0.0+) | 应用程序图标支持 (3.9.6+)

### 平台支持
![CleanShot 2023-06-22 at 14 24 07@2x](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) | <img alt="Screenshot 2024-07-01 at 10 18 33 PM" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508">
:---: | :---:
VisionOS 支持 (4.1.0+) | 网格渐变背景 (5.3.0+)

## ✨ 功能特色

| 功能 | 版本 | 描述 |
|---------|---------|-------------|
| 🎨 **玻璃拟态效果** | 5.5.0+ | 现代玻璃模糊效果，具可定制的透明度 |
| 🌈 **网格与线性渐变** | 5.3.0+ | 美观的动画渐变背景 |
| 🥽 **visionOS 与 Vision Pro** | 4.1.0+ | 原生空间计算支持 |
| 🔄 **版本变更自动触发** | 4.0.0+ | 当应用程序版本或构建版本变更时自动显示 |
| 📊 **灵活版本号** | 4.0.0+ | 支持语义化版本 (x.y.z) 和简化 (x.y) 格式 |
| 🎄 **特殊效果** | 3.9.0+ | 季节性动画（圣诞雪花） |
| 📱 **下拉通知** | 3.5.0+ | iOS 风格通知横幅 |
| 🔥 **Firebase 实时数据库** | 3.0.0+ | 来自 Firebase 的实时内容更新 |
| 🌐 **远程 JSON 支持** | 3.0.0+ | 从任何 REST API 端点加载内容 |
| 📚 **版本历史** | 2.0.0+ | 浏览所有先前版本并进行导航 |

## 示例
路径: `./Demo` (Xcode 项目)

## 版本
![GitHub release (latest by date)](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=g&label=稳定版&style=for-the-badge)
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=green&include_prereleases&label=测试版&style=for-the-badge)

![swiftui-128x128_2x](https://user-images.githubusercontent.com/54872601/173193069-2eb486b0-1347-4448-ac2b-235b8f2f1bb0.png)

## 测试平台和环境
### 本地
测试平台 | 最新版本 | 兼容版本
-------- | ------ | ----------
iOS      | 18.4   | > 14
iPadOS   | 18.2   | > 14
macOS    | 15.2   | > 11
visionOS | 2      | > 1
### 云端
测试平台 | 兼容版本
-------- | ----------
Xcode    | > 13.4 (13F17a)
macOS    | > 12.3.1 (21E258)

### 设置
步骤 | 描述 | 截图
------| ----------- | ----------
1 | 导航到根项目 | <img width="274" alt="CleanShot 2022-06-11 at 17 39 39@2x" src="https://user-images.githubusercontent.com/54872601/173182521-27481cf2-c9bf-4f87-95cc-76f5d1c05094.png">
2 | 选择项目 | <img width="174" alt="CleanShot 2022-06-11 at 17 39 48@2x" src="https://user-images.githubusercontent.com/54872601/173182523-6a24c67a-8f27-4ef7-a3f4-ea63cfd8436f.png">
3 | 选择包依赖项 | <img width="309" alt="CleanShot 2022-06-11 at 17 39 53@2x" src="https://user-images.githubusercontent.com/54872601/173182526-e5660b7f-c50c-4173-81f5-83c10c514659.png">
4 | 点击 + 并粘贴 <code>https://github.com/1998code/SwiftNEWKit</code> 到搜索框 | <img width="614" alt="CleanShot 2022-06-11 at 17 39 32@2x" src="https://user-images.githubusercontent.com/54872601/173182527-2a151198-7ac0-4735-8257-11580ada3d5e.png">
5L | 创建一个名为 `data.json` 的新本地文件 | 您可以复制这个 [JSON 示例](https://github.com/1998code/SwiftNEWKit#sample)。
5R | 您也可以使用远程 JSON / firebase 实时数据库。 | 示例: https://testground-a937f-default-rtdb.firebaseio.com/0.json?print=pretty

### 主要用法
1. 导入包。
```swift
import SwiftNEW
```

2. 在 `body` 或任何 `some View` 之前添加状态。
### 状态
变量        | 建议值                         | 选项                          | 类型
----------- | ------------------------------ | ----------------------------- | ----
showNew *   | false                          | false, true                   | Bool
align       | .center                        | .leading, .center, .trailing  | HorizontalAlignment
color       | .accentColor                   | 支持所有颜色                  | Color
size        | "simple"                       | "invisible", "mini", "simple" | String
labelColor  | UIColor.systemBackground 或 NSColor.windowBackgroundColor | 支持所有颜色               | Color
label       | "显示发布说明"                  | 所有字符串                    | String
labelImage  | "arrow.up.circle.fill"         | 所有 SF 符号                  | String
history     | true                           | true, false                   | Bool
data        | "data" 或 "https://.../{}.json"| "{本地JSON文件}" 或 远程      | String
showDrop    | false                          | false, true                   | Bool
mesh        | true                           | false, true                   | Bool

##### 示例:
```swift
// 必需
@State var showNew: Bool = false

// 可选 (5.2.0 或更高版本)
@State var align: HorizontalAlignment = .center
@State var color: Color = .accentColor
@State var size: String = "normal"
#if os(iOS)
@State var labelColor: Color = Color(UIColor.systemBackground)
#elseif os(macOS)
@State var labelColor: Color = Color(NSColor.windowBackgroundColor)
#endif
@State var label: String = "显示发布说明"
@State var labelImage: String = "arrow.up.circle.fill"
@State var history: Bool = true
@State var data: String = "data"
@State var showDrop: Bool = false
@State var mesh: Bool = false
```

3. 然后，将此代码粘贴到 `body` 或任何 `some View` 内部。
```swift
// 5.2.0 或更高版本中使用默认选项的简化版本
SwiftNEW(show: $showNew)

// 5.1.0 或更低版本
SwiftNEW(show: $showNew, align: $align, color: $color, size: $size, labelColor: $labelColor, label: $label, labelImage: $labelImage, history: $history, data: $data, showDrop: $showDrop)
```
除了使用单独的状态外，内联状态也可以工作。(5.2.0 后不再需要)

*`Show Bool` 不能内联。
```swift
SwiftNEW(show: $showNew, align: .constant(.center), color: .constant(.accentColor), size: .constant("normal"), labelColor: .constant(Color(UIColor.systemBackground)), label: .constant("显示发布说明"), labelImage: .constant("arrow.up.circle.fill"), history: .constant(true), data: .constant("data"), showDrop: .constant(false))
```

4. 您的代码应类似于以下内容，包含最小功能和默认样式。
```swift
struct ContentView: View {
    @State var showNew: Bool = false
    var body: some View {
        SwiftNEW(show: $showNew)
    }
}
```

### JSON
#### 结构 / 模型 (参考)
* 以下代码仅供参考。您不需要复制结构或模型。
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

#### 示例
将 JSON 示例复制到 `data.json` 文件中（如果您没有该文件，请创建一个新文件。）

![68747470733a2f2f76616c696461746f722e737761676765722e696f2f76616c696461746f723f75726c3d68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f4f41492f4f70656e4150492d53706563696669636174696f6e2f6d61737465722f6578616d706c65732f76](https://user-images.githubusercontent.com/54872601/173190828-8ee763b9-4e33-4231-92ac-eb81b556c462.png)
```json
[
  {
    "version": "1.2",
    "new": [
      {
        "body": "适用于 iOS 16, iPadOS 16, macOS 13",
        "icon": "hammer.fill",
        "subtitle": "修复UI问题",
        "title": "错误修复"
      },
      {
        "body": "通过远程存储直接加载。很简单！",
        "icon": "square.and.arrow.down.fill",
        "subtitle": "已支持",
        "title": "Firebase 远程"
      },
      {
        "body": "免费开源！由 Ming 用 ❤️‍🔥 创建",
        "icon": "macpro.gen3.server",
        "subtitle": "设计",
        "title": "无服务器"
      },
      {
        "body": "提交拉取请求，让它对每个人都更好！",
        "icon": "arrow.triangle.pull",
        "subtitle": "一起",
        "title": "贡献"
      }
    ]
  },
  {
   "version": "1.1",
    "new": [
      {
        "body": "适用于 iOS 16, iPadOS 16, macOS 13",
        "icon": "hammer.fill",
        "subtitle": "修复UI问题",
        "title": "错误修复"
      },
      {
        "body": "通过本地存储直接加载。超快速！",
        "icon": "square.and.arrow.down.fill",
        "subtitle": "已支持",
        "title": "本地文件"
      },
      {
        "body": "免费开源！由 Ming 用 ❤️‍🔥 创建",
        "icon": "macpro.gen3.server",
        "subtitle": "设计",
        "title": "无服务器"
      },
      {
        "body": "提交拉取请求，让它对每个人都更好！",
        "icon": "arrow.triangle.pull",
        "subtitle": "一起",
        "title": "贡献"
      }
    ]
  }
]
```

## 📂 项目结构

```
Sources/SwiftNEW/
├── SwiftNEW.swift                          # 主要结构体与初始化
├── Model.swift                             # 数据模型 (Vmodel, Model)
├── Bundle+Ext.swift                        # Bundle 扩展
├── Localizable.xcstrings                   # 本地化支持
├── 📁 Views/
│   ├── SwiftNEW+View.swift                # 主要 body 视图实现
│   ├── 📁 Sheets/
│   │   ├── CurrentVersionSheet.swift       # 当前版本显示
│   │   └── HistorySheet.swift             # 版本历史显示
│   └── 📁 Components/
│       ├── HeaderView.swift               # 标题组件
│       └── ButtonComponents.swift         # 按钮组件
├── 📁 Extensions/
│   └── SwiftNEW+Functions.swift           # 实用函数
├── 📁 Styles/
│   ├── AppIconView.swift                  # 应用图标显示
│   ├── MeshView.swift                     # 渐变背景
│   └── NoiseView.swift                    # 噪点效果
└── 📁 Animations/
    └── SnowfallView.swift                 # 特殊效果（圣诞节）
```

### 架构概述

SwiftNEW 采用模块化架构构建，分离关注点以提升可维护性：

- **主要结构体** (`SwiftNEW.swift`): 公开 API 与配置选项
- **视图层级** (`Views/`): UI 组件的逻辑分组
- **数据模型** (`Model.swift`): JSON 数据结构
- **扩展** (`Extensions/`): 实用函数与辅助功能
- **样式** (`Styles/`): 可重用的视觉组件
- **动画** (`Animations/`): 特殊效果与动画

## 贡献

欢迎对 SwiftNEW 做出贡献！

- 要报告错误或请求功能，请在 GitHub 上提出问题
- 提交拉取请求时，请遵循项目的编码风格

## 许可证

MIT。 详情请阅读 LICENSE 文件。

## 翻译

本文档还有其他语言版本:

[English](../README.md) | 简中 / [繁中](README_tc.md) / [粵語](README_hc.md) | [日本語](README_ja.md) | [한국어](README_ko.md)

请随时提交拉取请求，添加新语言或修复任何错别字/错误。

## 支持
<a href="https://m.do.co/c/ce873177d9ab">
    <img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/SVG/DO_Logo_horizontal_blue.svg" width="201px" alt="Digital Ocean 標誌">
</a>
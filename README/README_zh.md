<img width="150" alt="SNK" src="https://github.com/user-attachments/assets/1121ae03-cf96-455e-8119-596f6f5eb58e" />

# SwiftNEW

![Stable](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=03A791&label=稳定版)
![Beta](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?include_prereleases&color=3A59D1&label=测试版)
[![Validate JSON Files](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml/badge.svg)](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml)
![Swift Version](https://img.shields.io/badge/Swift-5.9/6.1-teal.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2015.0+%20|%20macOS%2014.0+%20|%20tvOS%2017.0+%20|%20visionOS%201.0+-15437D.svg)
![License](https://img.shields.io/badge/License-MIT-C8ECFE.svg)

[English](../README.md) · [繁中](README_tc.md) · **简中** · [粵語](README_hc.md) · [日本語](README_ja.md) · [한국어](README_ko.md)

现代、SwiftUI 原生的 **「最新功能」** 展示框架,适用于所有 Apple 平台 — 内置动画渐变背景、玻璃效果、远程数据加载,并完整支持 RTL 与本地化。

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

## 🎨 图库

| 浅色 | 深色 |
|:-----:|:----:|
| ![Light](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![Dark](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG) |

## 🚀 快速开始

**1. 添加包**:在 Xcode → *File → Add Package Dependencies…*

> [!IMPORTANT]
> **包 URL**
>
> ```
> https://github.com/1998code/SwiftNEWKit
> ```

**2. 添加 `data.json`** 到 App Bundle:

> [!TIP]
> 示例版本说明 JSON
>
> ```json
> [
>   {
>     "version": "1.0",
>     "new": [
>       { "icon": "star.fill", "title": "欢迎", "subtitle": "立即开始", "body": "感谢您下载我们的应用!" }
>     ]
>   }
> ]
> ```

**3. 在 View 中使用:**

> [!NOTE]
> 最简 SwiftUI 集成
>
> ```swift
> import SwiftNEW
>
> struct ContentView: View {
>     @State private var showNew = false
>     var body: some View {
>         SwiftNEW(show: $showNew)
>     }
> }
> ```

完成 — 应用版本变更时,SwiftNEW 会自动触发。

## ✨ 功能

| 功能 | 起始版本 | 说明 |
|---------|:-----:|-------------|
| 🔍 内嵌搜索 | 6.3.0 | 按标题 / 副标题 / 正文过滤当前版本说明 |
| 🏷️ 自定义标题 | 6.3.0 | `headingStyle`:`.version`、`.versionOnly`、`.appName` |
| 🎯 图标样式 | 6.3.0 | `iconStyle`:`.filled`(色块底)或 `.plain`(仅图标) |
| 🔢 可选构建号 | 6.3.0 | 通过 `showBuild: false` 隐藏构建号 |
| 🎨 浮动粒子特效 | 6.3.0 | 全新 `.particles` 特效(TimelineView + Canvas) |
| 🎯 多种呈现方式 | 6.2.0 | `.sheet`、`.fullScreenCover`、`.embed` |
| 🌈 自适应文本色 | 6.2.0 | 按钮文字自动适应背景 |
| 🛠️ 简化初始化 | 6.2.0 | 直接传值 — 无需 `.constant()` 包装 |
| 🪟 玻璃拟态 | 5.5.0 | 透明度可调的现代模糊效果 |
| 🌈 网格与线性渐变 | 5.3.0 | 动画渐变背景 |
| 🥽 visionOS 支持 | 4.1.0 | 原生空间计算 |
| 🔄 自动触发 | 4.0.0 | 版本/构建变更时自动显示 |
| 🎄 特殊效果 | 3.9.0 | `.christmas` 雪花、`.particles` 彩虹 |
| 📱 Drop 通知 | 3.5.0 | iOS 风格横幅通知 |
| 🔥 Firebase Realtime DB | 3.0.0 | 实时内容更新 |
| 🌐 远程 JSON | 3.0.0 | 从任意 REST 端点加载 |
| 📚 版本历史 | 2.0.0 | 浏览所有历史版本 |

### 功能展示

| 网格渐变 (5.3+) | visionOS (4.1+) |
|:--------------------:|:---------------:|
| <img alt="Mesh" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508"> | ![visionOS](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) |

| App 图标 (3.9.6+) | 历史 (2.0+) |
|:-----------------:|:--------------:|
| <img height="400" alt="App Icon" src="https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png"> | <img height="400" alt="History" src="https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png"> |

## 📚 了解更多

| 文档 | 涵盖内容 |
|-------|--------|
| [Configuration](CONFIGURATION.md) | 全部参数、示例、数据源(本地 / 远程 / Firebase)、数据模型 |
| [Platform Support & Installation](PLATFORM.md) | 支持的 OS 版本、需求、功能对照表、SPM 设置 |
| [Contributing](CONTRIBUTING.md) | 项目结构、开发环境、PR 规范、故障排查 |

## 📄 许可证

SwiftNEW 采用 **MIT License** — 最宽松的开源许可证之一。

| | 详情 |
|---|---------|
| ✅ **可以** | 用于商业应用(包括 App Store 付费应用)、修改、再分发,并集成到闭源软件中 |
| 📝 **必须** | 在您的项目中保留原始版权与许可声明 |
| ⚠️ **无担保** | 软件按「原样」提供 — 作者不对使用所造成的任何问题负责 |

完整内容请见 [LICENSE](../LICENSE)。

## 💖 赞助支持

| 赞助商 | 资源 |
|---------|----------|
| <a href="https://m.do.co/c/ce873177d9ab"><img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/SVG/DO_Logo_horizontal_blue.svg" width="160px" alt="Digital Ocean"></a> | 云端基础设施 |
| [![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/1998code/SwiftNEWKit) | AI 文档问答 |

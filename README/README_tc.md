<img width="150" alt="SNK" src="https://github.com/user-attachments/assets/1121ae03-cf96-455e-8119-596f6f5eb58e" />

# SwiftNEW

![Stable](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=03A791&label=穩定版)
![Beta](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?include_prereleases&color=3A59D1&label=測試版)
[![Validate JSON Files](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml/badge.svg)](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml)
![Swift Version](https://img.shields.io/badge/Swift-5.9/6.1-teal.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2015.0+%20|%20macOS%2014.0+%20|%20tvOS%2017.0+%20|%20visionOS%201.0+-15437D.svg)
![License](https://img.shields.io/badge/License-MIT-C8ECFE.svg)

[English](../README.md) · **繁中** · [简中](README_zh.md) · [粵語](README_hc.md) · [日本語](README_ja.md) · [한국어](README_ko.md)

現代、SwiftUI 原生的 **「最新功能」** 展示框架,適用於所有 Apple 平台 — 內建動畫漸層背景、玻璃效果、遠端資料載入,並完整支援 RTL 與在地化。

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

## 🎨 圖庫

| 淺色 | 深色 |
|:-----:|:----:|
| ![Light](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![Dark](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG) |

## 🚀 快速開始

**1. 加入套件**:在 Xcode → *File → Add Package Dependencies…*

> [!IMPORTANT]
> **套件 URL**
>
> ```
> https://github.com/1998code/SwiftNEWKit
> ```

**2. 加入 `data.json`** 至 App Bundle:

> [!TIP]
> 範例版本說明 JSON
>
> ```json
> [
>   {
>     "version": "1.0",
>     "new": [
>       { "icon": "star.fill", "title": "歡迎", "subtitle": "立即上手", "body": "感謝您下載我們的 App!" }
>     ]
>   }
> ]
> ```

**3. 在 View 中使用:**

> [!NOTE]
> 最簡 SwiftUI 整合
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

完成 — SwiftNEW 會在 App 版本變更時自動觸發。

## ✨ 功能

| 功能 | 起始版本 | 說明 |
|---------|:-----:|-------------|
| 🔍 內嵌搜尋 | 6.3.0 | 依標題 / 副標題 / 內文過濾目前版本說明 |
| 🏷️ 自訂標題 | 6.3.0 | `headingStyle`:`.version`、`.versionOnly`、`.appName` |
| 🎯 圖示樣式 | 6.3.0 | `iconStyle`:`.filled`(色塊底)或 `.plain`(僅圖示) |
| 🔢 可選建置號碼 | 6.3.0 | 透過 `showBuild: false` 隱藏建置號碼 |
| 🎨 浮動粒子特效 | 6.3.0 | 全新 `.particles` 特效(TimelineView + Canvas) |
| 🎯 多種呈現方式 | 6.2.0 | `.sheet`、`.fullScreenCover`、`.embed` |
| 🌈 自適應文字色 | 6.2.0 | 按鈕文字自動依背景對比 |
| 🛠️ 簡化初始化 | 6.2.0 | 直接傳值 — 無需 `.constant()` 包裝 |
| 🪟 玻璃擬態 | 5.5.0 | 透明度可調的現代模糊效果 |
| 🌈 網格與線性漸層 | 5.3.0 | 動畫漸層背景 |
| 🥽 visionOS 支援 | 4.1.0 | 原生空間運算 |
| 🔄 自動觸發 | 4.0.0 | 版本/建置變更時自動顯示 |
| 🎄 特殊效果 | 3.9.0 | `.christmas` 雪花、`.particles` 彩虹 |
| 📱 Drop 通知 | 3.5.0 | iOS 風格橫幅通知 |
| 🔥 Firebase Realtime DB | 3.0.0 | 即時內容更新 |
| 🌐 遠端 JSON | 3.0.0 | 從任意 REST 端點載入 |
| 📚 版本歷史 | 2.0.0 | 瀏覽所有先前版本 |

### 功能展示

| 網格漸層 (5.3+) | visionOS (4.1+) |
|:--------------------:|:---------------:|
| <img alt="Mesh" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508"> | ![visionOS](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) |

| App 圖示 (3.9.6+) | 歷史 (2.0+) |
|:-----------------:|:--------------:|
| <img height="400" alt="App Icon" src="https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png"> | <img height="400" alt="History" src="https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png"> |

## 📚 深入了解

| 文件 | 涵蓋內容 |
|-------|--------|
| [Configuration](CONFIGURATION.md) | 全部參數、範例、資料來源(本地 / 遠端 / Firebase)、資料模型 |
| [Platform Support & Installation](PLATFORM.md) | 支援的 OS 版本、需求、功能對照表、SPM 設定 |
| [Contributing](CONTRIBUTING.md) | 專案結構、開發環境、PR 規範、疑難排解 |

## 📄 授權

SwiftNEW 採用 **MIT License** — 最寬鬆的開源授權之一。

| | 詳情 |
|---|---------|
| ✅ **可以** | 用於商業 App(包括 App Store 付費 App)、修改、再發佈,並整合到閉源軟體中 |
| 📝 **必須** | 在您的專案中保留原始版權與授權聲明 |
| ⚠️ **無擔保** | 軟體按「現況」提供 — 作者不對使用所造成之任何問題負責 |

完整內容請見 [LICENSE](../LICENSE)。

## 💖 贊助支持

| 贊助商 | 資源 |
|---------|----------|
| <a href="https://m.do.co/c/ce873177d9ab"><img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/SVG/DO_Logo_horizontal_blue.svg" width="160px" alt="Digital Ocean"></a> | 雲端基礎設施 |
| [![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/1998code/SwiftNEWKit) | AI 文件問答 |

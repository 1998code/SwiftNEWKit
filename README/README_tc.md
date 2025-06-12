<img width="150" alt="SNK" src="https://github.com/user-attachments/assets/1121ae03-cf96-455e-8119-596f6f5eb58e" />

# SwiftNEW

![Stable](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=03A791&label=穩定版)
![Beta](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?include_prereleases&color=3A59D1&label=測試版)
[![Validate JSON Files](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml/badge.svg)](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml)
![Swift Version](https://img.shields.io/badge/Swift-5.9/6.1-teal.svg)

![Platforms](https://img.shields.io/badge/Platforms-iOS%2015.0+%20|%20macOS%2014.0+%20|%20tvOS%2017.0+%20|%20visionOS%201.0+-15437D.svg)
![License](https://img.shields.io/badge/License-MIT-C8ECFE.svg)

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

現代化的 SwiftUI 原生「最新功能」展示框架，專為所有 Apple 平台設計。具備美觀動畫、漸變背景、遠端資料載入和全面客製化選項，用於創建引人入勝的版本說明和功能公告。

## 📋 目錄

- [✨ 功能特色](#-功能特色)
- [🎯 快速開始](#-快速開始)
- [🎨 預覽與展示](#-預覽與展示)
- [⚙️ 配置](#️-配置)
- [🔧 資料來源](#-資料來源)
- [🛠️ 平台支援](#️-平台支援)
- [📁 安裝指南](#-安裝指南)
- [🔧 疑難排解](#-疑難排解)
- [📂 專案結構](#-專案結構)
- [🤝 貢獻](#-貢獻)

## 🎨 預覽與展示

![CleanShot 2022-06-11 at 22 54 15@2x](https://user-images.githubusercontent.com/54872601/173192927-ca2a8bef-2114-44f8-8d4d-47baadb8b4a8.png)

### 淺色與深色主題
![IMG_3472](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![IMG_3471](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG)
:---: | :---:
淺色原生 | 深色原生

### 進階功能
![Simulator Screen Shot - iPhone 13 Pro Max](https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png) | ![CleanShot 2022-12-11 at 12 46 30@2x](https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png)
:---: | :---:
歷史檢視 (2.0.0+) | 應用程式圖標支援 (3.9.6+)

### 平台支援
![CleanShot 2023-06-22 at 14 24 07@2x](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) | <img alt="Screenshot 2024-07-01 at 10 18 33 PM" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508">
:---: | :---:
VisionOS 支援 (4.1.0+) | 網格漸變背景 (5.3.0+)

## ✨ 功能特色

| 功能 | 版本 | 描述 |
|---------|---------|-------------|
| 🎨 **玻璃擬態效果** | 5.5.0+ | 現代玻璃模糊效果，具可客製化的透明度 |
| 🌈 **網格與線性漸變** | 5.3.0+ | 美觀的動畫漸變背景 |
| 🥽 **visionOS 與 Vision Pro** | 4.1.0+ | 原生空間運算支援 |
| 🔄 **版本變更自動觸發** | 4.0.0+ | 當應用程式版本或建置版本變更時自動顯示 |
| 📊 **彈性版本號碼** | 4.0.0+ | 支援語意化版本 (x.y.z) 和簡化 (x.y) 格式 |
| 🎄 **特殊效果** | 3.9.0+ | 季節性動畫（聖誕雪花） |
| 📱 **下拉通知** | 3.5.0+ | iOS 風格通知橫幅 |
| 🔥 **Firebase 即時資料庫** | 3.0.0+ | 來自 Firebase 的即時內容更新 |
| 🌐 **遠端 JSON 支援** | 3.0.0+ | 從任何 REST API 端點載入內容 |
| 📚 **版本歷史** | 2.0.0+ | 瀏覽所有先前版本並進行導覽 |

## 示例
路徑: `./Demo` (Xcode 項目)

## 版本
![GitHub release (latest by date)](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=g&label=穩定版&style=for-the-badge)
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=green&include_prereleases&label=測試版&style=for-the-badge)

![swiftui-128x128_2x](https://user-images.githubusercontent.com/54872601/173193069-2eb486b0-1347-4448-ac2b-235b8f2f1bb0.png)

## 測試平台和環境
### 本地
測試平台 | 最新版本 | 兼容版本
-------- | ------ | ----------
iOS      | 18.4   | > 14
iPadOS   | 18.2   | > 14
macOS    | 15.2   | > 11
visionOS | 2      | > 1
### 雲端
測試平台 | 兼容版本
-------- | ----------
Xcode    | > 13.4 (13F17a)
macOS    | > 12.3.1 (21E258)

### 設置
步驟 | 描述 | 截圖
------| ----------- | ----------
1 | 導航到根項目 | <img width="274" alt="CleanShot 2022-06-11 at 17 39 39@2x" src="https://user-images.githubusercontent.com/54872601/173182521-27481cf2-c9bf-4f87-95cc-76f5d1c05094.png">
2 | 選擇項目 | <img width="174" alt="CleanShot 2022-06-11 at 17 39 48@2x" src="https://user-images.githubusercontent.com/54872601/173182523-6a24c67a-8f27-4ef7-a3f4-ea63cfd8436f.png">
3 | 選擇包依賴項 | <img width="309" alt="CleanShot 2022-06-11 at 17 39 53@2x" src="https://user-images.githubusercontent.com/54872601/173182526-e5660b7f-c50c-4173-81f5-83c10c514659.png">
4 | 點擊 + 並貼上 <code>https://github.com/1998code/SwiftNEWKit</code> 到搜索框 | <img width="614" alt="CleanShot 2022-06-11 at 17 39 32@2x" src="https://user-images.githubusercontent.com/54872601/173182527-2a151198-7ac0-4735-8257-11580ada3d5e.png">
5L | 創建一個名為 `data.json` 的新本地文件 | 您可以複製這個 [JSON 示例](https://github.com/1998code/SwiftNEWKit#sample)。
5R | 您也可以使用遠程 JSON / firebase 實時數據庫。 | 示例: https://testground-a937f-default-rtdb.firebaseio.com/0.json?print=pretty

### 主要用法
1. 導入包。
```swift
import SwiftNEW
```

2. 在 `body` 或任何 `some View` 之前添加狀態。
### 狀態
變量        | 建議值                         | 選項                          | 類型
----------- | ------------------------------ | ----------------------------- | ----
showNew *   | false                          | false, true                   | Bool
align       | .center                        | .leading, .center, .trailing  | HorizontalAlignment
color       | .accentColor                   | 支持所有顏色                  | Color
size        | "simple"                       | "invisible", "mini", "simple" | String
labelColor  | UIColor.systemBackground 或 NSColor.windowBackgroundColor | 支持所有顏色               | Color
label       | "顯示發布說明"                  | 所有字符串                    | String
labelImage  | "arrow.up.circle.fill"         | 所有 SF 符號                  | String
history     | true                           | true, false                   | Bool
data        | "data" 或 "https://.../{}.json"| "{本地JSON文件}" 或 遠程      | String
showDrop    | false                          | false, true                   | Bool
mesh        | true                           | false, true                   | Bool

##### 示例:
```swift
// 必需
@State var showNew: Bool = false

// 可選 (5.2.0 或更高版本)
@State var align: HorizontalAlignment = .center
@State var color: Color = .accentColor
@State var size: String = "normal"
#if os(iOS)
@State var labelColor: Color = Color(UIColor.systemBackground)
#elseif os(macOS)
@State var labelColor: Color = Color(NSColor.windowBackgroundColor)
#endif
@State var label: String = "顯示發布說明"
@State var labelImage: String = "arrow.up.circle.fill"
@State var history: Bool = true
@State var data: String = "data"
@State var showDrop: Bool = false
@State var mesh: Bool = false
```

3. 然後，將此代碼粘貼到 `body` 或任何 `some View` 內部。
```swift
// 5.2.0 或更高版本中使用默認選項的簡化版本
SwiftNEW(show: $showNew)

// 5.1.0 或更低版本
SwiftNEW(show: $showNew, align: $align, color: $color, size: $size, labelColor: $labelColor, label: $label, labelImage: $labelImage, history: $history, data: $data, showDrop: $showDrop)
```
除了使用單獨的狀態外，內聯狀態也可以工作。(5.2.0 後不再需要)

*`Show Bool` 不能內聯。
```swift
SwiftNEW(show: $showNew, align: .constant(.center), color: .constant(.accentColor), size: .constant("normal"), labelColor: .constant(Color(UIColor.systemBackground)), label: .constant("顯示發布說明"), labelImage: .constant("arrow.up.circle.fill"), history: .constant(true), data: .constant("data"), showDrop: .constant(false))
```

4. 您的代碼應類似於以下內容，包含最小功能和默認樣式。
```swift
struct ContentView: View {
    @State var showNew: Bool = false
    var body: some View {
        SwiftNEW(show: $showNew)
    }
}
```

### JSON
#### 結構 / 模型 (參考)
* 以下代碼僅供參考。您不需要複製結構或模型。
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
將 JSON 示例複製到 `data.json` 文件中（如果您沒有該文件，請創建一個新文件。）

![68747470733a2f2f76616c696461746f722e737761676765722e696f2f76616c696461746f723f75726c3d68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f4f41492f4f70656e4150492d53706563696669636174696f6e2f6d61737465722f6578616d706c65732f76](https://user-images.githubusercontent.com/54872601/173190828-8ee763b9-4e33-4231-92ac-eb81b556c462.png)
```json
[
  {
    "version": "1.2",
    "new": [
      {
        "body": "適用於 iOS 16, iPadOS 16, macOS 13",
        "icon": "hammer.fill",
        "subtitle": "修復UI問題",
        "title": "錯誤修復"
      },
      {
        "body": "通過遠程存儲直接加載。很簡單！",
        "icon": "square.and.arrow.down.fill",
        "subtitle": "已支持",
        "title": "Firebase 遠程"
      },
      {
        "body": "免費開源！由 Ming 用 ❤️‍🔥 創建",
        "icon": "macpro.gen3.server",
        "subtitle": "設計",
        "title": "無服務器"
      },
      {
        "body": "提交拉取請求，讓它對每個人都更好！",
        "icon": "arrow.triangle.pull",
        "subtitle": "一起",
        "title": "貢獻"
      }
    ]
  },
  {
   "version": "1.1",
    "new": [
      {
        "body": "適用於 iOS 16, iPadOS 16, macOS 13",
        "icon": "hammer.fill",
        "subtitle": "修復UI問題",
        "title": "錯誤修復"
      },
      {
        "body": "通過本地存儲直接加載。超快速！",
        "icon": "square.and.arrow.down.fill",
        "subtitle": "已支持",
        "title": "本地文件"
      },
      {
        "body": "免費開源！由 Ming 用 ❤️‍🔥 創建",
        "icon": "macpro.gen3.server",
        "subtitle": "設計",
        "title": "無服務器"
      },
      {
        "body": "提交拉取請求，讓它對每個人都更好！",
        "icon": "arrow.triangle.pull",
        "subtitle": "一起",
        "title": "貢獻"
      }
    ]
  }
]
```

## 📂 專案結構

```
Sources/SwiftNEW/
├── SwiftNEW.swift                          # 主要結構體與初始化
├── Model.swift                             # 資料模型 (Vmodel, Model)
├── Bundle+Ext.swift                        # Bundle 擴展
├── Localizable.xcstrings                   # 本地化支援
├── 📁 Views/
│   ├── SwiftNEW+View.swift                # 主要 body 視圖實現
│   ├── 📁 Sheets/
│   │   ├── CurrentVersionSheet.swift       # 當前版本顯示
│   │   └── HistorySheet.swift             # 版本歷史顯示
│   └── 📁 Components/
│       ├── HeaderView.swift               # 標題組件
│       └── ButtonComponents.swift         # 按鈕組件
├── 📁 Extensions/
│   └── SwiftNEW+Functions.swift           # 實用函數
├── 📁 Styles/
│   ├── AppIconView.swift                  # 應用程式圖示顯示
│   ├── MeshView.swift                     # 漸層背景
│   └── NoiseView.swift                    # 噪點效果
└── 📁 Animations/
    └── SnowfallView.swift                 # 特殊效果（聖誕節）
```

### 架構概述

SwiftNEW 採用模組化架構建構，分離關注點以提升可維護性：

- **主要結構體** (`SwiftNEW.swift`): 公開 API 與設定選項
- **視圖層級** (`Views/`): UI 組件的邏輯分組
- **資料模型** (`Model.swift`): JSON 資料結構
- **擴展** (`Extensions/`): 實用函數與輔助功能
- **樣式** (`Styles/`): 可重用的視覺組件
- **動畫** (`Animations/`): 特殊效果與動畫

## 貢獻

歡迎對 SwiftNEW 做出貢獻！

- 要報告錯誤或請求功能，請在 GitHub 上提出問題
- 提交拉取請求時，請遵循項目的編碼風格

## 許可證

MIT。 詳情請閱讀 LICENSE 文件。

## 翻譯

本文檔還有其他語言版本:

[English](../README.md) | [简中](README_zh.md) / 繁中 / [粵語](README_hc.md) | [日本語](README_ja.md) | [한국어](README_ko.md)

請隨時提交拉取請求，添加新語言或修復任何錯別字/錯誤。

## 支持
<a href="https://m.do.co/c/ce873177d9ab">
    <img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/SVG/DO_Logo_horizontal_blue.svg" width="201px" alt="Digital Ocean 標誌">
</a>
<img width="150" alt="SNK" src="https://github.com/user-attachments/assets/1121ae03-cf96-455e-8119-596f6f5eb58e" />

# SwiftNEW

![Stable](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=03A791&label=穩定版)
![Beta](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?include_prereleases&color=3A59D1&label=測試版)
[![Validate JSON Files](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml/badge.svg)](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml)
![Swift Version](https://img.shields.io/badge/Swift-5.9/6.1-teal.svg)

![Platforms](https://img.shields.io/badge/Platforms-iOS%2015.0+%20|%20macOS%2014.0+%20|%20tvOS%2017.0+%20|%20visionOS%201.0+-15437D.svg)
![License](https://img.shields.io/badge/License-MIT-C8ECFE.svg)

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

iOS、macOS、tvOS、visionOS 應用程式用嘅現代化 SwiftUI 原生「新功能」展示框架。採用模塊化架構構建，方便自定義同維護。

## 📋 目錄
- [🎨 預覽同展示](#-預覽同展示)
- [✨ 功能](#-功能)
- [🚀 快速開始](#-快速開始)
- [📖 示例](#-示例)
- [📦 版本](#-版本)
- [🔧 測試平台同環境](#-測試平台同環境)
- [⚙️ 設置](#️-設置)
- [💻 主要用法](#-主要用法)
- [📄 JSON](#-json)
- [🏗️ 項目結構](#️-項目結構)
- [🔍 故障排除](#-故障排除)
- [🤝 貢獻](#-貢獻)
- [📜 許可證](#-許可證)
- [🌐 翻譯](#-翻譯)
- [💖 支持](#-支持)

## 🎨 預覽同展示
![CleanShot 2022-06-11 at 22 54 15@2x](https://user-images.githubusercontent.com/54872601/173192927-ca2a8bef-2114-44f8-8d4d-47baadb8b4a8.png)

## 展示
![IMG_3472](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![IMG_3471](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG)
------------- | ------------
淺色主題 | 深色主題

![Simulator Screen Shot - iPhone 13 Pro Max](https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png) | ![CleanShot 2022-12-11 at 12 46 30@2x](https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png) ![CleanShot 2022-12-11 at 12 49 12@2x](https://user-images.githubusercontent.com/54872601/206887046-8ec82853-4e32-4a07-8b64-4cc984e7ec90.png)
------------- | ------------
歷史視圖 (2.0.0) | 應用圖標 (3.9.6) [垂直 / 水平]

![CleanShot 2023-06-22 at 14 24 07@2x](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) | <img alt="Screenshot 2024-07-01 at 10 18 33 PM" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508"> |
------------- | ------------
支援 VisionOS (4.1.0 或更高版本) | 網格漸變背景 (5.3.0 或更高版本)

## 🚀 快速開始

### 安装
1. 喺 Xcode 中，選擇 **File → Add Package Dependencies**
2. 输入 `https://github.com/1998code/SwiftNEWKit`
3. 選擇最新版本並添加到你嘅項目

### 基本用法
```swift
import SwiftNEW

struct ContentView: View {
    @State var showNew: Bool = false
    
    var body: some View {
        SwiftNEW(show: $showNew)
    }
}
```

### 創建數據文件
創建一個 `data.json` 文件：
```json
[
  {
    "version": "1.0",
    "new": [
      {
        "title": "歡迎",
        "subtitle": "開始使用",
        "body": "感謝使用 SwiftNEW！",
        "icon": "star.fill"
      }
    ]
  }
]
```

### 遠程數據源
你都可以使用遠程 JSON 或 Firebase 實時數據庫：
```swift
SwiftNEW(show: $showNew, data: "https://your-api.com/data.json")
```

## 📖 示例
路徑: `./Demo` (Xcode 項目)

## 📦 版本
![GitHub release (latest by date)](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=g&label=穩定版&style=for-the-badge)
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=green&include_prereleases&label=測試版&style=for-the-badge)

![swiftui-128x128_2x](https://user-images.githubusercontent.com/54872601/173193069-2eb486b0-1347-4448-ac2b-235b8f2f1bb0.png)

## 🔧 測試平台同環境
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

### ⚙️ 設置
步驟 | 描述 | 截圖
------| ----------- | ----------
1 | 導航到根項目 | <img width="274" alt="CleanShot 2022-06-11 at 17 39 39@2x" src="https://user-images.githubusercontent.com/54872601/173182521-27481cf2-c9bf-4f87-95cc-76f5d1c05094.png">
2 | 選擇項目 | <img width="174" alt="CleanShot 2022-06-11 at 17 39 48@2x" src="https://user-images.githubusercontent.com/54872601/173182523-6a24c67a-8f27-4ef7-a3f4-ea63cfd8436f.png">
3 | 選擇包依賴項 | <img width="309" alt="CleanShot 2022-06-11 at 17 39 53@2x" src="https://user-images.githubusercontent.com/54872601/173182526-e5660b7f-c50c-4173-81f5-83c10c514659.png">
4 | 點擊 + 同貼上 <code>https://github.com/1998code/SwiftNEWKit</code> 到搜索框 | <img width="614" alt="CleanShot 2022-06-11 at 17 39 32@2x" src="https://user-images.githubusercontent.com/54872601/173182527-2a151198-7ac0-4735-8257-11580ada3d5e.png">
5L | 創建一個名為 `data.json` 嘅新本地文件 | 你可以複製呢個 [JSON 示例](https://github.com/1998code/SwiftNEWKit#sample)。
5R | 你都可以使用遠程 JSON / firebase 實時數據庫。 | 示例: https://testground-a937f-default-rtdb.firebaseio.com/0.json?print=pretty

### 💻 主要用法
1. 導入包。
```swift
import SwiftNEW
```

2. 喺 `body` 或任何 `some View` 之前添加狀態。
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
// 5.2.0 或更高版本中使用默認選項嘅簡化版本
SwiftNEW(show: $showNew)

// 5.1.0 或更低版本
SwiftNEW(show: $showNew, align: $align, color: $color, size: $size, labelColor: $labelColor, label: $label, labelImage: $labelImage, history: $history, data: $data, showDrop: $showDrop)
```
除咗使用單獨嘅狀態外，內聯狀態都可以工作。(5.2.0 後唔再需要)

*`Show Bool` 唔可以內聯。
```swift
SwiftNEW(show: $showNew, align: .constant(.center), color: .constant(.accentColor), size: .constant("normal"), labelColor: .constant(Color(UIColor.systemBackground)), label: .constant("顯示發布說明"), labelImage: .constant("arrow.up.circle.fill"), history: .constant(true), data: .constant("data"), showDrop: .constant(false))
```

4. 你嘅代碼應該類似於以下內容，包含最小功能同默認樣式。
```swift
struct ContentView: View {
    @State var showNew: Bool = false
    var body: some View {
        SwiftNEW(show: $showNew)
    }
}
```

### 📄 JSON
#### 結構 / 模型 (參考)
* 以下代碼僅供參考。你唔需要複製結構或模型。
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
將 JSON 示例複製到 `data.json` 文件中（如果你冇該文件，請創建一個新文件。）

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
        "body": "通過遠程存儲直接加載。好簡單！",
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
        "body": "提交拉取請求，令佢對每個人都更好！",
        "icon": "arrow.triangle.pull",
        "subtitle": "一齊",
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
        "body": "提交拉取請求，令佢對每個人都更好！",
        "icon": "arrow.triangle.pull",
        "subtitle": "一齊",
        "title": "貢獻"
      }
    ]
  }
]
```

## ✨ 功能
| 描述                                               | 版本      |
|---------------------------------------------------|-----------|
| 網格漸變同線性漸變背景                                | 5.3.0     |
| Apple visionOS 同 Vision Pro 支援                  | 4.1.0     |
| 版本/構建變更時自動觸發/彈出 .sheet                   | 4.0.0     |
| 版本號格式 x.y.z 同/或 x.y                         | 4.0.0     |
| 遠程下拉通知                                        | 3.5.0     |
| Firebase 實時數據庫                                | 3.0.0     |
| 遠程 JSON 文件                                     | 3.0.0     |
| 版本控制 + 睇歷史                                   | 2.0.0     |
| 支持所有用例（包括商業/非營利）                        | -         |
| 簡單模型，易於修改同重用                              | -         |
| 簡單綁定同數據傳遞                                   | -         |
| 從本地存儲即時加載                                   | -         |

## 🏗️ 項目結構
```
Sources/SwiftNEW/
├── SwiftNEW.swift              # 主要結構同配置
├── Model.swift                 # 數據模型
├── Bundle+Ext.swift           # Bundle 擴展
├── Views/
│   ├── SwiftNEW+View.swift    # 主視圖實現
│   ├── Components/
│   │   ├── HeaderView.swift   # 標題組件
│   │   └── ButtonComponents.swift # 按鈕組件
│   └── Sheets/
│       ├── CurrentVersionSheet.swift # 當前版本表單
│       └── HistorySheet.swift       # 歷史記錄表單
├── Extensions/
│   └── SwiftNEW+Functions.swift # 實用函數
├── Styles/
│   ├── AppIconView.swift      # 應用圖標樣式
│   ├── MeshView.swift         # 網格背景
│   └── NoiseView.swift        # 噪音效果
└── Animations/
    └── SnowfallView.swift     # 雪花動畫
```

## 🔍 故障排除

### 常見問題

**Q: 點解組件冇顯示？**
A: 檢查以下項目：
- 確保 `data.json` 文件存在並且格式正確
- 檢查 JSON 文件係咪添加到 Bundle 資源中
- 驗證版本號格式 (x.y.z 或 x.y)

**Q: 遠程數據加載失敗？**
A: 確保：
- URL 可以訪問並返回有效嘅 JSON
- 網絡連接正常
- JSON 格式符合預期嘅結構

**Q: 動畫性能問題？**
A: 嘗試：
- 關閉網格背景 (`mesh: false`)
- 減少動畫複雜度
- 檢查設備性能限制

**Q: 本地化問題？**
A: 確保：
- 本地化文件正確配置
- Bundle 資源正確添加
- 支持目標語言

### 支持嘅平台版本
- iOS 14.0+
- iPadOS 14.0+
- macOS 11.0+
- visionOS 1.0+

## 🤝 貢獻

歡迎對 SwiftNEW 做出貢獻！

- 要報告錯誤或請求功能，請喺 GitHub 上提出問題
- 提交拉取請求時，請遵循項目嘅編碼風格

## 📜 許可證

MIT。 詳情請閱讀 LICENSE 文件。

## 🌐 翻譯

呢個文檔仲有其他語言版本:

[English](../README.md) | [简中](README_zh.md) / [繁中](README_tc.md) / 粵語 | [日本語](README_ja.md) | [한국어](README_ko.md)

請隨時提交拉取請求，添加新語言或修復任何錯別字/錯誤。

## 💖 支持
<a href="https://m.do.co/c/ce873177d9ab">
    <img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/SVG/DO_Logo_horizontal_blue.svg" width="201px" alt="Digital Ocean 標誌">
</a>
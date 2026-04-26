<img width="150" alt="SNK" src="https://github.com/user-attachments/assets/1121ae03-cf96-455e-8119-596f6f5eb58e" />

# SwiftNEW

![Stable](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=03A791&label=Stable)
![Beta](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?include_prereleases&color=3A59D1&label=Beta)
[![Validate JSON Files](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml/badge.svg)](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml)
![Swift Version](https://img.shields.io/badge/Swift-5.9/6.1-teal.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2015.0+%20|%20macOS%2014.0+%20|%20tvOS%2017.0+%20|%20visionOS%201.0+-15437D.svg)
![License](https://img.shields.io/badge/License-MIT-C8ECFE.svg)

[English](../README.md) · [繁中](README_tc.md) · [简中](README_zh.md) · [粵語](README_hc.md) · **日本語** · [한국어](README_ko.md)

すべての Apple プラットフォーム向け、SwiftUI ネイティブのモダンな **「最新情報」** プレゼンテーションフレームワーク — アニメーショングラデーション背景、グラスエフェクト、リモートデータ読み込み、RTL とローカライゼーションを標準サポート。

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

## 🎨 ギャラリー

| ライト | ダーク |
|:-----:|:----:|
| ![Light](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![Dark](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG) |

## 🚀 クイックスタート

**1. パッケージを追加**:Xcode → *File → Add Package Dependencies…*

> [!IMPORTANT]
> **パッケージ URL**
>
> ```
> https://github.com/1998code/SwiftNEWKit
> ```

**2. `data.json`** を App Bundle に追加:

> [!TIP]
> リリースノート JSON のサンプル
>
> ```json
> [
>   {
>     "version": "1.0",
>     "new": [
>       { "icon": "star.fill", "title": "ようこそ", "subtitle": "はじめに", "body": "ダウンロードありがとうございます!" }
>     ]
>   }
> ]
> ```

**3. View に組み込む:**

> [!NOTE]
> 最小構成の SwiftUI 統合
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

これだけ — App のバージョンが変わると、SwiftNEW が自動的に表示されます。

## ✨ 機能

| 機能 | 追加バージョン | 説明 |
|---------|:-----:|-------------|
| 🔍 シート内検索 | 6.3.0 | タイトル / サブタイトル / 本文で現在のリリースノートを絞り込み |
| 🏷️ カスタマイズ可能なヘッダー | 6.3.0 | `headingStyle`:`.version`、`.versionOnly`、`.appName` |
| 🎯 アイコンスタイル | 6.3.0 | `iconStyle`:`.filled`(色付き背景)または `.plain`(グリフのみ) |
| 🔢 ビルド番号オプション | 6.3.0 | `showBuild: false` でビルド番号を非表示 |
| 🎨 フローティングパーティクル | 6.3.0 | 新しい `.particles` 特殊エフェクト(TimelineView + Canvas) |
| 🎯 柔軟な表示形式 | 6.2.0 | `.sheet`、`.fullScreenCover`、`.embed` |
| 🌈 適応型テキストカラー | 6.2.0 | ボタンテキストが背景に応じてコントラスト調整 |
| 🛠️ シンプルなイニシャライザ | 6.2.0 | 値を直接指定 — `.constant()` ラップ不要 |
| 🪟 グラスモーフィズム | 5.5.0 | 透明度を調整できるモダンなブラー |
| 🌈 メッシュ & 線形グラデーション | 5.3.0 | アニメーション付きグラデーション背景 |
| 🥽 visionOS 対応 | 4.1.0 | ネイティブ空間コンピューティング |
| 🔄 自動トリガー | 4.0.0 | バージョン / ビルド変更時に自動表示 |
| 🎄 特殊エフェクト | 3.9.0 | `.christmas` 降雪、`.particles` レインボー |
| 📱 Drop 通知 | 3.5.0 | iOS スタイルのバナー通知 |
| 🔥 Firebase Realtime DB | 3.0.0 | リアルタイムなコンテンツ更新 |
| 🌐 リモート JSON | 3.0.0 | 任意の REST エンドポイントから読み込み |
| 📚 バージョン履歴 | 2.0.0 | 過去のすべてのリリースを閲覧 |

### 機能ショーケース

| メッシュグラデーション (5.3+) | visionOS (4.1+) |
|:--------------------:|:---------------:|
| <img alt="Mesh" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508"> | ![visionOS](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) |

| App アイコン (3.9.6+) | 履歴 (2.0+) |
|:-----------------:|:--------------:|
| <img height="400" alt="App Icon" src="https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png"> | <img height="400" alt="History" src="https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png"> |

## 📚 詳細情報

| ガイド | 内容 |
|-------|--------|
| [Configuration](CONFIGURATION.md) | すべてのパラメータ、例、データソース(ローカル / リモート / Firebase)、データモデル |
| [Platform Support & Installation](PLATFORM.md) | 対応 OS バージョン、要件、機能対応表、SPM セットアップ |
| [Contributing](CONTRIBUTING.md) | プロジェクト構成、開発環境、PR ガイドライン、トラブルシューティング |

## 📄 ライセンス

SwiftNEW は **MIT License** で公開されています — 最も寛容なオープンソースライセンスのひとつ。

| | 詳細 |
|---|---------|
| ✅ **できること** | 商用アプリ(App Store 有料アプリ含む)での利用、改変、再配布、クローズドソース製品への組み込み |
| 📝 **必要なこと** | 元の著作権表示とライセンス表示をプロジェクトに残すこと |
| ⚠️ **無保証** | ソフトウェアは「現状のまま」提供されます — 利用に伴う問題について作者は責任を負いません |

全文は [LICENSE](../LICENSE) を参照してください。

## 💖 スポンサー

| スポンサー | リソース |
|---------|----------|
| <a href="https://m.do.co/c/ce873177d9ab"><img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/SVG/DO_Logo_horizontal_blue.svg" width="160px" alt="Digital Ocean"></a> | クラウドインフラ |
| [![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/1998code/SwiftNEWKit) | AI ドキュメント Q&A |

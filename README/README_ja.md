# SwiftNEW

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

## 機能
| 説明                                               | バージョン |
|---------------------------------------------------|-----------|
| メッシュグラデーションと線形グラデーションの背景         | 5.3.0     |
| Apple visionOS と Vision Pro サポート               | 4.1.0     |
| バージョン/ビルド変更時に自動的にトリガー/ポップアップする .sheet | 4.0.0     |
| バージョン番号形式 x.y.z および/または x.y            | 4.0.0     |
| リモートドロップ通知                                 | 3.5.0     |
| Firebase リアルタイムデータベース                     | 3.0.0     |
| リモート JSON ファイル                               | 3.0.0     |
| バージョン管理 + 履歴表示                           | 2.0.0     |
| 商業/非営利を含むすべてのユースケースをサポート        | -         |
| シンプルなモデル、簡単に変更や再利用が可能           | -         |
| シンプルなバインディングとデータの受け渡し            | -         |
| ローカルストレージからの即時読み込み                 | -         |

## プレビュー
![CleanShot 2022-06-11 at 22 54 15@2x](https://user-images.githubusercontent.com/54872601/173192927-ca2a8bef-2114-44f8-8d4d-47baadb8b4a8.png)

## ギャラリー
![IMG_3472](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![IMG_3471](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG)
------------- | ------------
ライトモード | ダークモード

![Simulator Screen Shot - iPhone 13 Pro Max](https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png) | ![CleanShot 2022-12-11 at 12 46 30@2x](https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png) ![CleanShot 2022-12-11 at 12 49 12@2x](https://user-images.githubusercontent.com/54872601/206887046-8ec82853-4e32-4a07-8b64-4cc984e7ec90.png)
------------- | ------------
履歴ビュー (2.0.0) | アプリアイコン (3.9.6) [垂直 / 水平]

![CleanShot 2023-06-22 at 14 24 07@2x](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) | <img alt="Screenshot 2024-07-01 at 10 18 33 PM" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508"> |
------------- | ------------
VisionOS サポート (4.1.0 以上) | メッシュグラデーション背景 (5.3.0 以上)

## サンプル
パス: `./Demo` (Xcode プロジェクト)

## バージョン
![GitHub release (latest by date)](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=g&label=安定版&style=for-the-badge)
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=green&include_prereleases&label=ベータ版&style=for-the-badge)

![swiftui-128x128_2x](https://user-images.githubusercontent.com/54872601/173193069-2eb486b0-1347-4448-ac2b-235b8f2f1bb0.png)

## テスト済みプラットフォームと環境
### ローカル
テスト済み | 最新バージョン | 互換性あり
--------- | ------------ | ----------
iOS       | 18.4         | > 14
iPadOS    | 18.2         | > 14
macOS     | 15.2         | > 11
visionOS  | 2            | > 1
### クラウド
テスト済み | 互換性あり
--------- | ----------
Xcode     | > 13.4 (13F17a)
macOS     | > 12.3.1 (21E258)

### セットアップ
ステップ | 説明 | スクリーンショット
------| ----------- | ----------
1 | ルートプロジェクトに移動 | <img width="274" alt="CleanShot 2022-06-11 at 17 39 39@2x" src="https://user-images.githubusercontent.com/54872601/173182521-27481cf2-c9bf-4f87-95cc-76f5d1c05094.png">
2 | プロジェクトを選択 | <img width="174" alt="CleanShot 2022-06-11 at 17 39 48@2x" src="https://user-images.githubusercontent.com/54872601/173182523-6a24c67a-8f27-4ef7-a3f4-ea63cfd8436f.png">
3 | パッケージ依存関係を選択 | <img width="309" alt="CleanShot 2022-06-11 at 17 39 53@2x" src="https://user-images.githubusercontent.com/54872601/173182526-e5660b7f-c50c-4173-81f5-83c10c514659.png">
4 | + をクリックし、検索ボックスに <code>https://github.com/1998code/SwiftNEWKit</code> を貼り付け | <img width="614" alt="CleanShot 2022-06-11 at 17 39 32@2x" src="https://user-images.githubusercontent.com/54872601/173182527-2a151198-7ac0-4735-8257-11580ada3d5e.png">
5L | `data.json` という名前の新しいローカルファイルを作成 | この [JSON サンプル](https://github.com/1998code/SwiftNEWKit#sample) をコピーできます。
5R | リモート JSON / Firebase リアルタイムデータベースも使用できます。 | サンプル: https://testground-a937f-default-rtdb.firebaseio.com/0.json?print=pretty

### 主な使用方法
1. パッケージをインポートします。
```swift
import SwiftNEW
```

2. `body` または任意の `some View` の前に状態を追加します。
### 状態
変数        | 推奨値                         | オプション                      | 型
----------- | ------------------------------ | ----------------------------- | ----
showNew *   | false                          | false, true                   | Bool
align       | .center                        | .leading, .center, .trailing  | HorizontalAlignment
color       | .accentColor                   | すべての色をサポート            | Color
size        | "simple"                       | "invisible", "mini", "simple" | String
labelColor  | UIColor.systemBackground または NSColor.windowBackgroundColor | すべての色をサポート | Color
label       | "リリースノートを表示"          | すべての文字列                  | String
labelImage  | "arrow.up.circle.fill"         | すべての SF シンボル            | String
history     | true                           | true, false                   | Bool
data        | "data" または "https://.../{}.json"| "{ローカルJSONファイル}" または リモート | String
showDrop    | false                          | false, true                   | Bool
mesh        | true                           | false, true                   | Bool

##### サンプル:
```swift
// 必須
@State var showNew: Bool = false

// オプション (5.2.0 以上)
@State var align: HorizontalAlignment = .center
@State var color: Color = .accentColor
@State var size: String = "normal"
#if os(iOS)
@State var labelColor: Color = Color(UIColor.systemBackground)
#elseif os(macOS)
@State var labelColor: Color = Color(NSColor.windowBackgroundColor)
#endif
@State var label: String = "リリースノートを表示"
@State var labelImage: String = "arrow.up.circle.fill"
@State var history: Bool = true
@State var data: String = "data"
@State var showDrop: Bool = false
@State var mesh: Bool = false
```

3. 次に、このコードを `body` または任意の `some View` 内に貼り付けます。
```swift
// 5.2.0 以上でデフォルトオプションを使用した簡略版
SwiftNEW(show: $showNew)

// 5.1.0 以下
SwiftNEW(show: $showNew, align: $align, color: $color, size: $size, labelColor: $labelColor, label: $label, labelImage: $labelImage, history: $history, data: $data, showDrop: $showDrop)
```
個別の状態を使用する代わりに、インライン状態も機能します。(5.2.0 以降は不要)

*`Show Bool` はインラインにできません。
```swift
SwiftNEW(show: $showNew, align: .constant(.center), color: .constant(.accentColor), size: .constant("normal"), labelColor: .constant(Color(UIColor.systemBackground)), label: .constant("リリースノートを表示"), labelImage: .constant("arrow.up.circle.fill"), history: .constant(true), data: .constant("data"), showDrop: .constant(false))
```

4. コードは以下のようになり、最小限の機能とデフォルトスタイルが含まれています。
```swift
struct ContentView: View {
    @State var showNew: Bool = false
    var body: some View {
        SwiftNEW(show: $showNew)
    }
}
```

### JSON
#### 構造 / モデル (参照)
* 以下のコードは参考用です。構造体やモデルをコピーする必要はありません。
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

#### サンプル
JSON サンプルを `data.json` ファイルにコピーします（ファイルがない場合は、新しいファイルを作成してください）。

![68747470733a2f2f76616c696461746f722e737761676765722e696f2f76616c696461746f723f75726c3d68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f4f41492f4f70656e4150492d53706563696669636174696f6e2f6d61737465722f6578616d706c65732f76](https://user-images.githubusercontent.com/54872601/173190828-8ee763b9-4e33-4231-92ac-eb81b556c462.png)
```json
[
  {
    "version": "1.2",
    "new": [
      {
        "body": "iOS 16、iPadOS 16、macOS 13 に対応",
        "icon": "hammer.fill",
        "subtitle": "UI の問題を修正",
        "title": "バグ修正"
      },
      {
        "body": "リモートストレージから直接読み込み。簡単です！",
        "icon": "square.and.arrow.down.fill",
        "subtitle": "サポート済み",
        "title": "Firebase リモート"
      },
      {
        "body": "無料でオープンソース！Ming が ❤️‍🔥 で作成",
        "icon": "macpro.gen3.server",
        "subtitle": "デザイン",
        "title": "サーバーレス"
      },
      {
        "body": "プルリクエストを送信して、みんなのためにもっと良くしよう！",
        "icon": "arrow.triangle.pull",
        "subtitle": "一緒に",
        "title": "貢献"
      }
    ]
  },
  {
   "version": "1.1",
    "new": [
      {
        "body": "iOS 16、iPadOS 16、macOS 13 に対応",
        "icon": "hammer.fill",
        "subtitle": "UI の問題を修正",
        "title": "バグ修正"
      },
      {
        "body": "ローカルストレージから直接読み込み。超高速！",
        "icon": "square.and.arrow.down.fill",
        "subtitle": "サポート済み",
        "title": "ローカルファイル"
      },
      {
        "body": "無料でオープンソース！Ming が ❤️‍🔥 で作成",
        "icon": "macpro.gen3.server",
        "subtitle": "デザイン",
        "title": "サーバーレス"
      },
      {
        "body": "プルリクエストを送信して、みんなのためにもっと良くしよう！",
        "icon": "arrow.triangle.pull",
        "subtitle": "一緒に",
        "title": "貢献"
      }
    ]
  }
]
```

## 貢献

SwiftNEW への貢献を歓迎します！

- バグの報告や機能のリクエストは、GitHub で Issue を作成してください
- プルリクエストを提出する際は、プロジェクトのコーディングスタイルに従ってください

## ライセンス

MIT。詳細については LICENSE ファイルをお読みください。

## 翻訳

このドキュメントは他の言語でもご利用いただけます:

[English](../README.md) | [简中](README_zh.md) / [繁中](README_tc.md) / [粵語](README_hc.md) | 日本語 | [한국어](README_ko.md)

新しい言語の追加や誤字・間違いの修正など、プルリクエストをお気軽にお送りください。

## サポート
<a href="https://m.do.co/c/ce873177d9ab">
    <img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/SVG/DO_Logo_horizontal_blue.svg" width="201px" alt="Digital Ocean ロゴ">
</a>
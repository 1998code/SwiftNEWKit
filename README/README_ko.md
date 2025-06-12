<img width="150" alt="SNK" src="https://github.com/user-attachments/assets/1121ae03-cf96-455e-8119-596f6f5eb58e" />

# SwiftNEW

![Stable](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=03A791&label=안정판)
![Beta](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?include_prereleases&color=3A59D1&label=베타판)
[![Validate JSON Files](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml/badge.svg)](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml)
![Swift Version](https://img.shields.io/badge/Swift-5.9/6.1-teal.svg)

![Platforms](https://img.shields.io/badge/Platforms-iOS%2015.0+%20|%20macOS%2014.0+%20|%20tvOS%2017.0+%20|%20visionOS%201.0+-15437D.svg)
![License](https://img.shields.io/badge/License-MIT-C8ECFE.svg)

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

모든 Apple 플랫폼을 위해 설계된 모던한 SwiftUI 네이티브 "새로운 기능" 프레젠테이션 프레임워크입니다. 아름다운 애니메이션, 그라디언트 배경, 원격 데이터 로딩 및 포괄적인 커스터마이제이션 옵션을 제공하여 매력적인 릴리즈 노트와 기능 발표를 만들 수 있습니다.

## 📋 목차

- [✨ 기능](#-기능)
- [🎯 빠른 시작](#-빠른-시작)
- [🎨 미리보기 및 갤러리](#-미리보기-및-갤러리)
- [⚙️ 설정](#️-설정)
- [🔧 데이터 소스](#-데이터-소스)
- [🛠️ 플랫폼 지원](#️-플랫폼-지원)
- [📁 설치 가이드](#-설치-가이드)
- [🔧 문제 해결](#-문제-해결)
- [📂 프로젝트 구조](#-프로젝트-구조)
- [🤝 기여](#-기여)

## 🎨 미리보기 및 갤러리

![CleanShot 2022-06-11 at 22 54 15@2x](https://user-images.githubusercontent.com/54872601/173192927-ca2a8bef-2114-44f8-8d4d-47baadb8b4a8.png)

### 라이트 및 다크 모드
![IMG_3472](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![IMG_3471](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG)
:---: | :---:
라이트 네이티브 | 다크 네이티브

### 고급 기능
![Simulator Screen Shot - iPhone 13 Pro Max](https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png) | ![CleanShot 2022-12-11 at 12 46 30@2x](https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png)
:---: | :---:
히스토리 뷰 (2.0.0+) | 앱 아이콘 지원 (3.9.6+)

### 플랫폼 지원
![CleanShot 2023-06-22 at 14 24 07@2x](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) | <img alt="Screenshot 2024-07-01 at 10 18 33 PM" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508">
:---: | :---:
VisionOS 지원 (4.1.0+) | 메시 그라디언트 배경 (5.3.0+)

## ✨ 기능

| 기능 | 버전 | 설명 |
|---------|---------|-------------|
| 🎨 **글래스모피즘 효과** | 5.5.0+ | 커스터마이즈 가능한 투명도를 가진 모던한 글래스 블러 효과 |
| 🌈 **메시 및 리니어 그라디언트** | 5.3.0+ | 아름다운 애니메이션 그라디언트 배경 |
| 🥽 **visionOS 및 Vision Pro** | 4.1.0+ | 네이티브 공간 컴퓨팅 지원 |
| 🔄 **버전 변경 시 자동 트리거** | 4.0.0+ | 앱 버전이나 빌드 버전이 변경될 때 자동으로 표시 |
| 📊 **유연한 버전 번호** | 4.0.0+ | 시맨틱 버저닝 (x.y.z) 및 간소화된 (x.y) 형식 지원 |
| 🎄 **특수 효과** | 3.9.0+ | 계절별 애니메이션 (크리스마스 눈송이) |
| 📱 **드롭 알림** | 3.5.0+ | iOS 스타일 알림 배너 |
| 🔥 **Firebase 실시간 데이터베이스** | 3.0.0+ | Firebase로부터의 실시간 콘텐츠 업데이트 |
| 🌐 **원격 JSON 지원** | 3.0.0+ | 모든 REST API 엔드포인트에서 콘텐츠 로드 |
| 📚 **버전 히스토리** | 2.0.0+ | 모든 이전 릴리즈를 탐색하고 네비게이션 |

## 예제
경로: `./Demo` (Xcode 프로젝트)

## 버전
![GitHub release (latest by date)](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=g&label=안정&style=for-the-badge)
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=green&include_prereleases&label=베타&style=for-the-badge)

![swiftui-128x128_2x](https://user-images.githubusercontent.com/54872601/173193069-2eb486b0-1347-4448-ac2b-235b8f2f1bb0.png)

## 테스트된 플랫폼 및 환경
### 로컬
테스트됨 | 최신 버전 | 호환 가능
--------- | ------ | ----------
iOS       | 18.4   | > 14
iPadOS    | 18.2   | > 14
macOS     | 15.2   | > 11
visionOS  | 2      | > 1
### 클라우드
테스트됨 | 호환 가능
--------- | ----------
Xcode     | > 13.4 (13F17a)
macOS     | > 12.3.1 (21E258)

### 설정
단계 | 설명 | 스크린샷
------| ----------- | ----------
1 | 루트 프로젝트로 이동 | <img width="274" alt="CleanShot 2022-06-11 at 17 39 39@2x" src="https://user-images.githubusercontent.com/54872601/173182521-27481cf2-c9bf-4f87-95cc-76f5d1c05094.png">
2 | 프로젝트 선택 | <img width="174" alt="CleanShot 2022-06-11 at 17 39 48@2x" src="https://user-images.githubusercontent.com/54872601/173182523-6a24c67a-8f27-4ef7-a3f4-ea63cfd8436f.png">
3 | 패키지 종속성 선택 | <img width="309" alt="CleanShot 2022-06-11 at 17 39 53@2x" src="https://user-images.githubusercontent.com/54872601/173182526-e5660b7f-c50c-4173-81f5-83c10c514659.png">
4 | + 클릭 후 검색 상자에 <code>https://github.com/1998code/SwiftNEWKit</code> 붙여넣기 | <img width="614" alt="CleanShot 2022-06-11 at 17 39 32@2x" src="https://user-images.githubusercontent.com/54872601/173182527-2a151198-7ac0-4735-8257-11580ada3d5e.png">
5L | `data.json`이라는 새 로컬 파일 생성 | 이 [JSON 샘플](https://github.com/1998code/SwiftNEWKit#sample)을 복사할 수 있습니다.
5R | 원격 JSON / Firebase 실시간 데이터베이스도 사용 가능합니다. | 샘플: https://testground-a937f-default-rtdb.firebaseio.com/0.json?print=pretty

### 주요 사용법
1. 패키지를 가져옵니다.
```swift
import SwiftNEW
```

2. `body` 또는 `some View` 앞에 상태를 추가합니다.
### 상태
변수        | 권장값                         | 옵션                          | 타입
----------- | ------------------------------ | ----------------------------- | ----
showNew *   | false                          | false, true                   | Bool
align       | .center                        | .leading, .center, .trailing  | HorizontalAlignment
color       | .accentColor                   | 모든 색상 지원                | Color
size        | "simple"                       | "invisible", "mini", "simple" | String
labelColor  | UIColor.systemBackground 또는 NSColor.windowBackgroundColor | 모든 색상 지원 | Color
label       | "릴리스 노트 보기"              | 모든 문자열                   | String
labelImage  | "arrow.up.circle.fill"         | 모든 SF 심볼                  | String
history     | true                           | true, false                   | Bool
data        | "data" 또는 "https://.../{}.json"| "{로컬_JSON_파일}" 또는 원격 | String
showDrop    | false                          | false, true                   | Bool
mesh        | true                           | false, true                   | Bool

##### 예제:
```swift
// 필수
@State var showNew: Bool = false

// 선택 사항 (5.2.0 이상)
@State var align: HorizontalAlignment = .center
@State var color: Color = .accentColor
@State var size: String = "normal"
#if os(iOS)
@State var labelColor: Color = Color(UIColor.systemBackground)
#elseif os(macOS)
@State var labelColor: Color = Color(NSColor.windowBackgroundColor)
#endif
@State var label: String = "릴리스 노트 보기"
@State var labelImage: String = "arrow.up.circle.fill"
@State var history: Bool = true
@State var data: String = "data"
@State var showDrop: Bool = false
@State var mesh: Bool = false
```

3. 그런 다음, 이 코드를 `body` 또는 `some View` 안에 붙여넣습니다.
```swift
// 5.2.0 이상에서 기본 옵션으로 간소화된 버전
SwiftNEW(show: $showNew)

// 5.1.0 이하
SwiftNEW(show: $showNew, align: $align, color: $color, size: $size, labelColor: $labelColor, label: $label, labelImage: $labelImage, history: $history, data: $data, showDrop: $showDrop)
```
개별 상태를 사용하는 대신 인라인 상태도 작동합니다. (5.2.0 이후로는 더 이상 필요하지 않음)

*`Show Bool`은 인라인으로 사용할 수 없습니다.
```swift
SwiftNEW(show: $showNew, align: .constant(.center), color: .constant(.accentColor), size: .constant("normal"), labelColor: .constant(Color(UIColor.systemBackground)), label: .constant("릴리스 노트 보기"), labelImage: .constant("arrow.up.circle.fill"), history: .constant(true), data: .constant("data"), showDrop: .constant(false))
```

4. 코드는 최소 기능과 기본 스타일을 포함하여 다음과 유사하게 보일 것입니다.
```swift
struct ContentView: View {
    @State var showNew: Bool = false
    var body: some View {
        SwiftNEW(show: $showNew)
    }
}
```

### JSON
#### 구조 / 모델 (참조)
* 아래 코드는 참조용입니다. 구조체나 모델을 복사할 필요는 없습니다.
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

#### 샘플
JSON 샘플을 `data.json` 파일에 복사합니다(파일이 없는 경우 새 파일을 만드세요).

![68747470733a2f2f76616c696461746f722e737761676765722e696f2f76616c696461746f723f75726c3d68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f4f41492f4f70656e4150492d53706563696669636174696f6e2f6d61737465722f6578616d706c65732f76](https://user-images.githubusercontent.com/54872601/173190828-8ee763b9-4e33-4231-92ac-eb81b556c462.png)
```json
[
  {
    "version": "1.2",
    "new": [
      {
        "body": "iOS 16, iPadOS 16, macOS 13에서 사용 가능",
        "icon": "hammer.fill",
        "subtitle": "UI 문제 수정",
        "title": "버그 수정"
      },
      {
        "body": "원격 스토리지를 통한 직접 로드. 간단합니다!",
        "icon": "square.and.arrow.down.fill",
        "subtitle": "지원됨",
        "title": "Firebase 원격"
      },
      {
        "body": "무료 오픈 소스! Ming이 ❤️‍🔥로 만듦",
        "icon": "macpro.gen3.server",
        "subtitle": "디자인",
        "title": "서버리스"
      },
      {
        "body": "풀 리퀘스트를 보내서 모두에게 더 좋게 만들어보세요!",
        "icon": "arrow.triangle.pull",
        "subtitle": "함께",
        "title": "기여하기"
      }
    ]
  },
  {
   "version": "1.1",
    "new": [
      {
        "body": "iOS 16, iPadOS 16, macOS 13에서 사용 가능",
        "icon": "hammer.fill",
        "subtitle": "UI 문제 수정",
        "title": "버그 수정"
      },
      {
        "body": "로컬 스토리지를 통한 직접 로드. 초고속!",
        "icon": "square.and.arrow.down.fill",
        "subtitle": "지원됨",
        "title": "로컬 파일"
      },
      {
        "body": "무료 오픈 소스! Ming이 ❤️‍🔥로 만듦",
        "icon": "macpro.gen3.server",
        "subtitle": "디자인",
        "title": "서버리스"
      },
      {
        "body": "풀 리퀘스트를 보내서 모두에게 더 좋게 만들어보세요!",
        "icon": "arrow.triangle.pull",
        "subtitle": "함께",
        "title": "기여하기"
      }
    ]
  }
]
```

## 📂 프로젝트 구조

```
Sources/SwiftNEW/
├── SwiftNEW.swift                          # 초기화와 메인 구조체
├── Model.swift                             # 데이터 모델 (Vmodel, Model)
├── Bundle+Ext.swift                        # Bundle 확장
├── Localizable.xcstrings                   # 현지화 지원
├── 📁 Views/
│   ├── SwiftNEW+View.swift                # 메인 body 뷰 구현
│   ├── 📁 Sheets/
│   │   ├── CurrentVersionSheet.swift       # 현재 버전 표시
│   │   └── HistorySheet.swift             # 버전 히스토리 표시
│   └── 📁 Components/
│       ├── HeaderView.swift               # 헤더 컴포넌트
│       └── ButtonComponents.swift         # 버튼 컴포넌트
├── 📁 Extensions/
│   └── SwiftNEW+Functions.swift           # 유틸리티 함수
├── 📁 Styles/
│   ├── AppIconView.swift                  # 앱 아이콘 표시
│   ├── MeshView.swift                     # 그라디언트 배경
│   └── NoiseView.swift                    # 노이즈 효과
└── 📁 Animations/
    └── SnowfallView.swift                 # 특수 효과 (크리스마스)
```

### 아키텍처 개요

SwiftNEW는 더 나은 유지보수성을 위해 관심사를 분리하는 모듈러 아키텍처로 구축되었습니다:

- **메인 구조체** (`SwiftNEW.swift`): 공개 API와 구성 옵션
- **뷰 계층** (`Views/`): UI 컴포넌트들을 논리적으로 그룹화
- **데이터 모델** (`Model.swift`): JSON 데이터 구조
- **확장** (`Extensions/`): 유틸리티 함수와 헬퍼
- **스타일링** (`Styles/`): 재사용 가능한 시각적 컴포넌트
- **애니메이션** (`Animations/`): 특수 효과와 애니메이션

## 기여하기

SwiftNEW에 기여해 주세요!

- 버그를 보고하거나 기능을 요청하려면 GitHub에서 이슈를 열어주세요
- 풀 리퀘스트를 제출할 때는 프로젝트의 코딩 스타일을 따라주세요

## 라이선스

MIT. 자세한 내용은 LICENSE 파일을 참조하세요.

## 번역

이 문서는 다른 언어로도 제공됩니다:

[English](../README.md) | [简中](README_zh.md) / [繁中](README_tc.md) / [粵語](README_hc.md) | [日本語](README_ja.md) | 한국어

새로운 언어를 추가하거나 오타/실수를 수정하기 위한 풀 리퀘스트를 자유롭게 열어주세요.

## 지원
<a href="https://m.do.co/c/ce873177d9ab">
    <img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/SVG/DO_Logo_horizontal_blue.svg" width="201px" alt="Digital Ocean 로고">
</a>
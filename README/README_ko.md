# SwiftNEW

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

## 기능
| 설명                                               | 버전      |
|---------------------------------------------------|-----------|
| 메쉬 그라데이션 및 선형 그라데이션 배경               | 5.3.0     |
| Apple visionOS 및 Vision Pro 지원                  | 4.1.0     |
| 버전/빌드 변경 시 자동으로 트리거/팝업 되는 .sheet    | 4.0.0     |
| 버전 번호 형식 x.y.z 및/또는 x.y                    | 4.0.0     |
| 원격 드롭 알림                                      | 3.5.0     |
| Firebase 실시간 데이터베이스                         | 3.0.0     |
| 원격 JSON 파일                                     | 3.0.0     |
| 버전 관리 + 기록 보기                               | 2.0.0     |
| 상업적/비영리적 포함 모든 사용 사례 지원              | -         |
| 간단한 모델, 쉬운 수정 및 재사용                     | -         |
| 간단한 바인딩 및 데이터 전달                        | -         |
| 로컬 스토리지에서 즉시 로드                         | -         |

## 미리보기
![CleanShot 2022-06-11 at 22 54 15@2x](https://user-images.githubusercontent.com/54872601/173192927-ca2a8bef-2114-44f8-8d4d-47baadb8b4a8.png)

## 갤러리
![IMG_3472](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![IMG_3471](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG)
------------- | ------------
라이트 모드 | 다크 모드

![Simulator Screen Shot - iPhone 13 Pro Max](https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png) | ![CleanShot 2022-12-11 at 12 46 30@2x](https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png) ![CleanShot 2022-12-11 at 12 49 12@2x](https://user-images.githubusercontent.com/54872601/206887046-8ec82853-4e32-4a07-8b64-4cc984e7ec90.png)
------------- | ------------
기록 보기 (2.0.0) | 앱 아이콘 (3.9.6) [세로 / 가로]

![CleanShot 2023-06-22 at 14 24 07@2x](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) | <img alt="Screenshot 2024-07-01 at 10 18 33 PM" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508"> |
------------- | ------------
VisionOS 지원 (4.1.0 이상) | 메쉬 그라데이션 배경 (5.3.0 이상)

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
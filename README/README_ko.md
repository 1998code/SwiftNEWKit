<img width="150" alt="SNK" src="https://github.com/user-attachments/assets/1121ae03-cf96-455e-8119-596f6f5eb58e" />

# SwiftNEW

![Stable](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=03A791&label=Stable)
![Beta](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?include_prereleases&color=3A59D1&label=Beta)
[![Validate JSON Files](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml/badge.svg)](https://github.com/1998code/SwiftNEWKit/actions/workflows/validate-json.yml)
![Swift Version](https://img.shields.io/badge/Swift-5.9/6.1-teal.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2015.0+%20|%20macOS%2014.0+%20|%20tvOS%2017.0+%20|%20visionOS%201.0+-15437D.svg)
![License](https://img.shields.io/badge/License-MIT-C8ECFE.svg)

[English](../README.md) · [繁中](README_tc.md) · [简中](README_zh.md) · [粵語](README_hc.md) · [日本語](README_ja.md) · **한국어**

모든 Apple 플랫폼을 위한 모던하고 SwiftUI 네이티브한 **「새로운 기능」** 프레젠테이션 프레임워크 — 애니메이션 그라디언트 배경, 글래스 효과, 원격 데이터 로딩, RTL 및 로컬라이제이션 기본 지원.

![image](https://github.com/user-attachments/assets/0a5de416-f4cd-41b5-8060-f839f2e7286a)

## 🎨 갤러리

| 라이트 | 다크 |
|:-----:|:----:|
| ![Light](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![Dark](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG) |

## 🚀 빠른 시작

**1. 패키지 추가**:Xcode → *File → Add Package Dependencies…*

> [!IMPORTANT]
> **패키지 URL**
>
> ```
> https://github.com/1998code/SwiftNEWKit
> ```

**2. `data.json`** 을 App Bundle 에 추가:

> [!TIP]
> 릴리스 노트 JSON 예시
>
> ```json
> [
>   {
>     "version": "1.0",
>     "new": [
>       { "icon": "star.fill", "title": "환영합니다", "subtitle": "시작하기", "body": "다운로드 해주셔서 감사합니다!" }
>     ]
>   }
> ]
> ```

**3. 뷰에 적용:**

> [!NOTE]
> 최소 SwiftUI 통합
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

이게 전부입니다 — 앱 버전이 변경되면 SwiftNEW 가 자동으로 표시됩니다.

## ✨ 기능

| 기능 | 도입 버전 | 설명 |
|---------|:-----:|-------------|
| 🔍 시트 내 검색 | 6.3.0 | 제목 / 부제 / 본문으로 현재 릴리스 노트 필터링 |
| 🏷️ 커스터마이즈 가능한 헤더 | 6.3.0 | `headingStyle`:`.version`、`.versionOnly`、`.appName` |
| 🎯 아이콘 스타일 | 6.3.0 | `iconStyle`:`.filled`(색상 배경) 또는 `.plain`(글리프만) |
| 🔢 빌드 번호 옵션 | 6.3.0 | `showBuild: false` 로 빌드 번호 숨김 |
| 🎨 플로팅 파티클 효과 | 6.3.0 | 새로운 `.particles` 특수 효과 (TimelineView + Canvas) |
| 🎯 유연한 표시 방식 | 6.2.0 | `.sheet`、`.fullScreenCover`、`.embed` |
| 🌈 적응형 텍스트 색상 | 6.2.0 | 버튼 텍스트가 배경에 맞춰 자동 대비 |
| 🛠️ 간소화된 이니셜라이저 | 6.2.0 | 값을 직접 전달 — `.constant()` 래핑 불필요 |
| 🪟 글래스모피즘 | 5.5.0 | 투명도 조절 가능한 모던 블러 |
| 🌈 메시 & 선형 그라디언트 | 5.3.0 | 애니메이션 그라디언트 배경 |
| 🥽 visionOS 지원 | 4.1.0 | 네이티브 공간 컴퓨팅 |
| 🔄 자동 트리거 | 4.0.0 | 버전 / 빌드 변경 시 자동 표시 |
| 🎄 특수 효과 | 3.9.0 | `.christmas` 눈 효과、`.particles` 무지개 |
| 📱 Drop 알림 | 3.5.0 | iOS 스타일 배너 알림 |
| 🔥 Firebase Realtime DB | 3.0.0 | 실시간 콘텐츠 업데이트 |
| 🌐 원격 JSON | 3.0.0 | 임의의 REST 엔드포인트에서 로드 |
| 📚 버전 히스토리 | 2.0.0 | 이전 릴리스 모두 탐색 |

### 기능 쇼케이스

| 메시 그라디언트 (5.3+) | visionOS (4.1+) |
|:--------------------:|:---------------:|
| <img alt="Mesh" src="https://github.com/1998code/SwiftNEWKit/assets/54872601/a845c460-65d7-47a0-ae15-23897efd0508"> | ![visionOS](https://github.com/1998code/SwiftNEWKit/assets/54872601/12a8ab01-76e5-42a1-96b4-848ef5e5f36b) |

| App 아이콘 (3.9.6+) | 히스토리 (2.0+) |
|:-----------------:|:--------------:|
| <img height="400" alt="App Icon" src="https://user-images.githubusercontent.com/54872601/206886933-bc4d0d33-e0fc-4013-9456-f19679b10f5b.png"> | <img height="400" alt="History" src="https://user-images.githubusercontent.com/54872601/178129999-ad63b0ce-d65e-4d86-9882-37a5090e92bc.png"> |

## 📚 자세히 알아보기

| 가이드 | 내용 |
|-------|--------|
| [Configuration](CONFIGURATION.md) | 모든 파라미터、예제、데이터 소스 (로컬 / 원격 / Firebase)、데이터 모델 |
| [Platform Support & Installation](PLATFORM.md) | 지원 OS 버전、요구 사항、기능 매트릭스、SPM 설정 |
| [Contributing](CONTRIBUTING.md) | 프로젝트 구조、개발 환경、PR 가이드라인、문제 해결 |

## 📄 라이선스

SwiftNEW 는 **MIT License** 로 공개됩니다 — 가장 관대한 오픈 소스 라이선스 중 하나.

| | 세부 사항 |
|---|---------|
| ✅ **가능** | 상업용 앱(App Store 유료 앱 포함)에서 사용、수정、재배포、클로즈드 소스 소프트웨어에 포함 |
| 📝 **필수** | 원본 저작권 및 라이선스 표시를 프로젝트에 유지 |
| ⚠️ **무보증** | 소프트웨어는 「있는 그대로」 제공됩니다 — 사용으로 인한 문제에 대해 작성자는 책임지지 않습니다 |

전체 내용은 [LICENSE](../LICENSE) 참조.

## 💖 후원

| 후원 | 리소스 |
|---------|----------|
| <a href="https://m.do.co/c/ce873177d9ab"><img src="https://opensource.nyc3.cdn.digitaloceanspaces.com/attribution/assets/SVG/DO_Logo_horizontal_blue.svg" width="160px" alt="Digital Ocean"></a> | 클라우드 인프라 |
| [![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/1998code/SwiftNEWKit) | AI 문서 Q&A |

# SwiftNEWKit
### Accelerated by Apple SwiftUI

![CleanShot 2022-06-11 at 22 54 15@2x](https://user-images.githubusercontent.com/54872601/173192927-ca2a8bef-2114-44f8-8d4d-47baadb8b4a8.png)

## Aims
Provide an easy way for Apple Developers to Show "What's New" to the end users.

## Features
- Auto trigger the `.sheet` from Version and/or Build increase
- One-line coding
- JSON compatible
- Versioning
- Local available
- Simple Binding
- Simple Model
- Open source

## Version
![GitHub release (latest by date)](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=g&label=STABLE&style=for-the-badge)
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/1998code/SwiftNEWKit?color=green&include_prereleases&label=BETA&style=for-the-badge)

![swiftui-128x128_2x](https://user-images.githubusercontent.com/54872601/173193069-2eb486b0-1347-4448-ac2b-235b8f2f1bb0.png)

## Environment
### Xcode Local
Tested on | Latest | Compatible
--------- | ------ | ----------
iOS       | 16     | > 14
iPadOS    | 16     | > 14
macOS     | 13     | > 11
### Xcode Cloud
Tested on | Compatible
--------- | ----------
Xcode     | 13.4 (13F17a)
macOS     | 12.3.1 (21E258)

## Guide
[English](https://github.com/1998code/SwiftNEWKit) | [中文](https://github.com/1998code/SwiftNEWKit/blob/main/doc/README_zh.md) | Feel free to add new language(s) via `pull requests`

## Get Started
### Full Tutorial: https://bit.ly/3NOvJB8

### Setup
Steps | Description | Screenshot
------| ----------- | ----------
1 | Navigate to root project | <img width="274" alt="CleanShot 2022-06-11 at 17 39 39@2x" src="https://user-images.githubusercontent.com/54872601/173182521-27481cf2-c9bf-4f87-95cc-76f5d1c05094.png">
2 | Select Project | <img width="174" alt="CleanShot 2022-06-11 at 17 39 48@2x" src="https://user-images.githubusercontent.com/54872601/173182523-6a24c67a-8f27-4ef7-a3f4-ea63cfd8436f.png">
3 | Select Package Dependencies | <img width="309" alt="CleanShot 2022-06-11 at 17 39 53@2x" src="https://user-images.githubusercontent.com/54872601/173182526-e5660b7f-c50c-4173-81f5-83c10c514659.png">
4 | Click + and paste <code>https://github.com/1998code/SwiftNEWKit</code> to the searchbox | <img width="614" alt="CleanShot 2022-06-11 at 17 39 32@2x" src="https://user-images.githubusercontent.com/54872601/173182527-2a151198-7ac0-4735-8257-11580ada3d5e.png">
5 | Create a new file called `data.json` | You may copy the [JSON sample](https://github.com/1998code/SwiftNEWKit#sample) below. 

### Major Usage
1. Import first.
```
import SwiftNEW
```
2. Then, paste this code inside `body` or any `some View`.
```
SwiftNEW(show: $showNew, align: $align, color: $color, size: $size, label: $label, labelImage: $labelImage)
```

### State
var         | Suggested                       | Options                      | Type
----------- | ------------------------------- | ---------------------------- | ----
showNew     | false                           | false, true                  | Bool
align       | .center                         | .leading, .center, .trailing | HorizontalAlignment
color       | .accentColor                    | All Colors Supported         | Color
textColor   | Color(UIColor.systemBackground) | All Colors Supported         | Color
size        | "normal"                        | "invisible", "mini", "normal"| String
label       | "Show Release Note"             | All Strings                  | String
labelImage  | "arrow.up.circle.fill"          | All SF Symbols               | String
##### Samples:
```
@State var showNew: Bool = false
@State var align: HorizontalAlignment = .center
@State var color: Color = .accentColor
@State var size: String = "normal"
@State var label: String = "Show Release Note"
@State var labelImage: String = "arrow.up.circle.fill"
```

### JSON
#### Structure / Model
```
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
#### Sample
![68747470733a2f2f76616c696461746f722e737761676765722e696f2f76616c696461746f723f75726c3d68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f4f41492f4f70656e4150492d53706563696669636174696f6e2f6d61737465722f6578616d706c65732f76](https://user-images.githubusercontent.com/54872601/173190828-8ee763b9-4e33-4231-92ac-eb81b556c462.png)
```
[
    {
        "version": "1.1",
        "new": [
            {
                "icon": "pencil.and.ruler.fill",
                "title": "Apple Pencil 3",
                "subtitle": "Supported",
                "body": "Available for the new iPad Pro"
            },
            {
                "icon": "hammer.fill",
                "title": "Bug fixes",
                "subtitle": "Broken UI",
                "body": "Available for iOS 16, iPadOS 16, macOS 13"
            },
            {
                "icon": "square.and.arrow.down.fill",
                "title": "Local File",
                "subtitle": "Supported",
                "body": "Direct load via local storage. Super fast!"
            },
            {
                "icon": "macpro.gen3.server",
                "title": "Serverless",
                "subtitle": "Design",
                "body": "Free and open source! Created by Ming with ❤️‍🔥"
            },
            {
                "icon": "arrow.triangle.pull",
                "title": "Contribute",
                "subtitle": "Together",
                "body": "Pull requests and make it better for everyone!"
            }
        ]
    }
]
```

## Developer Note
- Please report bugs in Issues section.
- If you want to discuss future roadmap or contribution, please find on Discussions.

## Preview
![IMG_3472](https://user-images.githubusercontent.com/54872601/173187065-14d78119-47e7-4dcb-a3e6-c7fee4f0c67f.PNG) | ![IMG_3471](https://user-images.githubusercontent.com/54872601/173187067-fe3b5cac-54b5-4482-b73f-42e6c500546f.PNG)
------------- | ------------
Light Native | Dark Native

## Demo
Path: `./Demo`

## License
MIT

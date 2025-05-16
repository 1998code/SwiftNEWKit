//
//  ContentView.swift
//  What's New?
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftNEW

#Preview("Default") {
    @Previewable @State var showNew: Bool = false
    SwiftNEW(show: $showNew)
}

// Mini (Toolbar / List only)
#Preview("Invisible") {
    @Previewable @State var showNew: Bool = false
    List {
        Section(header: Text("Compatible with Toolbar / List")) {
            SwiftNEW(show: $showNew, size: .constant("mini"))
        }
    }
}

#Preview("Invisible") {
    @Previewable @State var showNew: Bool = false
    SwiftNEW(show: $showNew, size: .constant("invisible"))
}

// Remote (>3.0.0) - Firebase Real Time Database Demo (Compatible with json format)
#Preview("Remote") {
    @Previewable @State var showNew: Bool = false
    SwiftNEW(show: $showNew, labelImage: .constant("icloud"), data: .constant("https://testground-a937f-default-rtdb.firebaseio.com/.json?print=pretty"))
}

// Drop (>3.4.0) - Recommended trigger with Remote Notification
#Preview("Drop") {
    @Previewable @State var showNew: Bool = false
    SwiftNEW(show: $showNew, label: .constant("Notification"), labelImage: .constant("bell.badge"), data: .constant("https://testground-a937f-default-rtdb.firebaseio.com/.json?print=pretty"), showDrop: .constant(true))
}

//    All States
//    @State var showNew: Bool = false
//    Optional
//    @State var align: HorizontalAlignment = .center
//    @State var color: Color = .accentColor
//    @State var size: String = "simple"
//    #if os(iOS) || os(visionOS)
//    @State var labelColor: Color = Color(UIColor.systemBackground)
//    #elseif os(macOS)
//    @State var labelColor: Color = Color(NSColor.windowBackgroundColor)
//    #endif
//    @State var label: String = "Show Release Note"
//    @State var labelImage: String = "arrow.up.circle.fill"
//    @State var history: Bool = true
//    @State var data: String = "data"
//    @State var showDrop: Bool = false
//    @State var mesh: Bool = true
//    @State var specialEffect: String = "Christmas"

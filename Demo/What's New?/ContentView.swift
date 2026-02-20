//
//  ContentView.swift
//  What's New?
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftNEW

struct ContentView : View {
    @State var showNew: Bool = false
    var body: some View {
        SwiftNEW(show: $showNew)
    }
}

#Preview("Default") {
    ContentView()
}

// Mini (Toolbar / List only)
#Preview("Mini") {
    @Previewable @State var showNew: Bool = false
    List {
        Section(header: Text("Compatible with Toolbar / List")) {
            SwiftNEW(show: $showNew, size: "mini", glass: false)
        }
    }
}

#Preview("Invisible") {
    @Previewable @State var showNew: Bool = true
    SwiftNEW(show: $showNew, size: "invisible")
}

// Remote (>3.0.0) - Firebase Real Time Database Demo / Any JSON URL
#Preview("Remote") {
    @Previewable @State var showNew: Bool = false
    let lang = Bundle.main.preferredLocalizations.first ?? "en"
    SwiftNEW(show: $showNew, labelImage: "icloud", data: "https://testground-a937f-default-rtdb.firebaseio.com/\(lang).json?print=pretty")
}

// Drop (>3.4.0) - Recommended trigger with Remote Notification
#Preview("Drop") {
    @Previewable @State var showNew: Bool = false
    let lang = Bundle.main.preferredLocalizations.first ?? "en"
    SwiftNEW(show: $showNew, label: "Notification", labelImage: "bell.badge", data: "https://testground-a937f-default-rtdb.firebaseio.com/\(lang).json?print=pretty", showDrop: true)
}

// Full Screen Cover (>6.2.0) - Presentation option
#Preview("Full Screen Cover") {
    @Previewable @State var showNew: Bool = false
    SwiftNEW(show: $showNew, presentation: .fullScreenCover)
}

// Embed (>6.2.0) - Render content directly
#Preview("Embed") {
    @Previewable @State var showNew: Bool = true
    SwiftNEW(show: $showNew, presentation: .embed)
}

// Special Effect - Christmas snow effect
#Preview("Christmas Effect") {
    @Previewable @State var showNew: Bool = false
    SwiftNEW(show: $showNew, specialEffect: .christmas)
}

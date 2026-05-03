//
//  ContentView+Previews.swift
//  What's New?
//

import SwiftUI
import SwiftNEW

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

// Remote (>3.0.0) - Any JSON URL
#Preview("Remote") {
    @Previewable @State var showNew: Bool = false
    SwiftNEW(show: $showNew, labelImage: "icloud", data: "https://raw.githubusercontent.com/1998code/SwiftNEWKit/refs/heads/main/Demo/What's%20New%3F/en.lproj/data.json")
}

// Drop (>3.4.0) - Recommended trigger with Remote Notification
#Preview("Drop") {
    @Previewable @State var showNew: Bool = false
    SwiftNEW(show: $showNew, label: "Notification", labelImage: "bell.badge", data: "https://raw.githubusercontent.com/1998code/SwiftNEWKit/refs/heads/main/Demo/What's%20New%3F/en.lproj/data.json", showDrop: true)
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

// Special Effect (>6.3.0) - Floating particles
#Preview("Particles Effect") {
    @Previewable @State var showNew: Bool = false
    SwiftNEW(show: $showNew, specialEffect: .particles)
}

// Heading Style (>6.3.0) - Show App Name as subtitle
#Preview("App Name Heading") {
    @Previewable @State var showNew: Bool = true
    SwiftNEW(show: $showNew, headingStyle: .appName)
}

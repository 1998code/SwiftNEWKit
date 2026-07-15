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

// Remote Update - Dedicated fixture stays higher than the demo app version
#Preview("Remote Update") {
    @Previewable @State var showNew: Bool = false
    SwiftNEW(
        show: $showNew,
        labelImage: "arrow.down.app",
        data: "https://raw.githubusercontent.com/1998code/SwiftNEWKit/refs/heads/main/Demo/remote-update-preview.json",
        presentation: .fullScreenCover,
        checkForUpdates: true,
        allowsSkippingUpdate: false,
        appStoreBundleIdentifier: "com.apple.TestFlight"
    )
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

// Liquid Mesh (>6.4.0) - Animated mesh gradient background
#Preview("Liquid Mesh") {
    @Previewable @State var showNew: Bool = true
    SwiftNEW(show: $showNew, meshStyle: .liquid, presentation: .embed)
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

// Heading Prefix (>6.4.0) - Use App Name as title
#Preview("App Name Prefix") {
    @Previewable @State var showNew: Bool = true
    SwiftNEW(show: $showNew, headingPrefix: previewAppName)
}

private var previewAppName: String {
    Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        ?? Bundle.main.infoDictionary?["CFBundleName"] as? String
        ?? "App"
}

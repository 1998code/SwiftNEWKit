//
//  ContentView.swift
//  What's New?
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftNEW

struct ContentView: View {
    
    @State var preview: String = "Normal"
    
    // MARK: All States
    @State var showNew: Bool = false
    @State var align: HorizontalAlignment = .center
    @State var color: Color = .accentColor
    @State var size: String = "normal"
    @State var labelColor: Color = Color(UIColor.systemBackground)
    @State var label: String = "Show Release Note"
    @State var labelImage: String = "arrow.up.circle.fill"
    @State var history: Bool = true
    @State var data: String = "data"
    @State var showDrop: Bool = false
    
    var normal: some View {
        SwiftNEW(show: $showNew, align: $align, color: $color, size: $size, labelColor: $labelColor, label: $label, labelImage: $labelImage, history: $history, data: $data, showDrop: $showDrop)
    }
    
    var mini: some View {
        // MARK: Mini (Toolbar only)
        Text("Compatible with Toolbar")
    }
    
    var invisible: some View {
        SwiftNEW(show: $showNew, align: $align, color: $color, size: .constant("invisible"), labelColor: $labelColor, label: $label, labelImage: $labelImage, history: $history, data: $data, showDrop: $showDrop)
    }
    
    var remote: some View {
        // MARK: Remote (>3.0.0) - Firebase Real Time Database Demo (Compatible with json format)
        SwiftNEW(show: $showNew, align: $align, color: $color, size: $size, labelColor: $labelColor, label: $label, labelImage: .constant("icloud"), history: $history, data: .constant("https://testground-a937f-default-rtdb.firebaseio.com/.json?print=pretty"), showDrop: $showDrop)
    }
    
    var drop: some View {
        // MARK: Drop (>3.4.0) - Recommended trigger with Remote Notification
        SwiftNEW(show: $showNew, align: $align, color: $color, size: $size, labelColor: $labelColor, label: .constant("Notification"), labelImage: .constant("bell.badge"), history: $history, data: .constant("https://testground-a937f-default-rtdb.firebaseio.com/.json?print=pretty"), showDrop: .constant(true))
    }
    
    var body: some View {
        NavigationView {
            // MARK: Choose either one size (Normal, Mini or Invisible)
            TabView(selection: $preview) {
                normal
                    .tabItem { Text("Normal") }.tag("Normal")
                mini
                    .tabItem { Text("Mini") }.tag("Mini")
                invisible
                    .tabItem { Text("Invisible") }.tag("Invisible")
                remote
                    .tabItem { Text("Remote") }.tag("Remote")
                drop
                    .tabItem { Text("Drop") }.tag("Drop")
            }
            .toolbar {
                if preview == "Mini" {
                    SwiftNEW(show: $showNew, align: $align, color: $color, size: .constant("mini"), labelColor: $labelColor, label: $label, labelImage: $labelImage, history: $history, data: $data, showDrop: $showDrop)
                }
            }
        }
        #if os(iOS)
        .navigationViewStyle(.stack)
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

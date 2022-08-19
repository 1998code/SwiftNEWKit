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
    
    var body: some View {
        NavigationView {
            
            // MARK: Choose either one size (Normal, Mini or Invisible)
            
            TabView(selection: $preview) {
                
                // MARK: - Normal
                SwiftNEW(show: $showNew, align: $align, color: $color, size: $size, labelColor: $labelColor, label: $label, labelImage: $labelImage, history: $history, data: $data)
                
                // Don't copy tabItem
                    .tabItem { Text("Normal") }.tag("Normal")
                
                // MARK: - Mini (Toolbar only)
                Text("Compatible with Toolbar")
                    .tabItem { Text("Mini") }.tag("Mini")
                
                // MARK: - Invisible
                SwiftNEW(show: $showNew, align: $align, color: $color, size: .constant("invisible"), labelColor: $labelColor, label: $label, labelImage: $labelImage, history: $history, data: $data)
                    
                // Don't copy tabItem
                    .tabItem { Text("Invisible") }.tag("Invisible")
                
                // MARK: - Remote Test (>3.0.0)
                //         Firebase Real Time Database Demo
                SwiftNEW(show: $showNew, align: $align, color: $color, size: $size, labelColor: $labelColor, label: $label, labelImage: .constant("icloud"), history: $history, data: .constant("https://testground-a937f-default-rtdb.firebaseio.com/.json?print=pretty"))
                
                // Don't copy tabItem
                    .tabItem { Text("Remote") }.tag("Remote")
                
            }
            .toolbar {
                if preview == "Mini" {
                    SwiftNEW(show: $showNew, align: $align, color: $color, size: .constant("mini"), labelColor: $labelColor, label: $label, labelImage: $labelImage, history: $history, data: $data)
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

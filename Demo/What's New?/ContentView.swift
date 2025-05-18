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

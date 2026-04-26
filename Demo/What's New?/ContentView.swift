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

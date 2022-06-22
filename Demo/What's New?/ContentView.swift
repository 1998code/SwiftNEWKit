//
//  ContentView.swift
//  What's New?
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftNEW

struct ContentView: View {
    // MARK: - All States
    @State var showNew: Bool = false
    @State var align: HorizontalAlignment = .center
    @State var color: Color = .accentColor
    @State var size: String = "normal"
    @State var label: String = "Show Release Note"
    @State var labelImage: String = "arrow.up.circle.fill"
    var body: some View {
        NavigationView {
            // MARK: Choose either one size (Normal, Mini or invisible)
            
            // MARK: Normal
            SwiftNEW(show: $showNew, align: $align, color: $color, size: $size, label: $label, labelImage: $labelImage)
            
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        // MARK: Invisible
                        SwiftNEW(show: $showNew, align: $align, color: $color, size: .constant("invisible"), label: $label, labelImage: $labelImage)
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        // MARK: Mini
                        SwiftNEW(show: $showNew, align: $align, color: $color, size: .constant("mini"), label: $label, labelImage: $labelImage)
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

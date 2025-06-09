//
//  SwiftNEW+View.swift
//  SwiftNEW
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftVB
import SwiftGlass

#if os(iOS)
import Drops
#endif

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {
    public var body: some View {
        Button(action: {
            if showDrop {
                #if os(iOS)
                drop()
                #endif
            } else {
                show = true
            }
        }) {
            if size == "mini" {
                Label(label, systemImage: labelImage)
            }
            else if size == "normal" || size == "simple" {
                Label(label, systemImage: labelImage)
                    #if !os(tvOS)
                    .frame(width: 300, height: 50)
                    #else
                    .frame(width: 400, height: 50)
                    #endif
                    #if os(iOS) && !os(visionOS)
                    .foregroundColor(labelColor)
                    .background(color)
                    .cornerRadius(15)
                    #endif
            }
        }
        .opacity(size == "invisible" ? 0 : 100)
        .glass(shadowColor: color)
        .sheet(isPresented: $show) {
            ZStack {
                if mesh {
                    MeshView(color: $color)
                }
                if specialEffect == "Christmas" {
                    SnowfallView()
                }
                sheetCurrent
                    .sheet(isPresented: $historySheet) {
                        if #available(iOS 16.4, tvOS 16.4, *) {
                            sheetHistory
                                .presentationBackground(.thinMaterial)
                        } else {
                            sheetHistory
                        }
                    }
                    #if os(visionOS)
                    .padding()
                    #endif
            }
        }
    }
}

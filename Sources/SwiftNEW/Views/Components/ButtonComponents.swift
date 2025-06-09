//
//  ButtonComponents.swift
//  SwiftNEW
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftVB
import SwiftGlass

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {
    
    public var showHistoryButton: some View {
        Button(action: {
            historySheet = true
        }) {
            HStack {
                if align == .trailing {
                    Spacer()
                }
                Text(String(localized: "Show History", bundle: .module))
                Image(systemName: "arrow.up.bin")
                if align == .leading {
                    Spacer()
                }
            }.font(.caption)
        }
        #if !os(visionOS)
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .tint(.secondary)
        #endif
        .glass(color: .secondary, shadowColor: color)
    }
    
    public var closeCurrentButton: some View {
        Button(action: { show = false }) {
            HStack{
                if align == .trailing {
                    Spacer()
                }
                Text(String(localized: "Continue", bundle: .module))
                    .bold()
                Image(systemName: "arrow.right.circle.fill")
                if align == .leading {
                    Spacer()
                }
            }.font(.body)
            .padding(.horizontal)
            #if os(iOS)
            .frame(width: 300, height: 50)
            #elseif os(macOS)
            .frame(width: 200, height: 25)
            #endif
            #if os(iOS) && !os(visionOS)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(15)
            #elseif os(tvOS)
            .tint(.white)
            #endif
        }.glass(shadowColor: color)
    }
    
    public var closeHistoryButton: some View {
        Button(action: { historySheet = false }) {
            HStack{
                if align == .trailing {
                    Spacer()
                }
                Text(String(localized: "Return", bundle: .module))
                    .bold()
                Image(systemName: "arrow.down.circle.fill")
                if align == .leading {
                    Spacer()
                }
            }.font(.body)
            .padding(.horizontal)
            #if os(iOS)
            .frame(width: 300, height: 50)
            #elseif os(macOS)
            .frame(width: 300, height: 25)
            #endif
            #if os(iOS)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(15)
            #endif
        }.glass(shadowColor: color)
    }
}

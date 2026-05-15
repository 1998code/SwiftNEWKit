//
//  MeshView.swift
//  SwiftNEW
//
//  Created by Ming on 7/1/2025.
//

import SwiftUI

struct MeshView: View {
    @Binding var color: Color

    var body: some View {
        #if compiler(>=6.0)
        if #available(iOS 18.0, macOS 15.0, visionOS 2.0, tvOS 18.0, *) {
            meshGradient
        } else { // LCOV_EXCL_START -- Xcode 26 coverage runner cannot execute older OS mesh fallback.
            fallbackGradient
        } // LCOV_EXCL_STOP
        #else
        fallbackGradient
        #endif
    }

    #if compiler(>=6.0)
    @available(iOS 18.0, macOS 15.0, visionOS 2.0, tvOS 18.0, *)
    private var meshGradient: some View {
        // Diagonal flow: clear at top-left to most opaque at bottom-right.
        MeshGradient(width: 3, height: 3, points: [
            .init(0, 0), .init(0.5, 0), .init(1, 0),
            .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
            .init(0, 1), .init(0.5, 1), .init(1, 1)
        ], colors: [
            Color(.clear), Color(.clear), Color(.clear),
            color.opacity(0.1), color.opacity(0.1), color.opacity(0.2),
            color.opacity(0.5), color.opacity(0.6), color.opacity(0.7)
        ])
        .ignoresSafeArea(.all)
        .overlay(
            NoiseView(size: 5000)
                .drawingGroup()
        )
    }
    #endif

    private var fallbackGradient: some View {
        LinearGradient(
            colors: [Color(.clear), color.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea(.all)
    }

    #if DEBUG
    var testingFallbackGradient: some View {
        fallbackGradient
    }
    #endif
}

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
        if #available(iOS 18.0, macOS 15.0, visionOS 2.0, *) {
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
                NoiseView(size: 100000)
            )
        } else {
            // Fallback on earlier versions
            LinearGradient(colors: [Color.accentColor.opacity(0.5), Color(.clear)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
        }
    }
}

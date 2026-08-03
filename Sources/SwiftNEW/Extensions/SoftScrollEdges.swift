//
//  SoftScrollEdges.swift
//  SwiftNEW
//

import SwiftUI

/// Fades the top and bottom edges of a scrolling container so content
/// dissolves instead of being cut off by a hard rectangular clip.
@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
struct SoftScrollEdges: ViewModifier {
    var top: CGFloat
    var bottom: CGFloat

    func body(content: Content) -> some View {
        content.mask(
            GeometryReader { geometry in
                let height = max(geometry.size.height, 1)
                // Never let the two fades consume more than the full height.
                let scale = min(1, height / max(top + bottom, 1))
                let topFraction = (top * scale) / height
                let bottomFraction = (bottom * scale) / height

                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .black, location: topFraction),
                        .init(color: .black, location: 1 - bottomFraction),
                        .init(color: .clear, location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        )
    }
}

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension View {
    /// Softens the scroll container's top and bottom edges with a fade.
    func softScrollEdges(top: CGFloat = 18, bottom: CGFloat = 18) -> some View {
        modifier(SoftScrollEdges(top: top, bottom: bottom))
    }
}

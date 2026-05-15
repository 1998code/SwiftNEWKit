//
//  NoiseView.swift
//  SwiftNEW
//
//  Created by Ming on 7/1/2025.
//

import SwiftUI

struct NoiseView: View {
    let size: Int
    private let points: [CGPoint]

    init(size: Int) {
        self.size = size
        self.points = (0..<size).map { index in
            CGPoint(
                x: Self.unitRandom(index: index, salt: 12.9898),
                y: Self.unitRandom(index: index, salt: 78.233)
            )
        }
    }

    var body: some View {
        Canvas { context, size in
            for point in points {
                let rect = CGRect(
                    x: point.x * size.width,
                    y: point.y * size.height,
                    width: 1,
                    height: 1
                )
                context.fill(Ellipse().path(in: rect), with: .color(noiseColor))
            }
        }
        .opacity(0.5)
    }

    private var noiseColor: Color {
        #if os(macOS)
        Color(NSColor.windowBackgroundColor).opacity(0.1)
        #elseif os(tvOS)
        Color.black.opacity(0.1)
        #else
        Color(.systemBackground).opacity(0.1)
        #endif
    }

    private static func unitRandom(index: Int, salt: Double) -> Double {
        let value = sin(Double(index) * 12.9898 + salt) * 43_758.5453
        return value - floor(value)
    }
}

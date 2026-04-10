//
//  FloatingParticlesView.swift
//  SwiftNEW
//

import SwiftUI

struct FloatingParticlesView: View {
    private let particleCount = 30
    private let particleColors: [Color] = [
        .red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink
    ]

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                for i in 0..<particleCount {
                    let seed = Double(i) * 137.508
                    let x = (sin(time * 0.3 + seed) * 0.45 + 0.5) * size.width
                    let y = (cos(time * 0.2 + seed * 0.7) * 0.45 + 0.5) * size.height
                    let radius = CGFloat(3 + sin(seed) * 3)
                    let opacity = 0.5 + sin(time * 0.5 + seed) * 0.2
                    let color = particleColors[i % particleColors.count]

                    context.opacity = 0.4
                    context.fill(
                        Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)),
                        with: .color(color.opacity(opacity))
                    )
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

//
//  FloatingParticlesView.swift
//  SwiftNEW
//

import SwiftUI

struct FloatingParticlesView: View {
    private let particleCount = 30
    private static let particleColors: [Color] = [
        .red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink
    ]
    private let particles: [Particle]

    init() {
        self.particles = (0..<particleCount).map { index in
            let seed = Double(index) * 137.508
            return Particle(
                seed: seed,
                radius: CGFloat(3 + sin(seed) * 3),
                color: Self.particleColors[index % Self.particleColors.count]
            )
        }
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                for particle in particles {
                    let x = (sin(time * 0.3 + particle.seed) * 0.45 + 0.5) * size.width
                    let y = (cos(time * 0.2 + particle.seed * 0.7) * 0.45 + 0.5) * size.height
                    let opacity = 0.5 + sin(time * 0.5 + particle.seed) * 0.2

                    context.opacity = 0.4
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: x - particle.radius,
                            y: y - particle.radius,
                            width: particle.radius * 2,
                            height: particle.radius * 2
                        )),
                        with: .color(particle.color.opacity(opacity))
                    )
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private struct Particle {
        let seed: Double
        let radius: CGFloat
        let color: Color
    }
}

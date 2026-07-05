//
//  MeshView.swift
//  SwiftNEW
//
//  Created by Ming on 7/1/2025.
//

import SwiftUI

struct MeshView: View {
    @Binding var color: Color
    let style: SwiftNEWMeshStyle

    init(color: Binding<Color>, style: SwiftNEWMeshStyle = .still) {
        _color = color
        self.style = style
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(.regularMaterial)

                switch style {
                case .still:
                    gradientLayer(phase: 0)
                case .liquid:
                    liquidGradient(size: geometry.size)
                }

                readabilityWash

                NoiseView(size: 3000)
                    .drawingGroup()
                    .allowsHitTesting(false)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea(.all)
    }

    @ViewBuilder
    private func gradientLayer(phase: Double) -> some View {
        #if compiler(>=6.0)
        if #available(iOS 18.0, macOS 15.0, visionOS 2.0, tvOS 18.0, *) {
            meshGradient(phase: phase)
        } else { // LCOV_EXCL_START -- Xcode 26 coverage runner cannot execute older OS mesh fallback.
            fallbackGradient(phase: phase)
        } // LCOV_EXCL_STOP
        #else
        fallbackGradient(phase: phase)
        #endif
    }

    private func liquidGradient(size: CGSize) -> some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let phase = timeline.date.timeIntervalSinceReferenceDate / 3.5

            ZStack {
                gradientLayer(phase: phase)
                liquidHighlights(phase: phase, size: size)
            }
        }
    }

    #if compiler(>=6.0)
    @available(iOS 18.0, macOS 15.0, visionOS 2.0, tvOS 18.0, *)
    private func meshGradient(phase: Double) -> some View {
        // Keep every point non-transparent so sheet backgrounds never expose a flat system fill.
        MeshGradient(width: 3, height: 3, points: meshPoints(phase: phase), colors: [
            color.opacity(0.46), color.opacity(0.34), color.opacity(0.18),
            color.opacity(0.24), color.opacity(0.16), color.opacity(0.03),
            color.opacity(0.14), color.opacity(0.04), color.opacity(0.10)
        ])
    }

    @available(iOS 18.0, macOS 15.0, visionOS 2.0, tvOS 18.0, *)
    private func meshPoints(phase: Double) -> [SIMD2<Float>] {
        let motion = style == .liquid ? 1.0 : 0.0
        let midX = 0.5 + (sin(phase) * 0.12 * motion)
        let midY = 0.5 + (cos(phase * 0.9) * 0.10 * motion)

        return [
            .init(0, 0), .init(Float(0.5 + sin(phase * 0.7) * 0.05 * motion), 0), .init(1, 0),
            .init(0, Float(0.5 + cos(phase * 0.8) * 0.06 * motion)), .init(Float(midX), Float(midY)), .init(1, Float(0.5 + sin(phase * 0.6) * 0.06 * motion)),
            .init(0, 1), .init(Float(0.5 + cos(phase * 0.75) * 0.05 * motion), 1), .init(1, 1)
        ]
    }
    #endif

    private func fallbackGradient(phase: Double) -> some View {
        let motion = style == .liquid ? 1.0 : 0.0
        let topCenter = UnitPoint(
            x: CGFloat(0.80 + sin(phase * 0.7) * 0.10 * motion),
            y: CGFloat(0.12 + cos(phase * 0.6) * 0.06 * motion)
        )
        let bottomCenter = UnitPoint(
            x: CGFloat(0.20 + cos(phase * 0.8) * 0.10 * motion),
            y: CGFloat(0.88 + sin(phase * 0.7) * 0.06 * motion)
        )

        return ZStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: color.opacity(0.46), location: 0.0),
                    .init(color: color.opacity(0.22), location: 0.32),
                    .init(color: color.opacity(0.04), location: 0.70),
                    .init(color: color.opacity(0.10), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [color.opacity(0.24), .clear],
                center: topCenter,
                startRadius: 0,
                endRadius: 420
            )

            RadialGradient(
                colors: [color.opacity(0.12), .clear],
                center: bottomCenter,
                startRadius: 0,
                endRadius: 520
            )
        }
    }

    private func liquidHighlights(phase: Double, size: CGSize) -> some View {
        let radius = max(size.width, size.height) * 0.68
        let firstCenter = UnitPoint(
            x: CGFloat(0.50 + sin(phase * 0.85) * 0.24),
            y: CGFloat(0.22 + cos(phase * 0.70) * 0.12)
        )
        let secondCenter = UnitPoint(
            x: CGFloat(0.50 + cos(phase * 0.65) * 0.18),
            y: CGFloat(0.72 + sin(phase * 0.80) * 0.10)
        )

        return ZStack {
            RadialGradient(
                colors: [color.opacity(0.20), .clear],
                center: firstCenter,
                startRadius: 0,
                endRadius: radius
            )

            RadialGradient(
                colors: [color.opacity(0.14), .clear],
                center: secondCenter,
                startRadius: 0,
                endRadius: radius * 0.85
            )
        }
        .allowsHitTesting(false)
    }

    private var readabilityWash: some View {
        LinearGradient(
            colors: [
                readabilityColor.opacity(0.62),
                readabilityColor.opacity(0.46),
                readabilityColor.opacity(0.60)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .allowsHitTesting(false)
    }

    private var readabilityColor: Color {
        #if os(macOS)
        Color(NSColor.windowBackgroundColor)
        #elseif os(tvOS)
        Color.black
        #else
        Color(.systemBackground)
        #endif
    }

    #if DEBUG
    var testingFallbackGradient: some View {
        fallbackGradient(phase: 0)
    }
    #endif
}

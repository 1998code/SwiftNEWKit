//
//  SnowfallView.swift
//  SwiftNEW
//
//  Created by Ming on 7/1/2025.
//

import SwiftUI

struct SnowfallView: View {
    private let snowflakeCount = 100

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                for i in 0..<snowflakeCount {
                    let seed = Double(i) * 73.156
                    let speed = 1.0 + (seed.truncatingRemainder(dividingBy: 3.0))
                    let snowflakeSize = CGFloat(2 + (seed.truncatingRemainder(dividingBy: 5.0)))

                    // Horizontal drift using sine wave
                    let drift = sin(time * 0.5 + seed) * 30
                    let x = ((seed * 7.3).truncatingRemainder(dividingBy: size.width)) + drift
                    // Vertical fall with wrapping
                    let y = ((time * speed * 30) + seed * 5).truncatingRemainder(dividingBy: Double(size.height + 20)) - 10
                    let opacity = 0.5 + sin(seed) * 0.3

                    context.opacity = opacity
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: x - snowflakeSize / 2,
                            y: y - snowflakeSize / 2,
                            width: snowflakeSize,
                            height: snowflakeSize
                        )),
                        with: .color(.white)
                    )
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

//
//  SnowfallView.swift
//  SwiftNEW
//
//  Created by Ming on 7/1/2025.
//

import SwiftUI

struct SnowfallView: View {
    private let snowflakeCount = 100
    private let snowflakes: [Snowflake]

    init() {
        self.snowflakes = (0..<snowflakeCount).map { index in
            let seed = Double(index) * 73.156
            return Snowflake(
                seed: seed,
                speed: 1.0 + seed.truncatingRemainder(dividingBy: 3.0),
                size: CGFloat(2 + seed.truncatingRemainder(dividingBy: 5.0)),
                opacity: 0.5 + sin(seed) * 0.3,
                horizontalBase: seed * 7.3
            )
        }
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                guard size.width > 0, size.height > 0 else { return }

                let time = timeline.date.timeIntervalSinceReferenceDate
                for snowflake in snowflakes {
                    // Horizontal drift using sine wave
                    let drift = sin(time * 0.5 + snowflake.seed) * 30
                    let x = snowflake.horizontalBase.truncatingRemainder(dividingBy: size.width) + drift
                    // Vertical fall with wrapping
                    let y = ((time * snowflake.speed * 30) + snowflake.seed * 5).truncatingRemainder(dividingBy: Double(size.height + 20)) - 10

                    context.opacity = snowflake.opacity
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: x - snowflake.size / 2,
                            y: y - snowflake.size / 2,
                            width: snowflake.size,
                            height: snowflake.size
                        )),
                        with: .color(.white)
                    )
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private struct Snowflake {
        let seed: Double
        let speed: Double
        let size: CGFloat
        let opacity: Double
        let horizontalBase: Double
    }
}

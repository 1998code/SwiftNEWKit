//
//  SnowfallView.swift
//  SwiftNEW
//
//  Created by Ming on 7/1/2025.
//

import SwiftUI

struct SnowfallView: View {
    @State private var snowflakes = [Snowflake]()
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(snowflakes) { snowflake in
                    Circle()
                        .fill(Color.white)
                        .frame(width: snowflake.size, height: snowflake.size)
                        .position(x: snowflake.x, y: snowflake.y)
                }
            }
            .onAppear {
                for _ in 0..<100 {
                    let snowflake = Snowflake(
                        id: UUID(),
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat.random(in: -geometry.size.height...0),
                        size: CGFloat.random(in: 2...6),
                        speed: CGFloat.random(in: 1...3)
                    )
                    snowflakes.append(snowflake)
                }
            }
            .onReceive(timer) { _ in
                for index in snowflakes.indices {
                    snowflakes[index].y += snowflakes[index].speed
                    if snowflakes[index].y > geometry.size.height {
                        snowflakes[index].y = -snowflakes[index].size
                        snowflakes[index].x = CGFloat.random(in: 0...geometry.size.width)
                    }
                }
            }
        }
    }
}

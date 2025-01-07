//
//  NoiseView.swift
//  SwiftNEW
//
//  Created by Ming on 7/1/2025.
//

import SwiftUI

struct NoiseView: View {
    let size: Int

    var body: some View {
        Canvas { context, size in
            for _ in 0..<self.size {
                let x = Double.random(in: 0..<Double(size.width))
                let y = Double.random(in: 0..<Double(size.height))
#if os(iOS)
                context.fill(Ellipse().path(in: CGRect(x: x, y: y, width: 1, height: 1)), with: .color(Color(.systemBackground).opacity(0.1)))
#elseif os(macOS)
                context.fill(Ellipse().path(in: CGRect(x: x, y: y, width: 1, height: 1)), with: .color(Color(NSColor.windowBackgroundColor).opacity(0.1)))
#endif
            }
        }
        .opacity(0.5)
    }
}

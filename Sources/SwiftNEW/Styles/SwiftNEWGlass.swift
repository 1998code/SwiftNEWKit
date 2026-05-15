//
//  SwiftNEWGlass.swift
//  SwiftNEW
//

import SwiftUI

#if os(iOS) || os(macOS) || os(visionOS)
import SwiftGlass
#endif

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension View {
    @ViewBuilder
    func swiftNEWGlass(radius: CGFloat = 15, color: Color = .clear) -> some View {
        #if os(iOS) || os(macOS) || os(visionOS)
        glass(radius: radius, color: color)
        #else
        background(color)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        #endif
    }
}

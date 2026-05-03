//
//  Color+Extension.swift
//  SwiftNEW
//
//  Created by Ming on 20/02/2026.
//

import SwiftUI

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension Color {
    var adaptedTextColor: Color {
        guard let rgb = rgbComponents else { return .white }
        let luminance = 0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b
        return luminance > 0.5 ? .black : .white
    }

    private var rgbComponents: (r: CGFloat, g: CGFloat, b: CGFloat)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        #if canImport(UIKit)
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r, g, b)
        #elseif canImport(AppKit)
        guard let sRgb = NSColor(self).usingColorSpace(.sRGB) else { return nil }
        sRgb.getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r, g, b)
        #else
        return nil
        #endif
    }
}

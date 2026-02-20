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
        #if canImport(UIKit)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: nil)
        let luminance = 0.299 * r + 0.587 * g + 0.114 * b
        return luminance > 0.5 ? .black : .white
        #elseif canImport(AppKit)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        if let sRgbColor = NSColor(self).usingColorSpace(.sRGB) {
            sRgbColor.getRed(&r, green: &g, blue: &b, alpha: nil)
        }
        let luminance = 0.299 * r + 0.587 * g + 0.114 * b
        return luminance > 0.5 ? .black : .white
        #else
        return .white
        #endif
    }
}

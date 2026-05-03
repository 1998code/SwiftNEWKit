//
//  SwiftNEW+View.swift
//  SwiftNEW
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftVB
import SwiftGlass

#if os(iOS)
import Drops
#endif

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {

    private var iconBadgeSize: CGFloat {
        #if os(tvOS)
        100
        #else
        56
        #endif
    }

    var colorGradient: LinearGradient {
        LinearGradient(
            colors: [color, color.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    @ViewBuilder
    func iconBadge(systemName: String) -> some View {
        switch iconStyle {
        case .filled:
            ZStack {
                colorGradient
                Image(systemName: systemName)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .glass(radius: 15)
            .frame(width: iconBadgeSize, height: iconBadgeSize)
            .cornerRadius(15)
        case .plain:
            Image(systemName: systemName)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: iconBadgeSize, height: iconBadgeSize)
        }
    }

    public var body: some View {
        Group {
            if presentation == .embed {
                sheetContent
            } else {
                Button(action: {
                    #if os(iOS)
                    if showDrop {
                        drop()
                    } else {
                        show = true
                    }
                    #else
                    show = true
                    #endif
                }) {
                    Label(String(localized: String.LocalizationValue(label), bundle: .module), systemImage: labelImage)
                        .frame(
                            width: size == "mini" ? nil : (size == "invisible" ? 0 : platformWidth),
                            height: size == "mini" ? nil : (size == "invisible" ? 0 : 50)
                        )
                        #if os(iOS) && !os(visionOS)
                        .foregroundColor(size == "mini" || size == "invisible" ? color : color.adaptedTextColor)
                        .background(size != "mini" && size != "invisible" ? color : Color.clear)
                        .cornerRadius(15)
                        #endif
                }
                .opacity(size == "invisible" ? 0 : 1)
                .modifier(ConditionalGlassModifier(isEnabled: glass, shadowColor: color))
                .modifier(PresentationModifier(isPresented: $show, presentation: presentation, sheetContent: sheetContent))
            }
        }
    }

    private var platformWidth: CGFloat {
        #if os(tvOS)
        400
        #else
        300
        #endif
    }

    @ViewBuilder
    private func sheetBackground<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        ZStack {
            switch specialEffect {
            case .christmas: SnowfallView()
            case .particles: FloatingParticlesView()
            case .none: EmptyView()
            }
            content()
                #if os(visionOS)
                .padding()
                #endif
        }
        .modifier(SheetBackdropModifier(mesh: mesh, color: $color))
    }

    private var sheetContent: some View {
        sheetBackground {
            sheetCurrent
                .sheet(isPresented: $historySheet) {
                    historySheetContent
                }
        }
    }

    private var historySheetContent: some View {
        sheetBackground {
            sheetHistory
        }
    }
}

private struct SheetBackdropModifier: ViewModifier {
    let mesh: Bool
    @Binding var color: Color

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.4, tvOS 16.4, *) {
            // Sheet-level background fills the entire sheet edge-to-edge.
            if mesh {
                content.presentationBackground { MeshView(color: $color) }
            } else {
                content.presentationBackground(.thinMaterial)
            }
        } else {
            // Older OS / embed: fall back to a full-bleed background.
            if mesh {
                content.background {
                    MeshView(color: $color).ignoresSafeArea()
                }
            } else {
                content.background(.ultraThinMaterial, ignoresSafeAreaEdges: .all)
            }
        }
    }
}

private struct ConditionalGlassModifier: ViewModifier {
    let isEnabled: Bool
    let shadowColor: Color

    func body(content: Content) -> some View {
        if isEnabled {
            content.glass(color: shadowColor.opacity(0.1))
        } else {
            content
        }
    }
}

private struct PresentationModifier<V: View>: ViewModifier {
    @Binding var isPresented: Bool
    let presentation: SwiftNEWPresentation
    let sheetContent: V

    func body(content: Content) -> some View {
        #if os(macOS)
        content.sheet(isPresented: $isPresented) {
            sheetContent
        }
        #else
        if presentation == .fullScreenCover {
            if #available(iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                content.fullScreenCover(isPresented: $isPresented) {
                    sheetContent
                }
            } else {
                content.sheet(isPresented: $isPresented) {
                    sheetContent
                }
            }
        } else {
            content.sheet(isPresented: $isPresented) {
                sheetContent
            }
        }
        #endif
    }
}

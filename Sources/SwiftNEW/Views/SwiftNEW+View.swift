//
//  SwiftNEW+View.swift
//  SwiftNEW
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftVB

#if os(iOS) || os(macOS) || os(visionOS)
import SwiftGlass
#endif

#if os(iOS)
import Drops
#endif

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {

    private var iconBadgeSize: CGFloat {
        #if os(tvOS)
        100
        #else
        64
        #endif
    }

    private var iconBadgeSymbolFont: Font {
        #if os(tvOS)
        .largeTitle
        #else
        .title
        #endif
    }

    private var iconBadgeCornerRadius: CGFloat {
        #if os(tvOS)
        28
        #else
        20
        #endif
    }

    var colorGradient: LinearGradient {
        LinearGradient(
            colors: [color, color.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var defaultIconBackdropGradient: LinearGradient {
        LinearGradient(
            colors: [colorScheme == .dark ? .black : .white, .clear],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var iconGlyphGradient: LinearGradient {
        LinearGradient(
            colors: [color, color.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    @ViewBuilder
    private var defaultIconGlassBackdrop: some View {
        #if os(iOS) && compiler(>=6.2)
        if #available(iOS 26.0, *) {
            Color.clear
                .frame(width: iconBadgeSize, height: iconBadgeSize)
                .glassEffect(.clear.interactive(), in: .rect(cornerRadius: iconBadgeCornerRadius))
        }
        #endif
    }

    @ViewBuilder
    func iconBadge(systemName: String, toSystemName: String? = nil) -> some View {
        switch iconStyle {
        case .filled:
            ZStack {
                colorGradient
                TransitioningSymbol(
                    systemName: systemName,
                    toSystemName: toSystemName,
                    font: iconBadgeSymbolFont,
                    foregroundStyle: Color.white
                )
            }
            .swiftNEWGlass(radius: iconBadgeCornerRadius)
            .frame(width: iconBadgeSize, height: iconBadgeSize)
            .cornerRadius(iconBadgeCornerRadius)
        case .default:
            ZStack {
                defaultIconGlassBackdrop
                defaultIconBackdropGradient
                TransitioningSymbol(
                    systemName: systemName,
                    toSystemName: toSystemName,
                    font: iconBadgeSymbolFont,
                    foregroundStyle: iconGlyphGradient
                )
            }
            .swiftNEWGlass(radius: iconBadgeCornerRadius)
            .frame(width: iconBadgeSize, height: iconBadgeSize)
            .cornerRadius(iconBadgeCornerRadius)
        case .plain:
            TransitioningSymbol(
                systemName: systemName,
                toSystemName: toSystemName,
                font: iconBadgeSymbolFont,
                foregroundStyle: iconGlyphGradient
            )
                .frame(width: iconBadgeSize, height: iconBadgeSize)
        }
    }

    public var body: some View {
        Group {
            if presentation == .embed {
                sheetContent
            } else {
                Button(action: presentReleaseNotes) {
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

    func presentReleaseNotes() {
        #if os(iOS)
        if showDrop {
            drop()
        } else {
            show = true
        }
        #else
        show = true
        #endif
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
        .modifier(SheetBackdropModifier(mesh: mesh, meshStyle: meshStyle, presentation: presentation, color: $color))
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

    #if DEBUG
    var testingHistorySheetContent: some View {
        historySheetContent
    }
    #endif
}

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
private struct TransitioningSymbol<ForegroundStyle: ShapeStyle>: View {
    let systemName: String
    let toSystemName: String?
    let font: Font
    let foregroundStyle: ForegroundStyle

    @State private var displayedSystemName: String

    init(systemName: String, toSystemName: String?, font: Font, foregroundStyle: ForegroundStyle) {
        self.systemName = systemName
        self.toSystemName = toSystemName
        self.font = font
        self.foregroundStyle = foregroundStyle
        _displayedSystemName = State(initialValue: systemName)
    }

    var body: some View {
        symbol
            .task(id: transitionKey) {
                await updateDisplayedSymbol()
            }
    }

    private var transitionKey: String {
        [systemName, toSystemName].compactMap { $0 }.joined(separator: "|")
    }

    @ViewBuilder
    private var symbol: some View {
        let image = Image(systemName: displayedSystemName)
            .font(font)
            .foregroundStyle(foregroundStyle)

        #if compiler(>=6.2)
        if #available(iOS 26.0, watchOS 26.0, macOS 26.0, tvOS 26.0, visionOS 26.0, *) {
            image
                .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.byLayer), options: .repeat(.continuous)))
        } else {
            image
        }
        #else
        image
        #endif
    }

    @MainActor
    private func updateDisplayedSymbol() async {
        displayedSystemName = systemName

        guard let toSystemName, toSystemName != systemName else {
            return
        }

        guard await sleep(milliseconds: 350) else { return }

        while !Task.isCancelled {
            withAnimation(.easeInOut(duration: 0.8)) {
                displayedSystemName = toSystemName
            }

            guard await sleep(milliseconds: 1400) else { return }

            withAnimation(.easeInOut(duration: 0.8)) {
                displayedSystemName = systemName
            }

            guard await sleep(milliseconds: 1400) else { return }
        }
    }

    private func sleep(milliseconds: UInt64) async -> Bool {
        do {
            try await Task.sleep(nanoseconds: milliseconds * 1_000_000)
            return !Task.isCancelled
        } catch {
            return false
        }
    }
}

private struct SheetBackdropModifier: ViewModifier {
    let mesh: Bool
    let meshStyle: SwiftNEWMeshStyle
    let presentation: SwiftNEWPresentation
    @Binding var color: Color

    @ViewBuilder
    func body(content: Content) -> some View {
        if presentation == .embed {
            if mesh {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        MeshView(color: $color, style: meshStyle)
                    }
            } else {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial, ignoresSafeAreaEdges: .all)
            }
        } else if #available(iOS 16.4, tvOS 16.4, *) {
            // Sheet-level background fills the entire sheet edge-to-edge.
            if mesh {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .presentationBackground { MeshView(color: $color, style: meshStyle) }
            } else {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .presentationBackground(.thinMaterial)
            }
        } else { // LCOV_EXCL_START -- Xcode 26 coverage runner cannot execute older OS sheet fallback.
            // Older OS / embed: fall back to a full-bleed background.
            if mesh {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        MeshView(color: $color, style: meshStyle)
                    }
            } else {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial, ignoresSafeAreaEdges: .all)
            }
        } // LCOV_EXCL_STOP
    }
}

private struct ConditionalGlassModifier: ViewModifier {
    let isEnabled: Bool
    let shadowColor: Color

    func body(content: Content) -> some View {
        if isEnabled {
            content.swiftNEWGlass(color: shadowColor.opacity(0.1))
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

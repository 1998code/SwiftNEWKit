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

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {

    private var iconBadgeSize: CGFloat {
        #if os(tvOS)
        100
        #elseif os(watchOS)
        40
        #else
        64
        #endif
    }

    private var iconBadgeSymbolFont: Font {
        #if os(tvOS)
        .largeTitle
        #elseif os(watchOS)
        .body
        #else
        .title
        #endif
    }

    private var iconBadgeCornerRadius: CGFloat {
        #if os(tvOS)
        28
        #elseif os(watchOS)
        12
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
        let colors: [Color] = colorScheme == .dark
            ? [.white.opacity(0.14), .white.opacity(0.035)]
            : [.white, .clear]

        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var iconGlyphGradient: LinearGradient {
        let colors: [Color] = colorScheme == .dark
            ? [color, .white]
            : [color, color.opacity(0.6)]

        return LinearGradient(
            colors: colors,
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
        iconBadge(systemNames: iconSequence(systemName: systemName, toSystemName: toSystemName))
    }

    @ViewBuilder
    func iconBadge(systemNames: [String]) -> some View {
        switch iconStyle {
        case .filled:
            ZStack {
                colorGradient
                TransitioningSymbol(
                    systemNames: systemNames,
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
                    systemNames: systemNames,
                    font: iconBadgeSymbolFont,
                    foregroundStyle: iconGlyphGradient
                )
            }
            .swiftNEWGlass(radius: iconBadgeCornerRadius)
            .frame(width: iconBadgeSize, height: iconBadgeSize)
            .cornerRadius(iconBadgeCornerRadius)
        case .plain:
            TransitioningSymbol(
                systemNames: systemNames,
                font: iconBadgeSymbolFont,
                foregroundStyle: iconGlyphGradient
            )
                .frame(width: iconBadgeSize, height: iconBadgeSize)
        }
    }

    private func iconSequence(systemName: String, toSystemName: String?) -> [String] {
        guard let toSystemName else {
            return [systemName]
        }

        return [systemName, toSystemName]
    }

    public var body: some View {
        let taskID = loadTaskID
        let buttonCornerRadius = resolvedButtonCornerRadius

        return Group {
            if presentation == .embed {
                sheetContent
            } else {
                Button(action: presentReleaseNotes) {
                    Label {
                        Text(String(localized: String.LocalizationValue(label), bundle: .module))
                            .bold()
                    } icon: {
                        Image(systemName: labelImage)
                    }
                        .frame(
                            width: size == "mini" ? nil : (size == "invisible" ? 0 : platformWidth),
                            height: size == "mini" ? nil : (size == "invisible" ? 0 : platformButtonHeight)
                        )
                        #if os(watchOS)
                        .padding(.horizontal, size == "mini" || size == "invisible" ? 0 : 12)
                        .padding(.vertical, size == "mini" || size == "invisible" ? 0 : 8)
                        #endif
                        .modifier(
                            ReleaseNoteButtonLabelModifier(
                                color: color,
                                cornerRadius: buttonCornerRadius,
                                usesCompactStyle: size == "mini" || size == "invisible"
                            )
                        )
                        .contentShape(
                            RoundedRectangle(cornerRadius: buttonCornerRadius, style: .continuous)
                        )
                }
                .opacity(size == "invisible" ? 0 : 1)
                .modifier(
                    ReleaseNoteButtonPlatformStyleModifier(
                        tint: color
                    )
                )
                // The glass chrome is applied *after* the opacity above, so an
                // `opacity(0)` can never hide it — an "invisible" trigger would
                // still leave a translucent glass blob floating at the host's
                // origin (visible on macOS, where the glass routes through
                // SwiftGlass's frosted Material). "invisible" means draw nothing,
                // so skip both glass layers in that case.
                .modifier(
                    ReleaseNoteButtonGlassModifier(
                        tint: color,
                        cornerRadius: buttonCornerRadius,
                        isEnabled: size != "invisible"
                    )
                )
                .modifier(
                    ConditionalGlassModifier(
                        isEnabled: glass && size != "invisible",
                        shadowColor: color,
                        cornerRadius: buttonCornerRadius
                    )
                )
                .modifier(PresentationModifier(isPresented: $show, presentation: presentation, sheetContent: sheetContent))
            }
        }
        .task(id: taskID) {
            await runLoadTask(taskID)
        }
        .onChange(of: show) { isPresented in
            handleShowChange(isPresented)
        }
        .onChange(of: search) { isEnabled in
            if !isEnabled {
                resetSearch()
            }
        }
        .onDisappear {
            cancelActiveDrop()
        }
    }

    func presentReleaseNotes() {
        requestPresentationAfterPreflight()
    }

    private var platformWidth: CGFloat? {
        #if os(tvOS)
        400
        #elseif os(watchOS)
        nil
        #else
        300
        #endif
    }

    private var platformButtonHeight: CGFloat? {
        #if os(watchOS)
        nil
        #else
        50
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
            if shouldPrefetchRemoteUpdate, updateCheckPhase != .resolved {
                sheetUpdateChecking
            } else if availableUpdate != nil {
                sheetUpdate
            } else {
                sheetCurrent
                    .modifier(
                        PresentationModifier(
                            isPresented: $historySheet,
                            presentation: presentation,
                            sheetContent: historySheetContent
                        )
                    )
            }
        }
        .modifier(
            SwiftNEWUpdateDismissalModifier(
                isDisabled: shouldDisableUpdateDismissal
            )
        )
    }

    var shouldDisableUpdateDismissal: Bool {
        !allowsSkippingUpdate
            && (
                availableUpdate != nil
                    || (shouldPrefetchRemoteUpdate && updateCheckPhase != .resolved)
            )
    }

    private var historySheetContent: some View {
        sheetBackground {
            sheetHistory
        }
    }

    #if DEBUG
    var testingSheetContent: some View {
        sheetContent
    }

    var testingHistorySheetContent: some View {
        historySheetContent
    }
    #endif
}

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
private struct TransitioningSymbol<ForegroundStyle: ShapeStyle>: View {
    let systemNames: [String]
    let font: Font
    let foregroundStyle: ForegroundStyle

    @State private var displayedSystemName: String

    init(systemNames: [String], font: Font, foregroundStyle: ForegroundStyle) {
        let normalizedSystemNames = Self.normalized(systemNames)
        self.systemNames = normalizedSystemNames
        self.font = font
        self.foregroundStyle = foregroundStyle
        _displayedSystemName = State(initialValue: normalizedSystemNames[0])
    }

    var body: some View {
        symbol
            .task(id: transitionKey) {
                await updateDisplayedSymbol()
            }
    }

    private var transitionKey: String {
        systemNames.joined(separator: "|")
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
        displayedSystemName = systemNames[0]

        guard systemNames.count > 1 else {
            return
        }

        guard await sleep(milliseconds: 350) else { return }

        var nextIndex = 1
        while !Task.isCancelled {
            withAnimation(.easeInOut(duration: 0.8)) {
                displayedSystemName = systemNames[nextIndex]
            }

            nextIndex = (nextIndex + 1) % systemNames.count

            guard await sleep(milliseconds: 1400) else { return }
        }
    }

    private static func normalized(_ systemNames: [String]) -> [String] {
        var normalizedSystemNames: [String] = []

        for systemName in systemNames where !systemName.isEmpty {
            if normalizedSystemNames.last != systemName {
                normalizedSystemNames.append(systemName)
            }
        }

        return normalizedSystemNames.isEmpty ? ["questionmark"] : normalizedSystemNames
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
                    .modifier(SheetMaterialBackgroundModifier())
            }
        } else if #available(iOS 16.4, watchOS 10.0, macOS 13.3, tvOS 16.4, visionOS 1.0, *) {
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
                    .modifier(SheetMaterialBackgroundModifier())
            }
        } // LCOV_EXCL_STOP
    }
}

private struct SheetMaterialBackgroundModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        #if os(watchOS)
        if #available(watchOS 10.0, *) {
            content.background(.ultraThinMaterial, ignoresSafeAreaEdges: .all)
        } else {
            content.background(Color.black, ignoresSafeAreaEdges: .all)
        }
        #else
        content.background(.ultraThinMaterial, ignoresSafeAreaEdges: .all)
        #endif
    }
}

private struct ReleaseNoteButtonLabelModifier: ViewModifier {
    let color: Color
    let cornerRadius: CGFloat
    let usesCompactStyle: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        #if os(iOS) && !os(visionOS) && compiler(>=6.2)
        if #available(iOS 26.0, *) {
            content
                .foregroundStyle(usesCompactStyle ? color : color.adaptedTextColor)
        } else {
            legacyAppearance(content)
        }
        #elseif os(iOS) && !os(visionOS)
        legacyAppearance(content)
        #elseif os(watchOS)
        legacyAppearance(content)
        #else
        content
        #endif
    }

    private func legacyAppearance(_ content: Content) -> some View {
        content
            .foregroundColor(usesCompactStyle ? color : color.adaptedTextColor)
            .background(usesCompactStyle ? Color.clear : color)
            .cornerRadius(cornerRadius)
    }
}

private struct ReleaseNoteButtonGlassModifier: ViewModifier {
    let tint: Color
    let cornerRadius: CGFloat
    var isEnabled: Bool = true

    @ViewBuilder
    func body(content: Content) -> some View {
        #if os(iOS) && compiler(>=6.2)
        if isEnabled, #available(iOS 26.0, *) {
            content
                .glassEffect(
                    .regular.tint(tint).interactive(),
                    in: .rect(cornerRadius: cornerRadius)
                )
        } else {
            content
        }
        #else
        content
        #endif
    }
}

private struct ConditionalGlassModifier: ViewModifier {
    let isEnabled: Bool
    let shadowColor: Color
    let cornerRadius: CGFloat

    @ViewBuilder
    func body(content: Content) -> some View {
        #if os(watchOS)
        content
        #else
        if isEnabled {
            content.swiftNEWGlass(radius: cornerRadius, color: shadowColor.opacity(0.1))
        } else {
            content
        }
        #endif
    }
}

private struct ReleaseNoteButtonPlatformStyleModifier: ViewModifier {
    let tint: Color

    @ViewBuilder
    func body(content: Content) -> some View {
        #if os(watchOS)
        content
            .buttonStyle(.plain)
            .tint(tint)
        #else
        content
        #endif
    }
}

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
private struct SwiftNEWUpdateDismissalModifier: ViewModifier {
    let isDisabled: Bool

    func body(content: Content) -> some View {
        content.interactiveDismissDisabled(isDisabled)
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

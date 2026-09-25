//
//  ButtonComponents.swift
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

    public var showHistoryButton: some View {
        capsuleSecondaryButton(action: showHistorySheet) {
            #if os(watchOS)
            Text(String(localized: "History", bundle: .module))
            #else
            Text(String(localized: "Show History", bundle: .module))
            #endif
            Image(systemName: "arrow.up.bin")
        }
    }

    @ViewBuilder
    public var searchButton: some View {
        if search {
            capsuleSecondaryButton(action: toggleSearchVisibility) {
                Text(String(localized: "Search", bundle: .module))
                Image(systemName: showSearch ? "xmark.circle" : "magnifyingglass")
            }
        }
    }

    func toggleSearchVisibility() {
        guard search else {
            resetSearch()
            return
        }

        withAnimation { showSearch.toggle() }
        if !showSearch {
            resetSearch()
        }
    }

    func resetSearch() {
        showSearch = false
        searchText = ""
        debouncedSearchText = ""
    }

    func showHistorySheet() {
        historySheet = true
    }

    func dismissCurrentSheet() {
        show = false
    }

    func dismissHistorySheet() {
        historySheet = false
    }

    public var closeCurrentButton: some View {
        primaryActionButton(
            title: String(localized: "Continue", bundle: .module),
            systemImage: "arrow.right.circle.fill",
            macWidth: 200,
            usesTintedGlass: true,
            action: dismissCurrentSheet
        )
    }

    public var closeHistoryButton: some View {
        primaryActionButton(
            title: String(localized: "Return", bundle: .module),
            systemImage: "arrow.down.circle.fill",
            macWidth: 300,
            usesTintedGlass: true,
            action: dismissHistorySheet
        )
    }

    public var updateNowButton: some View {
        primaryActionButton(
            title: resolvedUpdateButtonTitle,
            systemImage: "arrow.up.forward.app.fill",
            macWidth: 300,
            iOSMaxWidth: 380,
            action: openAvailableUpdate
        )
    }

    var resolvedUpdateButtonTitle: String {
        let normalized = updateButtonTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty else {
            return String(localized: "Download Now", bundle: .module)
        }
        return updateButtonTitle
    }

    @ViewBuilder
    public var dismissUpdateButton: some View {
        if allowsSkippingUpdate {
            capsuleSecondaryButton(action: finishUpdatePresentation) {
                Text(String(localized: "Not Now", bundle: .module))
                Image(systemName: "clock")
            }
        }
    }

    public var retryAppStoreLookupButton: some View {
        primaryActionButton(
            title: String(localized: "Try Again", bundle: .module),
            systemImage: "arrow.clockwise",
            macWidth: 300,
            iOSMaxWidth: 380,
            action: retryAppStoreLookup
        )
    }

    var resolvedButtonCornerRadius: CGFloat {
        max(0, buttonCornerRadius)
    }

    /// Text color for filled buttons: the caller's `buttonTextColor`, or black/white picked for contrast with `color`.
    var resolvedButtonTextColor: Color {
        buttonTextColor ?? color.adaptedTextColor
    }

    @ViewBuilder
    private func capsuleSecondaryButton<Label: View>(
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) -> some View {
        #if os(watchOS)
        Button(action: action) {
            capsuleSecondaryButtonLabel(label: label)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background {
                    Capsule()
                        .fill(Color.secondary.opacity(0.16))
                }
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        #elseif os(iOS) && compiler(>=6.2)
        if #available(iOS 26.0, *) {
            Button(action: action) {
                capsuleSecondaryButtonLabel(label: label)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .contentShape(Capsule())
            }
            .buttonStyle(.plain)
            .glassEffect(.clear.interactive(), in: .capsule)
        } else {
            legacyCapsuleSecondaryButton(action: action, label: label)
        }
        #else
        legacyCapsuleSecondaryButton(action: action, label: label)
        #endif
    }

    @ViewBuilder
    private func capsuleSecondaryButtonLabel<Label: View>(
        @ViewBuilder label: () -> Label
    ) -> some View {
        #if os(watchOS)
        HStack(spacing: 4) {
            label()
        }
        .font(.caption2.weight(.semibold))
        #else
        HStack {
            if align == .trailing { Spacer() }
            label()
            if align == .leading { Spacer() }
        }
        .font(.caption)
        #endif
    }

    @ViewBuilder
    private func legacyCapsuleSecondaryButton<Label: View>(
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) -> some View {
        Button(action: action) {
            capsuleSecondaryButtonLabel(label: label)
                .contentShape(Capsule())
        }
        #if !os(visionOS)
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .tint(.secondary)
        #endif
        .swiftNEWGlass(color: .secondary.opacity(0.1))
    }

    private func primaryActionButton(
        title: String,
        systemImage: String,
        macWidth: CGFloat,
        iOSMaxWidth: CGFloat = 300,
        usesTintedGlass: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                if align == .trailing { Spacer() }
                Text(verbatim: title).bold()
                Image(systemName: systemImage)
                if align == .leading { Spacer() }
            }
            .font(.body)
            .padding(.horizontal)
            #if os(watchOS)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            #elseif os(iOS)
            .padding(.vertical, 12)
            .frame(minHeight: 50)
            .frame(maxWidth: .infinity)
            .frame(maxWidth: iOSMaxWidth)
            #elseif os(macOS)
            .frame(width: macWidth, height: 25)
            #endif
            #if os(iOS) && !os(visionOS)
            .modifier(
                PrimaryActionButtonLabelModifier(
                    tint: color,
                    textColor: resolvedButtonTextColor,
                    cornerRadius: resolvedButtonCornerRadius,
                    usesTintedGlass: usesTintedGlass
                )
            )
            #elseif os(tvOS)
            .tint(.white)
            .foregroundColor(buttonTextColor)
            #else
            .foregroundColor(buttonTextColor)
            #endif
            .contentShape(RoundedRectangle(cornerRadius: resolvedButtonCornerRadius, style: .continuous))
        }
        .modifier(
            PrimaryActionButtonGlassModifier(
                tint: color,
                cornerRadius: resolvedButtonCornerRadius,
                isEnabled: usesTintedGlass
            )
        )
        .modifier(PrimaryActionButtonPlatformStyleModifier(tint: color))
        .modifier(
            PrimaryActionButtonFallbackGlassModifier(
                tint: color,
                cornerRadius: resolvedButtonCornerRadius
            )
        )
    }
}

private struct PrimaryActionButtonLabelModifier: ViewModifier {
    let tint: Color
    let textColor: Color
    let cornerRadius: CGFloat
    let usesTintedGlass: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        #if os(iOS) && !os(visionOS) && compiler(>=6.2)
        if #available(iOS 26.0, *), usesTintedGlass {
            content.foregroundStyle(textColor)
        } else {
            legacyAppearance(content)
        }
        #else
        legacyAppearance(content)
        #endif
    }

    private func legacyAppearance(_ content: Content) -> some View {
        content
            .foregroundColor(textColor)
            .background(tint)
            .cornerRadius(cornerRadius)
    }
}

private struct PrimaryActionButtonGlassModifier: ViewModifier {
    let tint: Color
    let cornerRadius: CGFloat
    let isEnabled: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        #if os(iOS) && compiler(>=6.2)
        if #available(iOS 26.0, *), isEnabled {
            content.glassEffect(
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

private struct PrimaryActionButtonPlatformStyleModifier: ViewModifier {
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

private struct PrimaryActionButtonFallbackGlassModifier: ViewModifier {
    let tint: Color
    let cornerRadius: CGFloat

    @ViewBuilder
    func body(content: Content) -> some View {
        #if os(watchOS)
        content
        #else
        content.swiftNEWGlass(radius: cornerRadius, color: tint.opacity(0.1))
        #endif
    }
}

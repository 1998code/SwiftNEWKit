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
        capsuleSecondaryButton(action: { historySheet = true }) {
            Text(String(localized: "Show History", bundle: .module))
            Image(systemName: "arrow.up.bin")
        }
    }

    public var searchButton: some View {
        capsuleSecondaryButton(action: toggleSearchVisibility) {
            Text(String(localized: "Search", bundle: .module))
            Image(systemName: showSearch ? "xmark.circle" : "magnifyingglass")
        }
    }

    func toggleSearchVisibility() {
        withAnimation { showSearch.toggle() }
        if !showSearch {
            searchText = ""
            debouncedSearchText = ""
        }
    }

    public var closeCurrentButton: some View {
        primaryActionButton(
            title: String(localized: "Continue", bundle: .module),
            systemImage: "arrow.right.circle.fill",
            macWidth: 200,
            action: { show = false }
        )
    }

    public var closeHistoryButton: some View {
        primaryActionButton(
            title: String(localized: "Return", bundle: .module),
            systemImage: "arrow.down.circle.fill",
            macWidth: 300,
            action: { historySheet = false }
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

    private var primaryActionButtonCornerRadius: CGFloat {
        #if os(macOS)
        12
        #else
        20
        #endif
    }

    @ViewBuilder
    private func capsuleSecondaryButton<Label: View>(
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) -> some View {
        #if os(iOS) && compiler(>=6.2)
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
        HStack {
            if align == .trailing { Spacer() }
            label()
            if align == .leading { Spacer() }
        }
        .font(.caption)
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
            #if os(iOS)
            .padding(.vertical, 12)
            .frame(minHeight: 50)
            .frame(maxWidth: .infinity)
            .frame(maxWidth: iOSMaxWidth)
            #elseif os(macOS)
            .frame(width: macWidth, height: 25)
            #endif
            #if os(iOS) && !os(visionOS)
            .foregroundColor(color.adaptedTextColor)
            .background(color)
            .cornerRadius(primaryActionButtonCornerRadius)
            #elseif os(tvOS)
            .tint(.white)
            #endif
            .contentShape(RoundedRectangle(cornerRadius: primaryActionButtonCornerRadius, style: .continuous))
        }
        .swiftNEWGlass(radius: primaryActionButtonCornerRadius, color: color.opacity(0.1))
    }
}

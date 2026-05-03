//
//  ButtonComponents.swift
//  SwiftNEW
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftVB
import SwiftGlass

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {

    public var showHistoryButton: some View {
        capsuleSecondaryButton(action: { historySheet = true }) {
            Text(String(localized: "Show History", bundle: .module))
            Image(systemName: "arrow.up.bin")
        }
    }

    public var searchButton: some View {
        capsuleSecondaryButton(action: {
            withAnimation { showSearch.toggle() }
            if !showSearch { searchText = "" }
        }) {
            Text(String(localized: "Search", bundle: .module))
            Image(systemName: showSearch ? "xmark.circle" : "magnifyingglass")
        }
    }

    public var closeCurrentButton: some View {
        primaryActionButton(
            titleKey: "Continue",
            systemImage: "arrow.right.circle.fill",
            macWidth: 200,
            action: { show = false }
        )
    }

    public var closeHistoryButton: some View {
        primaryActionButton(
            titleKey: "Return",
            systemImage: "arrow.down.circle.fill",
            macWidth: 300,
            action: { historySheet = false }
        )
    }

    @ViewBuilder
    private func capsuleSecondaryButton<Label: View>(
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) -> some View {
        Button(action: action) {
            HStack {
                if align == .trailing { Spacer() }
                label()
                if align == .leading { Spacer() }
            }
            .font(.caption)
        }
        #if !os(visionOS)
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .tint(.secondary)
        #endif
        .glass(color: .secondary, shadowColor: color)
    }

    private func primaryActionButton(
        titleKey: String.LocalizationValue,
        systemImage: String,
        macWidth: CGFloat,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                if align == .trailing { Spacer() }
                Text(String(localized: titleKey, bundle: .module)).bold()
                Image(systemName: systemImage)
                if align == .leading { Spacer() }
            }
            .font(.body)
            .padding(.horizontal)
            #if os(iOS)
            .frame(width: 300, height: 50)
            #elseif os(macOS)
            .frame(width: macWidth, height: 25)
            #endif
            #if os(iOS) && !os(visionOS)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(15)
            #elseif os(tvOS)
            .tint(.white)
            #endif
        }
        .glass(color: color.opacity(0.1), shadowColor: color)
    }
}

//
//  CurrentVersionSheet.swift
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

    // MARK: - Current Version Changes View
    public var sheetCurrent: some View {
        #if os(watchOS)
        watchCurrentContent
        #elseif os(tvOS)
        GeometryReader { geometry in
            sheetCurrentContent(maxScrollHeight: geometry.size.height * 0.5)
        }
        #else
        sheetCurrentContent(maxScrollHeight: nil)
        #endif
    }

    #if os(watchOS)
    private var watchCurrentContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: align, spacing: 12) {
                headings
                    .padding(.bottom, 4)

                watchCurrentStateContent
            }
            .padding(.vertical, 8)
        }
    }

    @ViewBuilder
    private var watchCurrentStateContent: some View {
        if let loadErrorMessage {
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(loadErrorMessage)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                Button(action: retryLoadData) {
                    Text(String(localized: "Try Again", bundle: .module))
                }
            }
        } else if loading {
            VStack(spacing: 8) {
                ProgressView()
                Text(String(localized: "Loading...", bundle: .module))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        } else {
            if canSearchCurrentVersion {
                searchButton
            }

            if canSearchCurrentVersion && showSearch {
                searchField
            }

            if visibleCurrentVersionChanges.isEmpty {
                currentVersionEmptyState
                    .padding(.vertical, 4)
            } else {
                currentVersionRows
            }

            if canShowHistory {
                showHistoryButton
                    .padding(.top, 4)
            }
        }
    }
    #endif

    private func sheetCurrentContent(maxScrollHeight: CGFloat?) -> some View {
        VStack(alignment: align) {
            headerTopSpacer

            headings
                .padding(.bottom)

            Spacer()

            if let loadErrorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text(loadErrorMessage)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Button(action: retryLoadData) {
                        Text(String(localized: "Try Again", bundle: .module))
                    }
                }
                .padding()
            } else if loading {
                VStack {
                    Text(String(localized: "Loading...", bundle: .module))
                        .padding(.bottom)
                    ProgressView()
                }
            }
            else {
                if canSearchCurrentVersion && showSearch {
                    searchField
                }
                #if os(macOS)
                currentVersionContent(bottomInset: 0, maxScrollHeight: maxScrollHeight)

                Spacer()

                currentVersionControls
                #else
                ZStack(alignment: .bottom) {
                    currentVersionContent(bottomInset: 196, maxScrollHeight: maxScrollHeight)

                    currentVersionControls
                    .frame(maxWidth: .infinity)
                    .padding(.top, 108)
                    .background { bottomControlBackdrop }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                #endif
            }
        }
        #if os(macOS)
        .padding()
        .frame(width: 600, height: 600)
        #elseif os(tvOS)
        .frame(width: 600)
        #endif
    }

    @ViewBuilder
    private func currentVersionContent(bottomInset: CGFloat, maxScrollHeight: CGFloat?) -> some View {
        if visibleCurrentVersionChanges.isEmpty {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    currentVersionEmptyState
                        .padding(.bottom, bottomInset)
                        .frame(maxWidth: .infinity, alignment: currentVersionEmptyStateFrameAlignment)
                        .frame(minHeight: geometry.size.height)
                }
            }
            #if !os(tvOS)
            .padding(.horizontal, 32)
            #else
            .frame(maxHeight: maxScrollHeight)
            #endif
        } else {
            currentVersionScrollView(bottomInset: bottomInset, maxScrollHeight: maxScrollHeight)
        }
    }

    private func currentVersionScrollView(bottomInset: CGFloat, maxScrollHeight: CGFloat?) -> some View {
        ScrollView(showsIndicators: false) {
            // Breathing room so the first row doesn't sit in the top fade.
            Color.clear.frame(height: 10)

            currentVersionRows

            if bottomInset > 0 {
                // Let the final row scroll above the overlaid controls.
                Color.clear.frame(height: bottomInset)
            }
        }
        // The overlaid controls already fade the bottom when they are shown.
        .softScrollEdges(bottom: bottomInset > 0 ? 0 : 18)
        #if !os(tvOS)
        .frame(maxWidth: 380)
        .padding(.horizontal)
        #elseif os(tvOS)
        .frame(maxHeight: maxScrollHeight)
        #endif
    }

    private var currentVersionControls: some View {
        VStack(spacing: 0) {
            if canShowHistory || canSearchCurrentVersion {
                HStack {
                    if canShowHistory {
                        showHistoryButton
                    }
                    if canSearchCurrentVersion {
                        searchButton
                    }
                }
                .padding(.bottom)
            }

            closeCurrentButton
                .padding(.bottom, 6)
        }
    }

    private var currentVersionEmptyState: some View {
        VStack(alignment: align, spacing: 18) {
            iconBadge(systemName: isShowingNoSearchResults ? "magnifyingglass" : "doc.text")
                .accessibilityHidden(true)

            VStack(alignment: align, spacing: 6) {
                Text(currentVersionEmptyStateTitle)
                    .font(currentVersionEmptyStateTitleFont)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(currentVersionEmptyStateTextAlignment)
                    .fixedSize(horizontal: false, vertical: true)

                Text(currentVersionEmptyStateMessage)
                    .font(currentVersionEmptyStateMessageFont)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(currentVersionEmptyStateTextAlignment)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: currentVersionEmptyStateFrameAlignment)
            .accessibilityElement(children: .combine)
        }
        .frame(maxWidth: 320, alignment: currentVersionEmptyStateFrameAlignment)
    }

    private var currentVersionEmptyStateTitle: String {
        if isShowingNoSearchResults {
            return String(localized: "No Results", bundle: .module)
        }
        return String(localized: "No Release Notes Yet", bundle: .module)
    }

    private var currentVersionEmptyStateMessage: String {
        if isShowingNoSearchResults {
            return String(localized: "Try another search term.", bundle: .module)
        }
        return String(
            localized: "Release notes for this version will appear here when available.",
            bundle: .module
        )
    }

    private var currentVersionEmptyStateTitleFont: Font {
        #if os(watchOS)
        .headline.weight(.semibold)
        #else
        .title3.weight(.semibold)
        #endif
    }

    private var currentVersionEmptyStateMessageFont: Font {
        #if os(watchOS)
        .footnote
        #else
        .subheadline
        #endif
    }

    private var currentVersionEmptyStateFrameAlignment: Alignment {
        if align == .leading { return .leading }
        if align == .trailing { return .trailing }
        return .center
    }

    private var currentVersionEmptyStateTextAlignment: TextAlignment {
        if align == .leading { return .leading }
        if align == .trailing { return .trailing }
        return .center
    }

    @ViewBuilder
    private var currentVersionRows: some View {
        ForEach(items) { item in
            ForEach(visibleCurrentVersionChanges(in: item)) { new in
                releaseRow(new, bodyFont: .footnote, spacing: 2)
            }
        }
    }

    var currentVersionChanges: [Model] {
        items.flatMap { item -> [Model] in
            guard item.version == Bundle.version || item.subVersion == Bundle.version else {
                return []
            }
            return item.new
        }
    }

    var visibleCurrentVersionChanges: [Model] {
        items.flatMap { visibleCurrentVersionChanges(in: $0) }
    }

    func visibleCurrentVersionChanges(in item: Vmodel) -> [Model] {
        guard item.version == Bundle.version || item.subVersion == Bundle.version else {
            return []
        }
        return item.new.filter { matchesSearch($0) }
    }

    var canSearchCurrentVersion: Bool {
        search && !currentVersionChanges.isEmpty
    }

    var canShowHistory: Bool {
        history && items.contains { !$0.new.isEmpty }
    }

    var isShowingNoSearchResults: Bool {
        canSearchCurrentVersion
            && showSearch
            && !debouncedSearchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @ViewBuilder
    private var headerTopSpacer: some View {
        if presentation == .embed {
            EmptyView()
        } else {
            Spacer()
        }
    }

    var searchField: some View {
        #if os(watchOS)
        searchFieldContent
            .padding(.bottom, 4)
        #else
        searchFieldContent
            .padding(.horizontal)
            .frame(maxWidth: 380)
            .padding(.horizontal)
            .padding(.bottom, 8)
        #endif
    }

    @ViewBuilder
    private var searchFieldContent: some View {
        #if os(iOS) && compiler(>=6.2)
        if #available(iOS 26.0, *) {
            searchFieldLabel
                .glassEffect(.clear.interactive(), in: .capsule)
        } else {
            legacySearchFieldLabel
        }
        #else
        legacySearchFieldLabel
        #endif
    }

    private var searchFieldLabel: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField(
                String(localized: "Search", bundle: .module),
                text: Binding(
                    get: { searchText },
                    set: updateSearchText
                )
            )
                .textFieldStyle(.plain)
            if !searchText.isEmpty {
                Button {
                    updateSearchText("")
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        #if os(watchOS)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        #else
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        #endif
    }

    private var legacySearchFieldLabel: some View {
        searchFieldLabel
            .swiftNEWGlass(radius: 20, color: .secondary.opacity(0.1))
    }

    private var bottomControlBackdrop: some View {
        ZStack {
            bottomControlMaterialLayer

            Rectangle()
                .fill(bottomBackdropColor.opacity(0.78))

            LinearGradient(
                colors: [
                    Color.clear,
                    Color.primary.opacity(0.025)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .mask(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: .black.opacity(0.45), location: 0.18),
                    .init(color: .black, location: 0.44),
                    .init(color: .black, location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .ignoresSafeArea(edges: [.horizontal, .bottom])
        .allowsHitTesting(false)
    }

    private var bottomBackdropColor: Color {
        #if os(macOS)
        Color(NSColor.windowBackgroundColor)
        #elseif os(tvOS) || os(watchOS)
        Color.black
        #else
        Color(.systemBackground)
        #endif
    }

    @ViewBuilder
    private var bottomControlMaterialLayer: some View {
        #if os(watchOS)
        if #available(watchOS 10.0, *) {
            Rectangle()
                .fill(.regularMaterial)
        } else {
            Rectangle()
                .fill(Color.black)
        }
        #else
        Rectangle()
            .fill(.regularMaterial)
        #endif
    }

    func updateSearchText(_ newValue: String) {
        searchText = newValue
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            if searchText == newValue {
                debouncedSearchText = newValue
            }
        }
    }

    func matchesSearch(_ new: Model) -> Bool {
        SwiftNEWSearch.matches(
            new,
            query: debouncedSearchText,
            isEnabled: search && showSearch
        )
    }

    func retryLoadData() {
        loadedDataSource = nil
        appStoreLookupRetryRequest = nil
        loadGeneration = nil
        loadedRequest = nil
        loadErrorMessage = nil
        reloadID = UUID()
    }
}

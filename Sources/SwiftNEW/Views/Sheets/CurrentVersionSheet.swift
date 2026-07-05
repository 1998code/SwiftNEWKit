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
        #if os(tvOS)
        GeometryReader { geometry in
            sheetCurrentContent(maxScrollHeight: geometry.size.height * 0.5)
        }
        #else
        sheetCurrentContent(maxScrollHeight: nil)
        #endif
    }

    private func sheetCurrentContent(maxScrollHeight: CGFloat?) -> some View {
        VStack(alignment: align) {
            Spacer()

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
                if showSearch {
                    searchField
                }
                ZStack(alignment: .bottom) {
                    ScrollView(showsIndicators: false) {
                        ForEach(items) { item in
                            if item.version == Bundle.version || item.subVersion == Bundle.version {
                                ForEach(item.new.filter { matchesSearch($0) }) { new in
                                    releaseRow(new, bodyFont: .footnote, spacing: 2)
                                }
                            }
                        }
                        // Bottom inset so last item can scroll past the frosted button area.
                        Color.clear.frame(height: 196)
                    }
                    #if !os(tvOS)
                    .frame(maxWidth: 380)
                    .padding(.horizontal)
                    #elseif os(tvOS)
                    .frame(maxHeight: maxScrollHeight)
                    #endif

                    VStack(spacing: 0) {
                        if history {
                            HStack {
                                showHistoryButton
                                searchButton
                            }
                            .padding(.bottom)
                        } else {
                            searchButton
                                .padding(.bottom)
                        }

                        closeCurrentButton
                            .padding(.bottom, 6)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 88)
                    .background { bottomControlBackdrop }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task(id: data) {
            loadData()
        }
        #if os(macOS)
        .padding()
        .frame(width: 600, height: 600)
        #elseif os(tvOS)
        .frame(width: 600)
        #endif
    }

    private var searchField: some View {
        searchFieldContent
            .padding(.horizontal)
            .frame(maxWidth: 380)
            .padding(.horizontal)
            .padding(.bottom, 8)
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
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    private var legacySearchFieldLabel: some View {
        searchFieldLabel
            .swiftNEWGlass(radius: 20, color: .secondary.opacity(0.1))
    }

    private var bottomControlBackdrop: some View {
        ZStack {
            Rectangle()
                .fill(.regularMaterial)

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
                    .init(color: .black.opacity(0.45), location: 0.26),
                    .init(color: .black, location: 0.52),
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
        #elseif os(tvOS)
        Color.black
        #else
        Color(.systemBackground)
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
        SwiftNEWSearch.matches(new, query: debouncedSearchText, isEnabled: showSearch)
    }

    func retryLoadData() {
        loadedDataSource = nil
        loadData()
    }
}

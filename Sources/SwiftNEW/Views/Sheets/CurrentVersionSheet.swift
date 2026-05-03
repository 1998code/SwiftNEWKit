//
//  CurrentVersionSheet.swift
//  SwiftNEW
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftVB
import SwiftGlass

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {

    // MARK: - Current Version Changes View
    public var sheetCurrent: some View {
        VStack(alignment: align) {
            Spacer()

            headings
                .padding(.bottom)

            Spacer()

            if loading {
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
                ScrollView(showsIndicators: false) {
                    ForEach(items, id: \.self) { item in
                        if item.version == Bundle.version || item.subVersion == Bundle.version {
                            ForEach(item.new.filter { matchesSearch($0) }, id: \.self) { new in
                                releaseRow(new, bodyFont: .footnote, spacing: 2)
                                    .padding(.leading)
                                    .padding(.bottom)
                            }
                        }
                    }
                }
                #if !os(tvOS)
                .frame(maxWidth: 380)
                .padding(.horizontal)
                .frame(maxHeight: .infinity)
                #elseif !os(macOS)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
                #endif
                .mask(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .black, location: 0.0),
                            .init(color: .black, location: 0.9),
                            .init(color: .clear, location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }

            Spacer()

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
                .padding(.bottom)
        }
        .onAppear {
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
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField(String(localized: "Search", bundle: .module), text: $searchText)
                .textFieldStyle(.plain)
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Capsule().fill(Color.secondary.opacity(0.15)))
        .frame(maxWidth: 380)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    func matchesSearch(_ new: Model) -> Bool {
        guard showSearch, !searchText.isEmpty else { return true }
        return new.title.localizedCaseInsensitiveContains(searchText)
            || new.subtitle.localizedCaseInsensitiveContains(searchText)
            || new.body.localizedCaseInsensitiveContains(searchText)
    }
}

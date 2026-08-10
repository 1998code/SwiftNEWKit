//
//  HistorySheet.swift
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

    // MARK: - History List View
    public var sheetHistory: some View {
        #if os(watchOS)
        watchHistoryContent
        #elseif os(tvOS)
        GeometryReader { geometry in
            sheetHistoryContent(maxScrollHeight: geometry.size.height * 0.5)
        }
        #else
        sheetHistoryContent(maxScrollHeight: nil)
        #endif
    }

    #if os(watchOS)
    private var watchHistoryContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: align, spacing: 12) {
                Text(String(localized: "History", bundle: .module))
                    .font(.headline.weight(.bold))
                    .frame(maxWidth: .infinity)

                if search {
                    searchButton
                }

                if search && showSearch {
                    searchField
                }

                ForEach(items) { item in
                    historySection(for: item)
                }

                closeHistoryButton
                    .padding(.top, 4)
            }
            .padding(.vertical, 8)
        }
    }
    #endif

    private func sheetHistoryContent(maxScrollHeight: CGFloat?) -> some View {
        VStack(alignment: align) {
            Spacer()

            Text(String(localized: "History", bundle: .module))
                .bold().font(.largeTitle)
                .padding(.top)

            Spacer()

            if search && showSearch {
                searchField
            }

            ScrollView(showsIndicators: false) {
                // Breathing room so the first row doesn't sit in the top fade.
                Color.clear.frame(height: 10)

                ForEach(items) { item in
                    historySection(for: item)
                }
            }
            .softScrollEdges()
            #if !os(tvOS)
            .frame(maxWidth: 380)
            .padding(.horizontal)
            #elseif os(tvOS)
            .frame(maxHeight: maxScrollHeight)
            #endif

            Spacer()

            historyControls
        }
        #if os(macOS)
        .padding()
        .frame(width: 600, height: 600)
        #elseif os(tvOS)
        .frame(width: 600)
        #endif
    }

    @ViewBuilder
    private func historySection(for item: Vmodel) -> some View {
        let matchingChanges = matchingHistoryChanges(in: item)

        if !matchingChanges.isEmpty {
            ZStack {
                colorGradient
                Text(item.version).bold().font(.headline)
                    .foregroundColor(color.adaptedTextColor)
            }
            .swiftNEWGlass(radius: 12, color: color)
            .frame(width: 96, height: 32)
            .cornerRadius(12)
            .padding(.bottom, 10)

            ForEach(matchingChanges) { new in
                releaseRow(new, bodyFont: .caption)
            }
        }
    }

    func matchingHistoryChanges(in item: Vmodel) -> [Model] {
        item.new.filter { matchesSearch($0) }
    }

    private var historyControls: some View {
        VStack(spacing: 0) {
            if search {
                searchButton
                    .padding(.bottom)
            }

            closeHistoryButton
                .padding(.bottom)
        }
    }
}

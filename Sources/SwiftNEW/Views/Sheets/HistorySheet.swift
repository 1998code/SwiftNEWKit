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
        #if os(tvOS)
        GeometryReader { geometry in
            sheetHistoryContent(maxScrollHeight: geometry.size.height * 0.5)
        }
        #else
        sheetHistoryContent(maxScrollHeight: nil)
        #endif
    }

    private func sheetHistoryContent(maxScrollHeight: CGFloat?) -> some View {
        VStack(alignment: align) {
            Spacer()

            Text(String(localized: "History", bundle: .module))
                .bold().font(.largeTitle)
                .padding(.top)

            Spacer()

            ScrollView(showsIndicators: false) {
                ForEach(items) { item in
                    ZStack {
                        colorGradient
                        Text(item.version).bold().font(.headline)
                            .foregroundColor(color.adaptedTextColor)
                    }
                    .swiftNEWGlass(radius: 12, color: color)
                    .frame(width: 96, height: 32)
                    .cornerRadius(12)
                    .padding(.bottom, 10)

                    ForEach(item.new) { new in
                        releaseRow(new, bodyFont: .caption)
                    }
                }
            }
            #if !os(tvOS)
            .frame(maxWidth: 380)
            .padding(.horizontal)
            #elseif os(tvOS)
            .frame(maxHeight: maxScrollHeight)
            #endif

            Spacer()

            closeHistoryButton
                .padding(.bottom)
        }
        #if os(macOS)
        .padding()
        .frame(width: 600, height: 600)
        #elseif os(tvOS)
        .frame(width: 600)
        #endif
    }
}

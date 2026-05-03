//
//  HistorySheet.swift
//  SwiftNEW
//
//  Created by Ming on 11/6/2022.
//

import SwiftGlass
import SwiftUI
import SwiftVB

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {

    // MARK: - History List View
    public var sheetHistory: some View {
        VStack(alignment: align) {
            Spacer()

            Text(String(localized: "History", bundle: .module))
                .bold().font(.largeTitle)
                .padding(.top)

            Spacer()

            ScrollView(showsIndicators: false) {
                ForEach(items, id: \.self) { item in
                    ZStack {
                        colorGradient
                        Text(item.version).bold().font(.title2)
                            .foregroundColor(color.adaptedTextColor)
                    }
                    .glass(radius: 15, color: color)
                    .frame(width: 120, height: 40)
                    .cornerRadius(15)
                    .padding(.bottom)

                    ForEach(item.new, id: \.self) { new in
                        releaseRow(new, bodyFont: .caption)
                            .padding(.leading)
                            .padding(.bottom)
                    }
                }
            }
            #if !os(tvOS)
            .frame(maxWidth: 380)
            .padding(.horizontal)
            #elseif !os(macOS)
            .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
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

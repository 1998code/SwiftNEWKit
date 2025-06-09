//
//  HeaderView.swift
//  SwiftNEW
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftVB
import SwiftGlass

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {
    
    #if os(iOS)
    public var headings: some View {
        HStack {
            if align == .leading {
                AppIconView()
                    .padding(.leading, -8)
                    .padding(.trailing, 8)
            }
            VStack(alignment: align) {
                if align == .center {
                    AppIconView()
                }
                Text(String(localized: "What's New in", bundle: .module))
                    .bold().font(.largeTitle)
                Text("\(String(localized: "Version", bundle: .module)) \(Bundle.versionBuild)")
                    .bold().font(.title).foregroundColor(.secondary)
            }
            if align == .trailing {
                AppIconView()
            }
        }
    }
    #elseif os(macOS) || os(visionOS) || os(tvOS)
    public var headings: some View {
        VStack {
            Text(String(localized: "What's New in", bundle: .module))
                .bold().font(.largeTitle)
            Text("\(String(localized: "Version", bundle: .module)) \(Bundle.versionBuild)")
                .bold().font(.title).foregroundColor(.secondary)
        }
    }
    #endif
}

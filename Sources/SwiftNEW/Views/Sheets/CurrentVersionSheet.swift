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
                ScrollView(showsIndicators: false) {
                    ForEach(items, id: \.self) { item in
                        if item.version == Bundle.version || item.subVersion == Bundle.version {
                            ForEach(item.new, id: \.self) { new in
                                HStack {
                                    if align == .leading || align == .center {
                                        ZStack {
                                            color
                                            Image(systemName: new.icon)
                                                .foregroundColor(.white)
                                        }.glass(radius: 15, shadowColor: color)
                                        #if !os(tvOS)
                                        .frame(width: 50, height: 50)
                                        #else
                                        .frame(width: 100, height: 100)
                                        #endif
                                        .cornerRadius(15)
                                        .padding(.trailing)
                                    } else {
                                        Spacer()
                                    }
                                    
                                    VStack(alignment: align == .trailing ? .trailing : .leading) {
                                        Text(new.title).font(.headline).lineLimit(1)
                                        Text(new.subtitle).font(.subheadline).foregroundColor(.secondary).lineLimit(1)
                                        Text(new.body).font(.caption).foregroundColor(.secondary).lineLimit(2)
                                    }
                                    
                                    if align == .trailing {
                                        ZStack {
                                            color
                                            Image(systemName: new.icon)
                                                .foregroundColor(.white)
                                        }.glass(radius: 15, shadowColor: color)
                                        #if !os(tvOS)
                                        .frame(width: 50, height: 50)
                                        #else
                                        .frame(width: 100, height: 100)
                                        #endif
                                        .cornerRadius(15)
                                        .padding(.trailing)
                                    } else {
                                        Spacer()
                                    }
                                }.padding(.bottom)
                            }
                        }
                    }
                }
                #if !os(tvOS)
                .frame(width: 300)
                #elseif !os(macOS)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
                #endif
            }
            
            Spacer()

            if history {
                showHistoryButton
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
}

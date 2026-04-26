//
//  SwiftNEW+View.swift
//  SwiftNEW
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftVB
import SwiftGlass

#if os(iOS)
import Drops
#endif

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {

    @ViewBuilder
    func iconBadge(systemName: String) -> some View {
        switch iconStyle {
        case .filled:
            ZStack {
                color
                Image(systemName: systemName)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .glass(radius: 15, shadowColor: color)
            #if !os(tvOS)
            .frame(width: 56, height: 56)
            #else
            .frame(width: 100, height: 100)
            #endif
            .cornerRadius(15)
        case .plain:
            Image(systemName: systemName)
                .font(.title2)
                .foregroundColor(color)
                #if !os(tvOS)
                .frame(width: 56, height: 56)
                #else
                .frame(width: 100, height: 100)
                #endif
        }
    }

    public var body: some View {
        Group {
            if presentation == .embed {
                sheetContent
            } else {
                Button(action: {
                    #if os(iOS)
                    if showDrop {
                        drop()
                    } else {
                        show = true
                    }
                    #else
                    show = true
                    #endif
                }) {
                    Label(String(localized: String.LocalizationValue(label), bundle: .module), systemImage: labelImage)
                        .frame(
                            width: size == "mini" ? nil : (size == "invisible" ? 0 : platformWidth),
                            height: size == "mini" ? nil : (size == "invisible" ? 0 : 50)
                        )
                        #if os(iOS) && !os(visionOS)
                        .foregroundColor(size == "mini" || size == "invisible" ? color : color.adaptedTextColor)
                        .background(size != "mini" && size != "invisible" ? color : Color.clear)
                        .cornerRadius(15)
                        #endif
                }
                .opacity(size == "invisible" ? 0 : 1)
                .modifier(ConditionalGlassModifier(isEnabled: glass, shadowColor: color))
                .modifier(PresentationModifier(isPresented: $show, presentation: presentation, sheetContent: sheetContent))
            }
        }
    }
    
    private var platformWidth: CGFloat {
        #if os(tvOS)
        400
        #else
        300
        #endif
    }
    
    private var sheetContent: some View {
        ZStack {
            if mesh {
                MeshView(color: $color)
            }
            if specialEffect == .christmas {
                SnowfallView()
            } else if specialEffect == .particles {
                FloatingParticlesView()
            }
            sheetCurrent
                .sheet(isPresented: $historySheet) {
                    historySheetContent
                }
                #if os(visionOS)
                .padding()
                #endif
        }
        .background(.ultraThinMaterial)
        .modifier(PresentationBackgroundModifier())
    }
    
    private var historySheetContent: some View {
        ZStack {
            if mesh {
                MeshView(color: $color)
            }
            if specialEffect == .christmas {
                SnowfallView()
            } else if specialEffect == .particles {
                FloatingParticlesView()
            }
            sheetHistory
                #if os(visionOS)
                .padding()
                #endif
        }
        .background(.ultraThinMaterial)
        .modifier(PresentationBackgroundModifier())
    }
}

private struct PresentationBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.4, tvOS 16.4, *) {
            content.presentationBackground(.thinMaterial)
        } else {
            content
        }
    }
}

private struct ConditionalGlassModifier: ViewModifier {
    let isEnabled: Bool
    let shadowColor: Color
    
    func body(content: Content) -> some View {
        if isEnabled {
            content.glass(shadowColor: shadowColor)
        } else {
            content
        }
    }
}

private struct PresentationModifier<V: View>: ViewModifier {
    @Binding var isPresented: Bool
    let presentation: SwiftNEWPresentation
    let sheetContent: V

    func body(content: Content) -> some View {
        #if os(macOS)
        content.sheet(isPresented: $isPresented) {
            sheetContent
        }
        #else
        if presentation == .fullScreenCover {
            if #available(iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                content.fullScreenCover(isPresented: $isPresented) {
                    sheetContent
                }
            } else {
                content.sheet(isPresented: $isPresented) {
                    sheetContent
                }
            }
        } else {
            content.sheet(isPresented: $isPresented) {
                sheetContent
            }
        }
        #endif
    }
}

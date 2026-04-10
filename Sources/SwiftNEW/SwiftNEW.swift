//
//  SwiftNEW.swift
//  SwiftNEW
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftVB

#if os(iOS)
import Drops
#endif

// Setup presentation type of the SwiftNEW view
public enum SwiftNEWPresentation {
    case sheet
    case fullScreenCover
    case embed
}

// Special Effect (e.g. Christmas snow)
public enum SwiftNEWSpecialEffect {
    case none
    case christmas
}
 
@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
public struct SwiftNEW: View {
    @AppStorage("version") var version = 1.0
    @AppStorage("build") var build: Double = 1
    
    @State var items: [Vmodel] = []
    @State var loading = true
    @State var historySheet: Bool = false
    
    @Binding var show: Bool
    @Binding var align: HorizontalAlignment
    @Binding var color: Color
    @Binding var size: String
    @Binding var label: String
    @Binding var labelImage: String
    @Binding var history: Bool
    @Binding var data: String
    @Binding var showDrop: Bool
    @Binding var mesh: Bool
    @Binding var specialEffect: SwiftNEWSpecialEffect
    @Binding var glass: Bool
    @Binding var presentation: SwiftNEWPresentation
    @Binding var showBuild: Bool
    
    #if os(iOS) || os(visionOS)
    public init(
        show: Binding<Bool>,
        align: HorizontalAlignment? = .center,
        color: Color? = .accentColor,
        size: String? = "simple",
        label: String? = "Show Release Note",
        labelImage: String? = "arrow.up.circle.fill",
        history: Bool? = true,
        data: String? = "data",
        showDrop: Bool? = false,
        mesh: Bool? = true,
        specialEffect: SwiftNEWSpecialEffect? = .none,
        glass: Bool? = true,
        presentation: SwiftNEWPresentation? = .sheet,
        showBuild: Bool? = true
    ) {
        _show = show
        _align = .constant(align ?? .center)
        _color = .constant(color ?? Color.accentColor)
        _size = .constant(size ?? "simple")
        _label = .constant(label ?? "Show Release Note")
        _labelImage = .constant(labelImage ?? "arrow.up.circle.fill")
        _history = .constant(history ?? true)
        _data = .constant(data ?? "data")
        _showDrop = .constant(showDrop ?? false)
        _mesh = .constant(mesh ?? true)
        _specialEffect = .constant(specialEffect ?? .none)
        _glass = .constant(glass ?? true)
        _presentation = .constant(presentation ?? .sheet)
        _showBuild = .constant(showBuild ?? true)
        compareVersion()
    }
    
    @_disfavoredOverload
    public init(
        show: Binding<Bool>,
        align: Binding<HorizontalAlignment>? = .constant(.center),
        color: Binding<Color>? = .constant(Color.accentColor),
        size: Binding<String>? = .constant("simple"),
        label: Binding<String>? = .constant("Show Release Note"),
        labelImage: Binding<String>? = .constant("arrow.up.circle.fill"),
        history: Binding<Bool>? = .constant(true),
        data: Binding<String>? = .constant("data"),
        showDrop: Binding<Bool>? = .constant(false),
        mesh: Binding<Bool>? = .constant(true),
        specialEffect: Binding<SwiftNEWSpecialEffect>? = .constant(.none),
        glass: Binding<Bool>? = .constant(true),
        presentation: Binding<SwiftNEWPresentation>? = .constant(.sheet),
        showBuild: Binding<Bool>? = .constant(true)
    ) {
        _show = show
        _align = align ?? .constant(.center)
        _color = color ?? .constant(Color.accentColor)
        _size = size ?? .constant("simple")
        _label = label ?? .constant("Show Release Note")
        _labelImage = labelImage ?? .constant("arrow.up.circle.fill")
        _history = history ?? .constant(true)
        _data = data ?? .constant("data")
        _showDrop = showDrop ?? .constant(false)
        _mesh = mesh ?? .constant(true)
        _specialEffect = specialEffect ?? .constant(.none)
        _glass = glass ?? .constant(true)
        _presentation = presentation ?? .constant(.sheet)
        _showBuild = showBuild ?? .constant(true)
        compareVersion()
    }
    #elseif os(macOS)
    public init(
        show: Binding<Bool>,
        align: HorizontalAlignment? = .center,
        color: Color? = .accentColor,
        size: String? = "simple",
        label: String? = "Show Release Note",
        labelImage: String? = "arrow.up.circle.fill",
        history: Bool? = true,
        data: String? = "data",
        showDrop: Bool? = false,
        mesh: Bool? = true,
        specialEffect: SwiftNEWSpecialEffect? = .none,
        glass: Bool? = true,
        presentation: SwiftNEWPresentation? = .sheet,
        showBuild: Bool? = true
    ) {
        _show = show
        _align = .constant(align ?? .center)
        _color = .constant(color ?? Color.accentColor)
        _size = .constant(size ?? "simple")
        _label = .constant(label ?? "Show Release Note")
        _labelImage = .constant(labelImage ?? "arrow.up.circle.fill")
        _history = .constant(history ?? true)
        _data = .constant(data ?? "data")
        _showDrop = .constant(showDrop ?? false)
        _mesh = .constant(mesh ?? true)
        _specialEffect = .constant(specialEffect ?? .none)
        _glass = .constant(glass ?? true)
        _presentation = .constant(presentation ?? .sheet)
        _showBuild = .constant(showBuild ?? true)
        compareVersion()
    }
    @_disfavoredOverload
    public init(
        show: Binding<Bool>,
        align: Binding<HorizontalAlignment>? = .constant(.center),
        color: Binding<Color>? = .constant(Color.accentColor),
        size: Binding<String>? = .constant("simple"),
        label: Binding<String>? = .constant("Show Release Note"),
        labelImage: Binding<String>? = .constant("arrow.up.circle.fill"),
        history: Binding<Bool>? = .constant(true),
        data: Binding<String>? = .constant("data"),
        showDrop: Binding<Bool>? = .constant(false),
        mesh: Binding<Bool>? = .constant(true),
        specialEffect: Binding<SwiftNEWSpecialEffect>? = .constant(.none),
        glass: Binding<Bool>? = .constant(true),
        presentation: Binding<SwiftNEWPresentation>? = .constant(.sheet),
        showBuild: Binding<Bool>? = .constant(true)
    ) {
        _show = show
        _align = align ?? .constant(.center)
        _color = color ?? .constant(Color.accentColor)
        _size = size ?? .constant("simple")
        _label = label ?? .constant("Show Release Note")
        _labelImage = labelImage ?? .constant("arrow.up.circle.fill")
        _history = history ?? .constant(true)
        _data = data ?? .constant("data")
        _showDrop = showDrop ?? .constant(false)
        _mesh = mesh ?? .constant(true)
        _specialEffect = specialEffect ?? .constant(.none)
        _glass = glass ?? .constant(true)
        _presentation = presentation ?? .constant(.sheet)
        _showBuild = showBuild ?? .constant(true)
        compareVersion()
    }
    #else
    public init(
        show: Binding<Bool>,
        align: HorizontalAlignment? = .center,
        color: Color? = .accentColor,
        size: String? = "simple",
        label: String? = "Show Release Note",
        labelImage: String? = "arrow.up.circle.fill",
        history: Bool? = true,
        data: String? = "data",
        showDrop: Bool? = false,
        mesh: Bool? = true,
        specialEffect: SwiftNEWSpecialEffect? = .none,
        glass: Bool? = true,
        presentation: SwiftNEWPresentation? = .sheet,
        showBuild: Bool? = true
    ) {
        _show = show
        _align = .constant(align ?? .center)
        _color = .constant(color ?? Color.accentColor)
        _size = .constant(size ?? "simple")
        _label = .constant(label ?? "Show Release Note")
        _labelImage = .constant(labelImage ?? "arrow.up.circle.fill")
        _history = .constant(history ?? true)
        _data = .constant(data ?? "data")
        _showDrop = .constant(showDrop ?? false)
        _mesh = .constant(mesh ?? true)
        _specialEffect = .constant(specialEffect ?? .none)
        _glass = .constant(glass ?? true)
        _presentation = .constant(presentation ?? .sheet)
        _showBuild = .constant(showBuild ?? true)
        compareVersion()
    }
    @_disfavoredOverload
    public init(
        show: Binding<Bool>,
        align: Binding<HorizontalAlignment>? = .constant(.center),
        color: Binding<Color>? = .constant(Color.accentColor),
        size: Binding<String>? = .constant("simple"),
        label: Binding<String>? = .constant("Show Release Note"),
        labelImage: Binding<String>? = .constant("arrow.up.circle.fill"),
        history: Binding<Bool>? = .constant(true),
        data: Binding<String>? = .constant("data"),
        showDrop: Binding<Bool>? = .constant(false),
        mesh: Binding<Bool>? = .constant(true),
        specialEffect: Binding<SwiftNEWSpecialEffect>? = .constant(.none),
        glass: Binding<Bool>? = .constant(true),
        presentation: Binding<SwiftNEWPresentation>? = .constant(.sheet),
        showBuild: Binding<Bool>? = .constant(true)
    ) {
        _show = show
        _align = align ?? .constant(.center)
        _color = color ?? .constant(Color.accentColor)
        _size = size ?? .constant("simple")
        _label = label ?? .constant("Show Release Note")
        _labelImage = labelImage ?? .constant("arrow.up.circle.fill")
        _history = history ?? .constant(true)
        _data = data ?? .constant("data")
        _showDrop = showDrop ?? .constant(false)
        _mesh = mesh ?? .constant(true)
        _specialEffect = specialEffect ?? .constant(.none)
        _glass = glass ?? .constant(true)
        _presentation = presentation ?? .constant(.sheet)
        _showBuild = showBuild ?? .constant(true)
        compareVersion()
    }
    #endif
}

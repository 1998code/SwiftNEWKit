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
    case particles
}

// Heading subtitle style — controls the second line under "What's New in"
public enum SwiftNEWHeadingStyle {
    case version       // "Version 6.4" / "Version 6.4 (19)"
    case versionOnly   // "6.4" / "6.4 (19)"
    case appName       // "{App Name}"
}

// Icon style for each release-note row
public enum SwiftNEWIconStyle {
    case filled     // colored backdrop, white glyph
    case `default` // white/black-to-clear gradient backdrop, glyph uses theme color (default)
    case plain      // no backdrop, glyph uses theme color
}

// Mesh gradient behavior
public enum SwiftNEWMeshStyle: Equatable {
    case still
    case liquid
}

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
public struct SwiftNEW: View {
    @AppStorage("swiftnew.version") var version = ""
    @AppStorage("swiftnew.build") var build = ""
    @Environment(\.colorScheme) var colorScheme

    @State var items: [Vmodel] = []
    @State var loading = true
    @State var loadErrorMessage: String?
    @State var loadedDataSource: String?
    @State var historySheet: Bool = false
    @State var showSearch: Bool = false
    @State var searchText: String = ""
    @State var debouncedSearchText: String = ""

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
    @Binding var meshStyle: SwiftNEWMeshStyle
    @Binding var specialEffect: SwiftNEWSpecialEffect
    @Binding var glass: Bool
    @Binding var presentation: SwiftNEWPresentation
    @Binding var showBuild: Bool
    @Binding var headingStyle: SwiftNEWHeadingStyle
    @Binding var headingPrefix: String
    @Binding var iconStyle: SwiftNEWIconStyle
    var dataBundle: Bundle = .main

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
        meshStyle: SwiftNEWMeshStyle? = .still,
        specialEffect: SwiftNEWSpecialEffect? = SwiftNEWSpecialEffect.none,
        glass: Bool? = true,
        presentation: SwiftNEWPresentation? = .sheet,
        showBuild: Bool? = true,
        headingStyle: SwiftNEWHeadingStyle? = .version,
        headingPrefix: String? = "What's New in",
        iconStyle: SwiftNEWIconStyle? = .default
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
        _meshStyle = .constant(meshStyle ?? .still)
        _specialEffect = .constant(specialEffect ?? .none)
        _glass = .constant(glass ?? true)
        _presentation = .constant(presentation ?? .sheet)
        _showBuild = .constant(showBuild ?? true)
        _headingStyle = .constant(headingStyle ?? .version)
        _headingPrefix = .constant(headingPrefix ?? "What's New in")
        _iconStyle = .constant(iconStyle ?? .default)
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
        meshStyle: Binding<SwiftNEWMeshStyle>? = .constant(.still),
        specialEffect: Binding<SwiftNEWSpecialEffect>? = .constant(.none),
        glass: Binding<Bool>? = .constant(true),
        presentation: Binding<SwiftNEWPresentation>? = .constant(.sheet),
        showBuild: Binding<Bool>? = .constant(true),
        headingStyle: Binding<SwiftNEWHeadingStyle>? = .constant(.version),
        headingPrefix: Binding<String>? = .constant("What's New in"),
        iconStyle: Binding<SwiftNEWIconStyle>? = .constant(.default)
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
        _meshStyle = meshStyle ?? .constant(.still)
        _specialEffect = specialEffect ?? .constant(.none)
        _glass = glass ?? .constant(true)
        _presentation = presentation ?? .constant(.sheet)
        _showBuild = showBuild ?? .constant(true)
        _headingStyle = headingStyle ?? .constant(.version)
        _headingPrefix = headingPrefix ?? .constant("What's New in")
        _iconStyle = iconStyle ?? .constant(.default)
        compareVersion()
    }
}

#if DEBUG
@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {
    init(
        testingShow: Bool = false,
        items: [Vmodel] = [],
        loading: Bool = true,
        loadErrorMessage: String? = nil,
        loadedDataSource: String? = nil,
        historySheet: Bool = false,
        showSearch: Bool = false,
        searchText: String = "",
        debouncedSearchText: String = "",
        align: HorizontalAlignment = .center,
        color: Color = .accentColor,
        size: String = "simple",
        label: String = "Show Release Note",
        labelImage: String = "arrow.up.circle.fill",
        history: Bool = true,
        data: String = "data",
        showDrop: Bool = false,
        mesh: Bool = true,
        meshStyle: SwiftNEWMeshStyle = .still,
        specialEffect: SwiftNEWSpecialEffect = .none,
        glass: Bool = true,
        presentation: SwiftNEWPresentation = .sheet,
        showBuild: Bool = true,
        headingStyle: SwiftNEWHeadingStyle = .version,
        headingPrefix: String = "What's New in",
        iconStyle: SwiftNEWIconStyle = .default,
        dataBundle: Bundle = .main
    ) {
        _version = AppStorage(wrappedValue: "", "swiftnew.version")
        _build = AppStorage(wrappedValue: "", "swiftnew.build")
        _items = State(initialValue: items)
        _loading = State(initialValue: loading)
        _loadErrorMessage = State(initialValue: loadErrorMessage)
        _loadedDataSource = State(initialValue: loadedDataSource)
        _historySheet = State(initialValue: historySheet)
        _showSearch = State(initialValue: showSearch)
        _searchText = State(initialValue: searchText)
        _debouncedSearchText = State(initialValue: debouncedSearchText)
        _show = .constant(testingShow)
        _align = .constant(align)
        _color = .constant(color)
        _size = .constant(size)
        _label = .constant(label)
        _labelImage = .constant(labelImage)
        _history = .constant(history)
        _data = .constant(data)
        _showDrop = .constant(showDrop)
        _mesh = .constant(mesh)
        _meshStyle = .constant(meshStyle)
        _specialEffect = .constant(specialEffect)
        _glass = .constant(glass)
        _presentation = .constant(presentation)
        _showBuild = .constant(showBuild)
        _headingStyle = .constant(headingStyle)
        _headingPrefix = .constant(headingPrefix)
        _iconStyle = .constant(iconStyle)
        self.dataBundle = dataBundle
    }
}
#endif

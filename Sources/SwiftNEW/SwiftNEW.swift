//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftVB

#if os(iOS)
import Drops
#endif
 
@available(iOS 15, watchOS 8.0, macOS 12.0, *)
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
    @Binding var labelColor: Color
    @Binding var label: String
    @Binding var labelImage: String
    @Binding var history: Bool
    @Binding var data: String
    @Binding var showDrop: Bool
    
    #if os(iOS) || os(visionOS)
    public init(
        show: Binding<Bool>,
        align: Binding<HorizontalAlignment>? = .constant(.center),
        color: Binding<Color>? = .constant(Color.accentColor),
        size: Binding<String>? = .constant("simple"),
        labelColor: Binding<Color>? = .constant(Color(UIColor.systemBackground)),
        label: Binding<String>? = .constant("Show Release Note"),
        labelImage: Binding<String>? = .constant("arrow.up.circle.fill"),
        history: Binding<Bool>? = .constant(true),
        data: Binding<String>? = .constant("data"),
        showDrop: Binding<Bool>? = .constant(false)
    ) {
        _show = show
        _align = align ?? .constant(.center)
        _color = color ?? .constant(Color.accentColor)
        _size = size ?? .constant("simple")
        _labelColor = labelColor ?? .constant(Color(UIColor.systemBackground))
        _label = label ?? .constant("Show Release Note")
        _labelImage = labelImage ?? .constant("arrow.up.circle.fill")
        _history = history ?? .constant(true)
        _data = data ?? .constant("data")
        _showDrop = showDrop ?? .constant(false)
        compareVersion()
    }
    #elseif os(macOS)
    public init(
        show: Binding<Bool>,
        align: Binding<HorizontalAlignment>? = .constant(.center),
        color: Binding<Color>? = .constant(Color.accentColor),
        size: Binding<String>? = .constant("simple"),
        labelColor: Binding<Color>? = .constant(Color(NSColor.windowBackgroundColor)),
        label: Binding<String>? = .constant("Show Release Note"),
        labelImage: Binding<String>? = .constant("arrow.up.circle.fill"),
        history: Binding<Bool>? = .constant(true),
        data: Binding<String>? = .constant("data"),
        showDrop: Binding<Bool>? = .constant(false)
    ) {
        _show = show
        _align = align ?? .constant(.center)
        _color = color ?? .constant(Color.accentColor)
        _size = size ?? .constant("simple")
        _labelColor = labelColor ?? .constant(Color(NSColor.windowBackgroundColor))
        _label = label ?? .constant("Show Release Note")
        _labelImage = labelImage ?? .constant("arrow.up.circle.fill")
        _history = history ?? .constant(true)
        _data = data ?? .constant("data")
        _showDrop = showDrop ?? .constant(false)
        compareVersion()
    }
    #endif
    
    public var body: some View {
        Button(action: {
            if showDrop {
#if os(iOS)
                drop()
#endif
            } else {
                show = true
            }
        }) {
            if size == "mini" {
                Label(label, systemImage: labelImage)
            }
            else if size == "normal" || size == "simple" {
                Label(label, systemImage: labelImage)
                    .frame(width: 300, height: 50)
#if os(iOS) && !os(xrOS)
                    .foregroundColor(labelColor)
                    .background(color)
                    .cornerRadius(15)
#endif
            }
        }
        .opacity(size == "invisible" ? 0 : 100)
        .sheet(isPresented: $show) {
            sheetCurrent
                .sheet(isPresented: $historySheet) {
                    sheetHistory
                }
            #if os(xrOS)
                .padding()
            #endif
        }
    }
    
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
                                    ZStack {
                                        color
                                        Image(systemName: new.icon)
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 50, height:50)
                                    .cornerRadius(15)
                                    .padding(.trailing)
                                    VStack(alignment: .leading) {
                                        Text(new.title).font(.headline).lineLimit(1)
                                        Text(new.subtitle).font(.subheadline).foregroundColor(.secondary).lineLimit(1)
                                        Text(new.body).font(.caption).foregroundColor(.secondary).lineLimit(2)
                                    }
                                    Spacer()
                                }.padding(.bottom)
                            }
                        }
                    }
                }.frame(width: 300)
                .frame(maxHeight: 450)
            }
            
            Spacer()
            
            if history {
                showHistoryButton
            }
            
            closeCurrentButton
                .padding(.bottom)
        }
        .onAppear {
            loadData()
        }
#if os(macOS)
        .padding(25)
        .frame(width: 600, height: 600)
#endif
    }
#if os(iOS)
    public var appIcon: some View {
        Bundle.main.iconFileName
            .flatMap {
                UIImage(named: $0)
            }
            .map {
                Image(uiImage: $0)
                    .resizable()
                    .frame(width: 65, height: 65)
                    .overlay(
                        RoundedRectangle(cornerRadius: 19, style: .continuous)
                            .stroke(.gray, lineWidth: 1)
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
    }
    public var headings: some View {
        HStack {
            if align == .leading {
                appIcon
            }
            VStack(alignment: align) {
                if align == .center {
                    appIcon
                }
                Text(String(localized: "What's New in", bundle: .module))
                    .bold().font(.largeTitle)
                Text("\(String(localized: "Version", bundle: .module)) \(Bundle.versionBuild)")
                    .bold().font(.title).foregroundColor(.secondary)
            }
            if align == .trailing {
                appIcon
            }
        }
    }
#elseif os(macOS) || os(xrOS)
    public var headings: some View {
        VStack {
            Text(String(localized: "What's New in", bundle: .module))
                .bold().font(.largeTitle)
            Text("\(String(localized: "Version", bundle: .module)) \(Bundle.versionBuild)")
                .bold().font(.title).foregroundColor(.secondary)
        }
    }
#endif
    public var showHistoryButton: some View {
        Button(action: { historySheet = true }) {
            HStack {
                if align == .trailing {
                    Spacer()
                }
                Text(String(localized: "Show History", bundle: .module))
                Image(systemName: "arrow.up.bin")
                if align == .leading {
                    Spacer()
                }
            }.font(.body)
            #if os(iOS)
            .frame(width: 300, height: 50)
            #elseif os(macOS)
            .frame(width: 200, height: 25)
            #endif
        }
#if !os(xrOS)
        .foregroundColor(color)
#endif
    }
    public var closeCurrentButton: some View {
        Button(action: { show = false }) {
            HStack{
                if align == .trailing {
                    Spacer()
                }
                Text(String(localized: "Continue", bundle: .module))
                    .bold()
                Image(systemName: "arrow.right.circle.fill")
                if align == .leading {
                    Spacer()
                }
            }.font(.body)
            #if os(iOS)
            .frame(width: 300, height: 50)
            #elseif os(macOS)
            .frame(width: 200, height: 25)
            #endif
#if os(iOS) && !os(xrOS)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(15)
#endif
        }
    }
    
    // MARK: - History List View
    public var sheetHistory: some View {
        VStack(alignment: align) {
            Spacer()
            
            Text(String(localized: "History", bundle: .module))
                .bold().font(.largeTitle)
            
            Spacer()
            
            ScrollView(showsIndicators: false) {
                ForEach(items, id: \.self) { item in
                    ZStack {
                        color.opacity(0.25)
                        Text(item.version).bold().font(.title2).foregroundColor(color)
                    }.frame(width: 75, height: 30)
                    .cornerRadius(15)
                    .padding(.bottom)
                    ForEach(item.new, id: \.self) { new in
                        HStack {
                            ZStack {
                                color
                                Image(systemName: new.icon)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 50, height:50)
                            .cornerRadius(15)
                            .padding(.trailing)
                            VStack(alignment: .leading) {
                                Text(new.title).font(.headline).lineLimit(1)
                                Text(new.subtitle).font(.subheadline).foregroundColor(.secondary).lineLimit(1)
                                Text(new.body).font(.caption).foregroundColor(.secondary).lineLimit(2)
                            }
                            Spacer()
                        }.padding(.bottom)
                    }
                }
            }.frame(width: 300)
            .frame(maxHeight: 450)
            
            Spacer()
            
            closeHistoryButton
                .padding(.bottom)
        }
        #if os(macOS)
        .padding()
        .frame(width: 600, height: 600)
        #endif
    }
    public var closeHistoryButton: some View {
        Button(action: { historySheet = false }) {
            HStack{
                if align == .trailing {
                    Spacer()
                }
                Text(String(localized: "Return", bundle: .module))
                    .bold()
                Image(systemName: "arrow.down.circle.fill")
                if align == .leading {
                    Spacer()
                }
            }.font(.body)
            #if os(iOS)
            .frame(width: 300, height: 50)
            #elseif os(macOS)
            .frame(width: 300, height: 25)
            #endif
            #if os(iOS)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(15)
            #endif
        }
    }

    // MARK: - Functions
    public func compareVersion() {
        let currentVersion = Bundle.version.replacingOccurrences(of: ".", with: "")
        let currentBuild = Bundle.build.replacingOccurrences(of: ".", with: "")

        let savedVersion = String(version).replacingOccurrences(of: ".", with: "")
        let savedBuild = String(build).replacingOccurrences(of: ".", with: "")

        if Int(currentVersion)! != Int(savedVersion)! || Int(currentBuild)! != Int(savedBuild)! {
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if showDrop {
                        #if os(iOS)
                        drop()
                        #endif
                    } else {
                        show = true
                    }
                }
                version = Double(currentVersion)! / 10
                build = Double(currentBuild)! / 10
            }
        }
    }
    public func loadData() {
        if data.contains("http") {
            // MARK: Remote Data
            let url = URL(string: data)
            URLSession.shared.dataTask(with: url!) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        items = try decoder.decode([Vmodel].self, from: data)
                        self.loading = false
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        } else {
            // MARK: Local Data
            if let url = Bundle.main.url(forResource: data, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    items = try decoder.decode([Vmodel].self, from: data)
                    loading = false
                } catch {
                    print("error: \(error)")
                }
            }
        }
    }
    
    #if os(iOS)
    public func drop() {
        let drop = Drop(title: "Tap", subtitle: "To See What's New.", icon: UIImage(systemName: labelImage),
                        action: .init {
                            Drops.hideCurrent()
                            show = true
                        },
                        position: .top, duration: 3.0, accessibility: "Alert: Tap to see what's new." )
        Drops.show(drop)
    }
    #endif
}

// MARK: - Model
public struct Vmodel: Codable, Hashable {
    var version: String
    var subVersion: String?
    var new: [Model]
}
public struct Model: Codable, Hashable {
    var icon: String
    var title: String
    var subtitle: String
    var body: String
}

// MARK: - For App Icon
extension Bundle {
    var iconFileName: String? {
        guard let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.last
        else { return nil }
        return iconFileName
    }
}

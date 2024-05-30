//
//  Created by Ming on 11/6/2022.
//

import SwiftUI

public struct ContentView: View {
    
    @State var preview: String = "Simple"
    
    // MARK: System States
    @AppStorage("version") var version = 1.0
    @AppStorage("build") var build: Double = 1
    @State var items: [Vmodel] = []
    @State var loading = false
    @State var historySheet: Bool = false
    
    // MARK: All States
    @State var showNew: Bool = false
    // Optional
    @State var align: HorizontalAlignment = .center
    @State var size: String = "simple"
    @State var label: String = "Show Release Note"
    @State var labelImage: String = "heart.fill"
    @State var history: Bool = true
    @State var data: String = "data"
    @State var showDrop: Bool = false
   
    public init() {
    }
    
    public var body: some View {
        tab
    }
    
    public var tab: some View {
        // MARK: Choose either one size (Simple, Mini or Invisible)
        TabView(selection: $preview) {
            simple
                .tabItem {
                    Label("Simple", systemImage: labelImage)
                }
                .tag("Simple")
            mini
                .tabItem {
                    Label("Mini", systemImage: labelImage)
                }
                .tag("Mini")
            invisible
                .tabItem {
                    Label("Invisible", systemImage: labelImage)
                }
                .tag("Invisible")
            remote
                .tabItem {
                    Label("Remote", systemImage: labelImage)
                }
                .tag("Remote")
            #if os(iOS)
            drop
                .tabItem {
                    Label("Remote", systemImage: labelImage)
                }
                .tag("Drop")
            #endif
        }
    }

    public var simple: some View {
        NavigationStack {
            SwiftNEW
        }
    }
    
    public var mini: some View {
        // MARK: Mini (Toolbar / List only)
//        List {
//            Section(header: Text("Compatible with Toolbar / List")) {
//                SwiftNEW(show: $showNew, size: .constant("mini"))
//            }
//        }
        Text("Test")
    }
    
    public var invisible: some View {
//        SwiftNEW(show: $showNew, size: .constant("invisible"))
        Text("Test")
    }
    
    public var remote: some View {
        // MARK: Remote (>3.0.0) - Firebase Real Time Database Demo (Compatible with json format)
//        SwiftNEW(show: $showNew, labelImage: .constant("icloud"), data: .constant("https://testground-a937f-default-rtdb.firebaseio.com/.json?print=pretty"))
        Text("Test")
    }
    
    public var drop: some View {
        // MARK: Drop (>3.4.0) - Recommended trigger with Remote Notification
//        SwiftNEW(show: $showNew, label: .constant("Notification"), labelImage: .constant("bell.badge"), data: .constant("https://testground-a937f-default-rtdb.firebaseio.com/.json?print=pretty"), showDrop: .constant(true))
        Text("Test")
    }
    
    public var SwiftNEW: some View {
        Button(action: {
            if showDrop {
                #if os(iOS) && !SKIP
//                drop()
                #endif
            } else {
                showNew = true
            }
        }) {
            if size == "mini" {
                Label(label, systemImage: labelImage)
            }
            else if size == "normal" || size == "simple" {
                Label(label, systemImage: labelImage)
                    .frame(width: 300, height: 50)
            }
            else if size == "invisible" {}
        }
        .buttonStyle(.bordered)
        .tint(Color.accentColor)
        .sheet(isPresented: $showNew) {
            sheetCurrent
//                .sheet(isPresented: $historySheet) {
//                    sheetHistory
//                }
//                #if os(visionOS)
//                .padding()
//                #endif
        }
    }
    
    // MARK: - Current Version Changes View
    public var sheetCurrent: some View {
        VStack(alignment: align) {
            Spacer()
            
            headings
                .padding()
            
            Spacer()
            
            if loading {
                VStack {
                    Text(String(localized: "Loading...", bundle: .module))
                        .padding()
                    ProgressView()
                }
            }
            else {
                HStack {
                    ZStack {
                        Color.accentColor
                        Image(systemName: labelImage)
                            .foregroundColor(.white)
                    }
                    .frame(width: 50, height:50)
                    .cornerRadius(15)
                    .padding()
                    VStack(alignment: .leading) {
                        Text("6.0 Beta").font(.headline).lineLimit(1)
                        Text("Say Hello").font(.subheadline).foregroundColor(.secondary).lineLimit(1)
                        Text("to Both iOS and Android").font(.caption).foregroundColor(.secondary).lineLimit(2)
                    }
                    Spacer()
                }.frame(width: 300)
                
                HStack {
                    ZStack {
                        Color.accentColor
                        Image(systemName: labelImage)
                            .foregroundColor(.white)
                    }
                    .frame(width: 50, height:50)
                    .cornerRadius(15)
                    .padding()
                    VStack(alignment: .leading) {
                        Text("Serverless").font(.headline).lineLimit(1)
                        Text("Design").font(.subheadline).foregroundColor(.secondary).lineLimit(1)
                        Text("Free and open source! ❤️‍🔥").font(.caption).foregroundColor(.secondary).lineLimit(2)
                    }
                    Spacer()
                }.frame(width: 300)
                
                HStack {
                    ZStack {
                        Color.accentColor
                        Image(systemName: labelImage)
                            .foregroundColor(.white)
                    }
                    .frame(width: 50, height:50)
                    .cornerRadius(15)
                    .padding()
                    VStack(alignment: .leading) {
                        Text("Contribute").font(.headline).lineLimit(1)
                        Text("Together").font(.subheadline).foregroundColor(.secondary).lineLimit(1)
                        Text("Pull requests and make it better for everyone! 🎉").font(.caption).foregroundColor(.secondary).lineLimit(2)
                    }
                    Spacer()
                }.frame(width: 300)
            }
            
            Spacer()
            
            if history {
                showHistoryButton
            }
            
            closeCurrentButton
        }
//        .onAppear {
//            loadData()
//        }
#if os(macOS)
        .padding(25)
        .frame(width: 600, height: 600)
#endif
    }
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
        }.buttonStyle(.bordered)
        .tint(Color.accentColor)
    }
    public var closeCurrentButton: some View {
        Button(action: { showNew = false }) {
            HStack{
                if align == .trailing {
                    Spacer()
                }
                Text(String(localized: "Continue", bundle: .module))
                    .bold()
                if align == .leading {
                    Spacer()
                }
            }.font(.body)
#if os(iOS)
                .frame(width: 300, height: 50)
#elseif os(macOS)
                .frame(width: 200, height: 25)
#endif
        }.buttonStyle(.borderedProminent)
        .tint(Color.accentColor)
    }
#if os(iOS) && !SKIP
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
#endif
    public var headings: some View {
        HStack {
            if align == .leading {
#if os(iOS) && !SKIP
                appIcon
#endif
            }
            VStack(alignment: align) {
                if align == .center {
#if os(iOS) && !SKIP
                    appIcon
#endif
                }
                Text(String(localized: "What's New in", bundle: .module))
                    .bold().font(.largeTitle)
                Text("SwiftNEWKit")
                    .bold().font(.title).foregroundColor(.secondary)
            }
            if align == .trailing {
#if os(iOS) && !SKIP
                appIcon
#endif
            }
        }
    }
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

extension Bundle {
    var iconFileName: String? {
        #if !SKIP
        guard let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.last
        else { return nil }
        #endif
        return iconFileName
    }
}

#Preview {
    ContentView()
}

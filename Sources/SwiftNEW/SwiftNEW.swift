import SwiftUI
 
@available(iOS 14, watchOS 7.0, macOS 11.0, *)
public struct SwiftNEW: View {
    @AppStorage("version") var version = 1.0
    @AppStorage("build") var build: Double = 1
    @State var show = false
    @State var items: [Model] = []
    @State var align: HorizontalAlignment = .center
    @State var loading = true
    
    public init() {
    }
 
    public var body: some View {
        Button(action: { show = true }) {
            Text("Show Release Note")
                .frame(width: 300, height: 50)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(15)
        }
        .sheet(isPresented: $show) {
            VStack(alignment: align) {
                Spacer()
                Text("What's New?").bold().font(.largeTitle)
                Text("Version \(UIApplication.versionBuild)")
                    .bold().font(.title).foregroundColor(.secondary)
                Spacer()
                if loading {
                    ProgressView()
                } else {
                    ScrollView {
                        ForEach(items, id: \.self) { item in
                            HStack {
                                Image(systemName: item.icon)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.accentColor)
                                    .frame(width: 50, height:50)
                                    .cornerRadius(15)
                                    .padding(.trailing)
                                VStack(alignment: .leading) {
                                    Text(item.title).font(.headline)
                                    Text(item.subtitle).font(.subheadline).foregroundColor(.secondary)
                                    Text(item.body).font(.caption).foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                        }.frame(width: 300)
                    }.frame(height: 450)
                }
                Spacer()
                Button(action: { show = false }) {
                    Text("Continue").bold()
                }.frame(width: 300, height: 50)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(15)
            }
            .onAppear {
                compareVersion()
                loadData()
            }
        }
    }

    public func compareVersion() {
        #if os(iOS)
        if Double(UIApplication.version)! > version || Double(UIApplication.build)! > build {
            show = true
            version = Double(UIApplication.version)!
            build = Double(UIApplication.build)!
        }
        #elseif os(macOS)
        if Double(NSApplication.version)! > version || Double(NSApplication.build)! > build {
            show = true
            version = Double(UIApplication.version)!
            build = Double(UIApplication.build)!
        }
        #endif
    }
    public func loadData() {
        // MARK :- Local Data
        if let url = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                items = try decoder.decode([Model].self, from: data)
                loading = false
            } catch {
                print("error: \(error)")
            }
        }
    }
}

// MARK: - Find Version
#if os(iOS)
public extension UIApplication {
    static var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "1.0"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "1"
    }
    static var versionBuild: String {
        return "\(version) (\(build))"
    }
}
#elseif os(macOS)
public extension NSApplication {
    static var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "1.0"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "1"
    }
    static var versionBuild: String {
        return "\(version) (\(build))"
    }
}
#endif

public struct Model: Codable, Hashable {
    var icon: String
    var title: String
    var subtitle: String
    var body: String
}

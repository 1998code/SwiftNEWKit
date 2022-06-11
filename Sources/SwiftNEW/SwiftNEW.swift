//
//  Created by Ming on 11/6/2022.
//

//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
 
@available(iOS 14, watchOS 7.0, macOS 11.0, *)
public struct SwiftNEW: View {
    @AppStorage("version") var version = 1.0
    @AppStorage("build") var build: Double = 1
    @State var items: [Vmodel] = []
    @State var loading = true
    
    @Binding var show: Bool
    @Binding var align: HorizontalAlignment
    @Binding var color: Color
    @Binding var label: String

    public init( show: Binding<Bool>, align: Binding<HorizontalAlignment>, color: Binding<Color>, label: Binding<String> ) {
        _show = show
        _align = align
        _color = color
        _label = label
        compareVersion()
    }
 
    public var body: some View {
        Button(action: { show = true }) {
            Text(label)
                .frame(width: 300, height: 50)
                .foregroundColor(.white)
                .background(color)
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
                            if item.version == UIApplication.version {
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
                    }.frame(height: 450)
                }
                Spacer()
                Button(action: { show = false }) {
                    Text("Continue").bold()
                }.frame(width: 300, height: 50)
                .foregroundColor(.white)
                .background(color)
                .cornerRadius(15)
            }
            .onAppear {
                loadData()
            }
        }
    }

    public func compareVersion() {
        #if os(iOS)
        if Double(UIApplication.version)! > version || Double(UIApplication.build)! > build {
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    show = true
                }
                version = Double(UIApplication.version)!
                build = Double(UIApplication.build)!
            }
        }
        #elseif os(macOS)
        if Double(NSApplication.version)! > version || Double(NSApplication.build)! > build {
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    show = true
                }
                version = Double(UIApplication.version)!
                build = Double(UIApplication.build)!
            }
        }
        #endif
    }
    public func loadData() {
        // MARK :- Local Data
        if let url = Bundle.main.url(forResource: "data", withExtension: "json") {
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

// MARK: - Model
public struct Vmodel: Codable, Hashable {
    var version: String
    var new: [Model]
}
public struct Model: Codable, Hashable {
    var icon: String
    var title: String
    var subtitle: String
    var body: String
}

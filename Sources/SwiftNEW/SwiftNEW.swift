//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftVB
 
@available(iOS 14, watchOS 7.0, macOS 11.0, *)
public struct SwiftNEW: View {
    @AppStorage("version") var version = 1.0
    @AppStorage("build") var build: Double = 1
    
    @State var items: [Vmodel] = []
    @State var loading = true
    
    @Binding var show: Bool
    @Binding var align: HorizontalAlignment
    @Binding var color: Color
    @Binding var size: String
    @Binding var labelColor: Color
    @Binding var label: String
    @Binding var labelImage: String
    
    @State var showHistory: Bool = false

    public init( show: Binding<Bool>, align: Binding<HorizontalAlignment>, color: Binding<Color>, size: Binding<String>, labelColor: Binding<Color>, label: Binding<String>, labelImage: Binding<String>) {
        _show = show
        _align = align
        _color = color
        _size = size
        _labelColor = labelColor
        _label = label
        _labelImage = labelImage
        compareVersion()
    }
 
    public var body: some View {
        Button(action: { show = true }) {
            if size == "mini" {
                Label(label, systemImage: labelImage)
            }
            else if size == "normal" {
                Label(label, systemImage: labelImage)
                    .frame(width: 300, height: 50)
                    #if os(iOS)
                    .foregroundColor(labelColor)
                    .background(color)
                    .cornerRadius(15)
                    #endif
            }
        }
        .sheet(isPresented: $show) {
            sheetContent
                .sheet(isPresented: $showHistory) {
                    sheetHistory
                }
        }
    }
    
    public var sheetContent: some View {
        VStack(alignment: align) {
            Spacer()
            Text("What's New?").bold().font(.largeTitle)
            Text("Version \(Bundle.versionBuild)")
                .bold().font(.title).foregroundColor(.secondary)
            Spacer()
            if loading {
                ProgressView()
            } else {
                ScrollView(showsIndicators: false) {
                    ForEach(items, id: \.self) { item in
                        if item.version == Bundle.version {
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
                }.frame(width: 300, height: 450)
            }
            Spacer()
            Button(action: { showHistory = true }) {
                HStack {
                    Text("Show History")
                    Image(systemName: "arrow.up.bin")
                }.font(.body)
            }.foregroundColor(color)
            Button(action: { show = false }) {
                HStack{
                    Text("Continue").bold()
                    Image(systemName: "arrow.right.circle.fill")
                }.font(.body)
                .frame(width: 300, height: 50)
                #if os(iOS)
                .foregroundColor(.white)
                .background(color)
                .cornerRadius(15)
                #endif
            }
            .padding(.bottom)
        }
        .onAppear {
            loadData()
        }
        #if os(macOS)
        .padding()
        .frame(width: 600, height: 600)
        #endif
    }
    
    public var sheetHistory: some View {
        VStack(alignment: align) {
            Spacer()
            Text("History").bold().font(.largeTitle)
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
            }.frame(width: 300, height: 450)
            Spacer()
            Button(action: { showHistory = false }) {
                HStack{
                    Text("Return").bold()
                    Image(systemName: "arrow.down.circle.fill")
                }.font(.body)
                .frame(width: 300, height: 50)
                #if os(iOS)
                .foregroundColor(.white)
                .background(color)
                .cornerRadius(15)
                #endif
            }
            .padding(.bottom)
        }
        #if os(macOS)
        .padding()
        .frame(width: 600, height: 600)
        #endif
    }

    public func compareVersion() {
        if Double(Bundle.version)! > version || Double(Bundle.build)! > build {
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    show = true
                }
                version = Double(Bundle.version)!
                build = Double(Bundle.build)!
            }
        }
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

//struct Previews: PreviewProvider {
//    static var previews: some View {
//
//    }
//}

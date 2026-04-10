//
//  SwiftNEW+Functions.swift
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
        let source = data
        Task {
            do {
                let decoded: [Vmodel]
                if source.contains("http") {
                    // MARK: Remote Data
                    guard let url = URL(string: source) else { return }
                    let (responseData, _) = try await URLSession.shared.data(from: url)
                    decoded = try JSONDecoder().decode([Vmodel].self, from: responseData)
                } else {
                    // MARK: Local Data
                    guard let url = Bundle.main.url(forResource: source, withExtension: "json") else { return }
                    decoded = try await Task.detached {
                        let fileData = try Data(contentsOf: url)
                        return try JSONDecoder().decode([Vmodel].self, from: fileData)
                    }.value
                }
                await MainActor.run {
                    items = decoded
                    loading = false
                }
            } catch {
                print("SwiftNEW loadData error: \(error)")
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

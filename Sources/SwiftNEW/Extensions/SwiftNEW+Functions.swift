//
//  SwiftNEW+Functions.swift
//  SwiftNEW
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftVB

#if os(iOS)
import Drops
#endif

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {
    
    // MARK: - Functions
    public func compareVersion() {
        let currentVersion = Bundle.version
        let currentBuild = Bundle.build

        if SwiftNEWVersionState.shouldPresent(
            currentVersion: currentVersion,
            currentBuild: currentBuild,
            savedVersion: version,
            savedBuild: build
        ) {
            version = currentVersion.trimmingCharacters(in: .whitespacesAndNewlines)
            build = currentBuild.trimmingCharacters(in: .whitespacesAndNewlines)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    if showDrop {
                        #if os(iOS)
                        drop()
                        #else
                        show = true
                        #endif
                    } else {
                        show = true
                    }
                }
            }
        }
    }
    
    public func loadData() {
        let source = data
        guard loading || items.isEmpty || loadedDataSource != source else { return }

        loading = true
        loadErrorMessage = nil

        Task {
            do {
                let decoded: [Vmodel]
                if source.contains("http") {
                    // MARK: Remote Data
                    guard let url = URL(string: source) else { throw URLError(.badURL) }
                    let (responseData, _) = try await URLSession.shared.data(from: url)
                    decoded = try JSONDecoder().decode([Vmodel].self, from: responseData)
                } else {
                    // MARK: Local Data
                    guard let url = Bundle.main.url(forResource: source, withExtension: "json") else { throw CocoaError(.fileNoSuchFile) }
                    decoded = try await Task.detached {
                        let fileData = try Data(contentsOf: url)
                        return try JSONDecoder().decode([Vmodel].self, from: fileData)
                    }.value
                }
                await MainActor.run {
                    items = decoded
                    loading = false
                    loadErrorMessage = nil
                    loadedDataSource = source
                }
            } catch {
                print("SwiftNEW loadData error: \(error)")
                await MainActor.run {
                    loading = false
                    loadErrorMessage = String(localized: "Unable to load release notes.", bundle: .module)
                }
            }
        }
    }
    
    #if os(iOS)
    public func drop() {
        let drop = Drop(title: String(localized: "Tap", bundle: .module),
                        subtitle: String(localized: "To See What's New.", bundle: .module),
                        icon: UIImage(systemName: labelImage),
                        action: .init {
                            Drops.hideCurrent()
                            show = true
                        },
                        position: .top,
                        duration: 3.0,
                        accessibility: .init(message: String(localized: "Alert: Tap to see what's new.", bundle: .module)))
        Drops.show(drop)
    }
    #endif
}

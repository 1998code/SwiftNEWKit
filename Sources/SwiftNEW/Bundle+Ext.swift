//
//  Bundle+Ext.swift
//  SwiftNEW
//
//  Created by Ming on 7/1/2025.
//

import SwiftUI

// MARK: - For App Icon
extension Bundle {
    var appStoreListingBundleIdentifier: String? {
        #if os(watchOS)
        if let companionIdentifier = object(
            forInfoDictionaryKey: "WKCompanionAppBundleIdentifier"
        ) as? String {
            let normalized = companionIdentifier.trimmingCharacters(in: .whitespacesAndNewlines)
            if !normalized.isEmpty {
                return normalized
            }
        }
        #endif

        return bundleIdentifier
    }

    var iconFileName: String? {
        iconFileNames().last
    }

    var appIconName: String? {
        appIconAssetName()
    }

    var declaredAppIconNames: Set<String> {
        var names = Set<String>()

        if let appIconName {
            names.insert(appIconName)
        }

        for icons in iconDictionaries {
            if let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
               let name = primaryIcon["CFBundleIconName"] as? String {
                names.insert(name)
            }

            guard let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any] else {
                continue
            }

            for (alternateName, value) in alternateIcons {
                names.insert(alternateName)
                if let alternateIcon = value as? [String: Any],
                   let name = alternateIcon["CFBundleIconName"] as? String {
                    names.insert(name)
                }
            }
        }

        return names
    }

    func iconFileNames(
        alternateIconName: String? = nil,
        prefersIPadIcons: Bool = false
    ) -> [String] {
        var fileNames: [String] = []

        for icons in preferredIconDictionaries(prefersIPadIcons: prefersIPadIcons) {
            let icon: [String: Any]?
            if let alternateIconName {
                let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any]
                icon = alternateIcons?[alternateIconName] as? [String: Any]
            } else {
                icon = icons["CFBundlePrimaryIcon"] as? [String: Any]
            }

            if let files = icon?["CFBundleIconFiles"] as? [String], !files.isEmpty {
                fileNames.append(contentsOf: files)
                break
            }
        }

        if fileNames.isEmpty,
           alternateIconName == nil,
           let legacyFiles = infoDictionary?["CFBundleIconFiles"] as? [String] {
            fileNames.append(contentsOf: legacyFiles)
        }

        if fileNames.isEmpty,
           alternateIconName == nil,
           let legacyFile = infoDictionary?["CFBundleIconFile"] as? String,
           !legacyFile.isEmpty {
            fileNames.append(legacyFile)
        }

        var seen = Set<String>()
        return fileNames.filter { seen.insert($0).inserted }
    }

    func appIconAssetName(
        alternateIconName: String? = nil,
        prefersIPadIcons: Bool = false
    ) -> String? {
        for icons in preferredIconDictionaries(prefersIPadIcons: prefersIPadIcons) {
            let icon: [String: Any]?
            if let alternateIconName {
                let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any]
                icon = alternateIcons?[alternateIconName] as? [String: Any]
            } else {
                icon = icons["CFBundlePrimaryIcon"] as? [String: Any]
            }

            if let name = icon?["CFBundleIconName"] as? String,
               !name.isEmpty {
                return name
            }
        }

        guard alternateIconName == nil else {
            return nil
        }

        return infoDictionary?["CFBundleIconName"] as? String
    }

    func appIconResourceCandidates(
        for fileName: String,
        displayScale: CGFloat
    ) -> [String] {
        let resource = fileName as NSString
        let suppliedExtension = resource.pathExtension
        let name = suppliedExtension.isEmpty
            ? fileName
            : resource.deletingPathExtension
        let fileExtension = suppliedExtension.isEmpty ? "png" : suppliedExtension
        let scale = Int(displayScale.rounded())
        let scaleSuffixes = scale >= 3 ? ["@3x", "@2x", ""] : ["@2x", "", "@3x"]
        var candidates: [String] = []

        if !suppliedExtension.isEmpty {
            candidates.append(fileName)
        }

        for suffix in scaleSuffixes {
            candidates.append("\(name)\(suffix).\(fileExtension)")
            candidates.append("\(name)\(suffix)~ipad.\(fileExtension)")
            candidates.append("\(name)~ipad\(suffix).\(fileExtension)")
        }

        var seen = Set<String>()
        return candidates.filter { seen.insert($0).inserted }
    }

    private func preferredIconDictionaries(prefersIPadIcons: Bool) -> [[String: Any]] {
        if prefersIPadIcons,
           let icons = infoDictionary?["CFBundleIcons~ipad"] as? [String: Any] {
            return [icons]
        }

        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any] {
            return [icons]
        }

        // Some legacy iPad-only bundles contain only the suffixed dictionary.
        if let icons = infoDictionary?["CFBundleIcons~ipad"] as? [String: Any] {
            return [icons]
        }

        return []
    }

    private var iconDictionaries: [[String: Any]] {
        ["CFBundleIcons", "CFBundleIcons~ipad"].compactMap {
            infoDictionary?[$0] as? [String: Any]
        }
    }

    // MARK: - Version Information
    static var versionBuild: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    static var appName: String {
        Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
            ?? Bundle.main.infoDictionary?["CFBundleName"] as? String
            ?? ""
    }
}

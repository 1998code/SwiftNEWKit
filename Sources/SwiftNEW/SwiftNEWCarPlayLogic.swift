//
//  SwiftNEWCarPlayLogic.swift
//  SwiftNEW
//

import Foundation

enum SwiftNEWCarPlayReleaseSelector {
    static func releases(
        from releases: [Vmodel],
        currentVersion: String,
        includesHistory: Bool
    ) -> [Vmodel] {
        guard let currentVersion = normalized(currentVersion) else { return [] }
        let currentIndex = releases.firstIndex {
            normalized($0.version) == currentVersion
                || normalized($0.subVersion) == currentVersion
        }

        guard includesHistory else {
            return currentIndex.map { [releases[$0]] } ?? []
        }

        guard let parsedCurrentVersion = SwiftNEWParsedVersion(currentVersion)
        else {
            return currentIndex.map { [releases[$0]] } ?? []
        }

        var visibleReleases = releases.filter { release in
            if normalized(release.version) == currentVersion
                || normalized(release.subVersion) == currentVersion {
                return true
            }

            guard let releaseVersion = preferredVersion(for: release),
                  let parsedReleaseVersion = SwiftNEWParsedVersion(releaseVersion)
            else { return false }

            return parsedReleaseVersion <= parsedCurrentVersion
        }

        if let currentVisibleIndex = visibleReleases.firstIndex(where: {
            normalized($0.version) == currentVersion
                || normalized($0.subVersion) == currentVersion
        }) {
            let currentRelease = visibleReleases.remove(at: currentVisibleIndex)
            visibleReleases.insert(currentRelease, at: 0)
        }

        return visibleReleases
    }

    private static func preferredVersion(for release: Vmodel) -> String? {
        normalized(release.subVersion) ?? normalized(release.version)
    }

    private static func normalized(_ value: String?) -> String? {
        guard let value else { return nil }
        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return normalized.isEmpty ? nil : normalized
    }
}

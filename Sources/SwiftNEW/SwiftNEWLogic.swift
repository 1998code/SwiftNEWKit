//
//  SwiftNEWLogic.swift
//  SwiftNEW
//

import Foundation

enum SwiftNEWVersionState {
    static func shouldPresent(
        currentVersion: String,
        currentBuild: String,
        savedVersion: String,
        savedBuild: String
    ) -> Bool {
        normalized(currentVersion) != normalized(savedVersion)
            || normalized(currentBuild) != normalized(savedBuild)
    }

    private static func normalized(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum SwiftNEWSearch {
    static func matches(_ item: Model, query: String, isEnabled: Bool) -> Bool {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isEnabled, !normalizedQuery.isEmpty else { return true }

        return item.title.localizedCaseInsensitiveContains(normalizedQuery)
            || item.subtitle.localizedCaseInsensitiveContains(normalizedQuery)
            || item.body.localizedCaseInsensitiveContains(normalizedQuery)
    }
}

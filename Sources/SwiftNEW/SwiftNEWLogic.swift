//
//  SwiftNEWLogic.swift
//  SwiftNEW
//

import Foundation

struct SwiftNEWParsedVersion: Comparable, Sendable {
    private enum PrereleaseIdentifier: Equatable, Sendable {
        case numeric(String)
        case text(String)
    }

    private let core: [String]
    private let prerelease: [PrereleaseIdentifier]?

    init?(_ rawValue: String) {
        var value = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else { return nil }

        if value.first == "v" || value.first == "V" {
            let valueAfterPrefix = value.dropFirst()
            guard valueAfterPrefix.first?.isASCIIDigit == true else { return nil }
            value = String(valueAfterPrefix)
        }

        let buildParts = value.split(separator: "+", maxSplits: 1, omittingEmptySubsequences: false)
        guard !buildParts[0].isEmpty else { return nil }
        if buildParts.count == 2 {
            guard Self.isValidDotSeparatedIdentifiers(buildParts[1]) else { return nil }
        }

        let versionParts = buildParts[0].split(separator: "-", maxSplits: 1, omittingEmptySubsequences: false)
        let rawCore = versionParts[0].split(separator: ".", omittingEmptySubsequences: false)
        guard !rawCore.isEmpty, rawCore.allSatisfy({ Self.isNumeric($0) }) else { return nil }
        core = rawCore.map { Self.normalizedNumericComponent($0) }

        if versionParts.count == 2 {
            let rawPrerelease = versionParts[1].split(separator: ".", omittingEmptySubsequences: false)
            guard !rawPrerelease.isEmpty,
                  rawPrerelease.allSatisfy({ !$0.isEmpty && Self.isValidIdentifier($0) })
            else { return nil }

            prerelease = rawPrerelease.map { identifier in
                if Self.isNumeric(identifier) {
                    return .numeric(Self.normalizedNumericComponent(identifier))
                }
                return .text(String(identifier))
            }
        } else {
            prerelease = nil
        }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        compare(lhs, rhs) == .orderedSame
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        compare(lhs, rhs) == .orderedAscending
    }

    private static func compare(_ lhs: Self, _ rhs: Self) -> ComparisonResult {
        let coreCount = max(lhs.core.count, rhs.core.count)
        for index in 0..<coreCount {
            let lhsComponent = index < lhs.core.count ? lhs.core[index] : "0"
            let rhsComponent = index < rhs.core.count ? rhs.core[index] : "0"
            let result = compareNumeric(lhsComponent, rhsComponent)
            if result != .orderedSame { return result }
        }

        switch (lhs.prerelease, rhs.prerelease) {
        case (nil, nil):
            return .orderedSame
        case (nil, .some):
            return .orderedDescending
        case (.some, nil):
            return .orderedAscending
        case let (.some(lhsIdentifiers), .some(rhsIdentifiers)):
            let identifierCount = min(lhsIdentifiers.count, rhsIdentifiers.count)
            for index in 0..<identifierCount {
                let result = compare(lhsIdentifiers[index], rhsIdentifiers[index])
                if result != .orderedSame { return result }
            }

            if lhsIdentifiers.count == rhsIdentifiers.count { return .orderedSame }
            return lhsIdentifiers.count < rhsIdentifiers.count ? .orderedAscending : .orderedDescending
        }
    }

    private static func compare(
        _ lhs: PrereleaseIdentifier,
        _ rhs: PrereleaseIdentifier
    ) -> ComparisonResult {
        switch (lhs, rhs) {
        case let (.numeric(lhsValue), .numeric(rhsValue)):
            return compareNumeric(lhsValue, rhsValue)
        case (.numeric, .text):
            return .orderedAscending
        case (.text, .numeric):
            return .orderedDescending
        case let (.text(lhsValue), .text(rhsValue)):
            if lhsValue == rhsValue { return .orderedSame }
            return lhsValue < rhsValue ? .orderedAscending : .orderedDescending
        }
    }

    private static func compareNumeric(_ lhs: String, _ rhs: String) -> ComparisonResult {
        if lhs.count != rhs.count {
            return lhs.count < rhs.count ? .orderedAscending : .orderedDescending
        }
        if lhs == rhs { return .orderedSame }
        return lhs < rhs ? .orderedAscending : .orderedDescending
    }

    private static func normalizedNumericComponent<S: StringProtocol>(_ value: S) -> String {
        let withoutLeadingZeroes = value.drop(while: { $0 == "0" })
        return withoutLeadingZeroes.isEmpty ? "0" : String(withoutLeadingZeroes)
    }

    private static func isNumeric<S: StringProtocol>(_ value: S) -> Bool {
        !value.isEmpty && value.allSatisfy { $0.isASCIIDigit }
    }

    private static func isValidIdentifier<S: StringProtocol>(_ value: S) -> Bool {
        value.unicodeScalars.allSatisfy { scalar in
            scalar.isASCIIDigit || scalar.isASCIILetter || scalar.value == 45
        }
    }

    private static func isValidDotSeparatedIdentifiers<S: StringProtocol>(_ value: S) -> Bool {
        let identifiers = value.split(separator: ".", omittingEmptySubsequences: false)
        return !identifiers.isEmpty
            && identifiers.allSatisfy { !$0.isEmpty && isValidIdentifier($0) }
    }
}

private extension Character {
    var isASCIIDigit: Bool {
        unicodeScalars.count == 1 && unicodeScalars.first?.isASCIIDigit == true
    }
}

private extension Unicode.Scalar {
    var isASCIIDigit: Bool {
        value >= 48 && value <= 57
    }

    var isASCIILetter: Bool {
        (value >= 65 && value <= 90) || (value >= 97 && value <= 122)
    }
}

struct SwiftNEWUpdateCandidate: Equatable, Sendable {
    let release: Vmodel
    let version: String
    let appStoreURL: URL?

    init(release: Vmodel, version: String, appStoreURL: URL? = nil) {
        self.release = release
        self.version = version
        self.appStoreURL = appStoreURL
    }

    func resolvingAppStoreURL(_ url: URL) -> Self {
        Self(release: release, version: version, appStoreURL: url)
    }
}

struct SwiftNEWVersionSnapshot: Equatable, Sendable {
    let version: String
    let build: String

    init(version: String, build: String) {
        self.version = version.trimmingCharacters(in: .whitespacesAndNewlines)
        self.build = build.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum SwiftNEWReleaseSelector {
    static func latestUpdate(
        in releases: [Vmodel],
        currentVersion: String
    ) -> SwiftNEWUpdateCandidate? {
        guard let parsedCurrentVersion = SwiftNEWParsedVersion(currentVersion) else { return nil }

        var latestCandidate: SwiftNEWUpdateCandidate?
        var latestParsedVersion: SwiftNEWParsedVersion?

        for release in releases {
            let version = preferredVersion(for: release)
            guard let parsedVersion = SwiftNEWParsedVersion(version),
                  parsedVersion > parsedCurrentVersion
            else { continue }

            if let latestParsedVersion, parsedVersion <= latestParsedVersion {
                continue
            }

            latestCandidate = SwiftNEWUpdateCandidate(release: release, version: version)
            latestParsedVersion = parsedVersion
        }

        return latestCandidate
    }

    private static func preferredVersion(for release: Vmodel) -> String {
        let preciseVersion = release.subVersion?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !preciseVersion.isEmpty { return preciseVersion }
        return release.version.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct SwiftNEWLoadRequest: Hashable, Sendable {
    let source: String
    let checkForUpdates: Bool
    let bundleIdentifier: String?
}

struct SwiftNEWLoadTaskID: Hashable, Sendable {
    let request: SwiftNEWLoadRequest
    let shouldLoad: Bool
    let reloadID: UUID
}

enum SwiftNEWUpdateCheckPhase: Equatable, Sendable {
    case inactive
    case checking
    case resolved
}

enum SwiftNEWPendingPresentation: Equatable, Sendable {
    case none
    case sheet
    case drop
}

enum SwiftNEWRemoteSource {
    static func looksRemote(_ source: String) -> Bool {
        let normalized = source.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return normalized.hasPrefix("http://") || normalized.hasPrefix("https://")
    }

    static func url(from source: String) -> URL? {
        let normalized = source.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: normalized),
              let scheme = url.scheme?.lowercased(),
              scheme == "http" || scheme == "https",
              url.host?.isEmpty == false
        else { return nil }
        return url
    }
}

struct SwiftNEWAppStoreLookupResponse: Decodable, Equatable, Sendable {
    let results: [SwiftNEWAppStoreLookupResult]
}

struct SwiftNEWAppStoreLookupResult: Decodable, Equatable, Sendable {
    let bundleIdentifier: String?
    let trackViewURL: String?

    enum CodingKeys: String, CodingKey {
        case bundleIdentifier = "bundleId"
        case trackViewURL = "trackViewUrl"
    }
}

enum SwiftNEWAppStoreLookupError: Error {
    case missingBundleIdentifier
    case invalidRequest
    case noResult
}

enum SwiftNEWAppStoreLookup {
    static func requestURL(
        bundleIdentifier: String,
        countryCode: String? = nil
    ) -> URL? {
        let normalized = bundleIdentifier.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty else { return nil }

        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/lookup"
        components.queryItems = [URLQueryItem(name: "bundleId", value: normalized)]

        if let countryCode = normalizedCountryCode(countryCode) {
            components.queryItems?.append(
                URLQueryItem(name: "country", value: countryCode)
            )
        }
        return components.url
    }

    static func appStoreURL(from data: Data, bundleIdentifier: String) throws -> URL? {
        let response = try JSONDecoder().decode(SwiftNEWAppStoreLookupResponse.self, from: data)
        let normalizedBundleIdentifier = bundleIdentifier.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        return response.results.lazy.compactMap { result -> URL? in
            guard result.bundleIdentifier?.caseInsensitiveCompare(normalizedBundleIdentifier) == .orderedSame,
                  let rawURL = result.trackViewURL,
                  let url = URL(string: rawURL),
                  url.scheme?.lowercased() == "https",
                  let host = url.host?.lowercased(),
                  host == "apps.apple.com"
                    || host == "itunes.apple.com"
                    || host.hasSuffix(".itunes.apple.com")
            else { return nil }
            return url
        }.first
    }

    static func normalizedCountryCode(_ countryCode: String?) -> String? {
        guard let countryCode else { return nil }
        let trimmed = countryCode.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count == 2,
              trimmed.unicodeScalars.allSatisfy({ $0.isASCIILetter })
        else { return nil }
        return trimmed.uppercased()
    }
}

enum SwiftNEWUpdateResolver {
    static func candidate(
        in releases: [Vmodel],
        currentVersion: String,
        source: String,
        checkForUpdates: Bool
    ) -> SwiftNEWUpdateCandidate? {
        guard SwiftNEWRemoteSource.url(from: source) != nil,
              checkForUpdates
        else { return nil }

        return SwiftNEWReleaseSelector.latestUpdate(
            in: releases,
            currentVersion: currentVersion
        )
    }
}

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

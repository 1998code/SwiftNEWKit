//
//  SwiftNEWReleaseNotesLoader.swift
//  SwiftNEW
//

import Foundation

/// Loads SwiftNEW release-note data without requiring a SwiftUI view.
///
/// Use this loader when the host needs to build a platform-native interface,
/// such as a CarPlay template, from the same local or remote JSON source used
/// by ``SwiftNEW``.
public enum SwiftNEWReleaseNotesLoader {
    /// Loads and decodes release notes from a bundled JSON resource or an HTTP(S) URL.
    ///
    /// - Parameters:
    ///   - source: A bundled resource name without the `.json` extension, or an HTTP(S) URL.
    ///   - bundle: The bundle containing a local JSON resource. Ignored for remote sources.
    /// - Returns: The decoded release-note versions in source order.
    public static func load(
        from source: String = "data",
        bundle: Bundle = .main
    ) async throws -> [Vmodel] {
        if SwiftNEWRemoteSource.looksRemote(source) {
            guard let url = SwiftNEWRemoteSource.url(from: source) else {
                throw URLError(.badURL)
            }

            let (data, response) = try await URLSession.shared.data(from: url)
            try validateHTTPResponse(response)
            return try JSONDecoder().decode([Vmodel].self, from: data)
        }

        guard let url = bundle.url(forResource: source, withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }

        return try await Task.detached(priority: .userInitiated) {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Vmodel].self, from: data)
        }.value
    }

    private static func validateHTTPResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else { throw URLError(.badServerResponse) }
    }
}

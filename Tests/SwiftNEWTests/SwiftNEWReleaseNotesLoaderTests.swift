//
//  SwiftNEWReleaseNotesLoaderTests.swift
//  SwiftNEWTests
//

import Foundation
import Testing
@testable import SwiftNEW

@Test func releaseNotesLoaderReadsBundledJSON() async throws {
    let releases = try await SwiftNEWReleaseNotesLoader.load(
        from: "swiftnew-test-data",
        bundle: .module
    )

    #expect(releases.count == 1)
    #expect(releases.first?.version == "1.0")
    #expect(releases.first?.new.first?.title == "Local")
}

@Test func releaseNotesLoaderRejectsMalformedRemoteURL() async {
    do {
        _ = try await SwiftNEWReleaseNotesLoader.load(from: "http://%")
        #expect(Bool(false), "Expected a malformed URL error")
    } catch let error as URLError {
        #expect(error.code == .badURL)
    } catch {
        #expect(Bool(false), "Expected URLError, received \(error)")
    }
}

@Test func releaseNotesLoaderDecodesSuccessfulHTTPResponsesWithoutNetworkAccess() async throws {
    let url = try #require(URL(string: "https://example.com/releases.json"))
    let response = try makeHTTPResponse(url: url, statusCode: 200)

    let releases = try await SwiftNEWReleaseNotesLoader.load(
        from: "  https://example.com/releases.json  ",
        bundle: .module,
        remoteDataLoader: { requestedURL in
            #expect(requestedURL == url)
            return (remoteReleaseData(), response)
        }
    )

    #expect(releases.map(\.version) == ["2.0"])
    #expect(releases.first?.new.first?.title == "Remote")
}

@Test func releaseNotesLoaderRejectsNonSuccessfulHTTPStatusCodes() async throws {
    let url = try #require(URL(string: "https://example.com/releases.json"))

    for statusCode in [199, 300, 404, 500] {
        let response = try makeHTTPResponse(url: url, statusCode: statusCode)

        do {
            _ = try await SwiftNEWReleaseNotesLoader.load(
                from: url.absoluteString,
                bundle: .module,
                remoteDataLoader: { _ in (remoteReleaseData(), response) }
            )
            Issue.record("Expected status \(statusCode) to be rejected")
        } catch let error as URLError {
            #expect(error.code == .badServerResponse)
        } catch {
            Issue.record("Expected URLError for status \(statusCode), received \(error)")
        }
    }
}

@Test func releaseNotesLoaderRejectsNonHTTPRemoteResponses() async throws {
    let url = try #require(URL(string: "https://example.com/releases.json"))
    let response = URLResponse(
        url: url,
        mimeType: "application/json",
        expectedContentLength: remoteReleaseData().count,
        textEncodingName: "utf-8"
    )

    do {
        _ = try await SwiftNEWReleaseNotesLoader.load(
            from: url.absoluteString,
            bundle: .module,
            remoteDataLoader: { _ in (remoteReleaseData(), response) }
        )
        Issue.record("Expected a non-HTTP response to be rejected")
    } catch let error as URLError {
        #expect(error.code == .badServerResponse)
    } catch {
        Issue.record("Expected URLError, received \(error)")
    }
}

@Test func releaseNotesLoaderPropagatesTransportAndDecodingErrors() async throws {
    let url = try #require(URL(string: "https://example.com/releases.json"))

    do {
        _ = try await SwiftNEWReleaseNotesLoader.load(
            from: url.absoluteString,
            bundle: .module,
            remoteDataLoader: { _ in throw LoaderStubError.offline }
        )
        Issue.record("Expected the transport error to be propagated")
    } catch LoaderStubError.offline {
        // Expected.
    } catch {
        Issue.record("Expected LoaderStubError.offline, received \(error)")
    }

    let response = try makeHTTPResponse(url: url, statusCode: 299)
    do {
        _ = try await SwiftNEWReleaseNotesLoader.load(
            from: url.absoluteString,
            bundle: .module,
            remoteDataLoader: { _ in (Data("not-json".utf8), response) }
        )
        Issue.record("Expected malformed JSON to be rejected")
    } catch is DecodingError {
        // Expected.
    } catch {
        Issue.record("Expected DecodingError, received \(error)")
    }
}

@Test func releaseNotesLoaderReportsMissingBundledJSON() async {
    do {
        _ = try await SwiftNEWReleaseNotesLoader.load(
            from: "missing-swiftnew-release-notes",
            bundle: .module
        )
        #expect(Bool(false), "Expected a missing-file error")
    } catch let error as CocoaError {
        #expect(error.code == .fileNoSuchFile)
    } catch {
        #expect(Bool(false), "Expected CocoaError, received \(error)")
    }
}

private enum LoaderStubError: Error {
    case offline
}

private func makeHTTPResponse(url: URL, statusCode: Int) throws -> HTTPURLResponse {
    try #require(
        HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        )
    )
}

private func remoteReleaseData() -> Data {
    Data(
        """
        [
          {
            "version": "2.0",
            "new": [
              {
                "icon": "sparkles",
                "title": "Remote",
                "subtitle": "Loaded without the network",
                "body": "Deterministic response"
              }
            ]
          }
        ]
        """.utf8
    )
}

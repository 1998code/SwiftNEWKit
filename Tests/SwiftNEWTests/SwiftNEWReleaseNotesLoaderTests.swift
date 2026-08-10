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

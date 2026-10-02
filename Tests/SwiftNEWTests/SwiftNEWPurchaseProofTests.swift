//
//  SwiftNEWPurchaseProofTests.swift
//  SwiftNEW
//

import CryptoKit
import Foundation
import Testing
@testable import SwiftNEW

@Test func proofEnvironmentsParseAndOnlySandboxFailsTheRequirement() {
    #expect(SwiftNEWPurchaseProof.Environment("Production") == .production)
    #expect(SwiftNEWPurchaseProof.Environment("sandbox") == .sandbox)
    #expect(SwiftNEWPurchaseProof.Environment("Xcode") == .xcode)
    #expect(SwiftNEWPurchaseProof.Environment("LocalTesting") == nil)
    #expect(SwiftNEWPurchaseProof.Environment(nil) == nil)

    #expect(SwiftNEWPurchaseProof.Environment.production.satisfiesRequirement)
    #expect(SwiftNEWPurchaseProof.Environment.xcode.satisfiesRequirement)
    #expect(!SwiftNEWPurchaseProof.Environment.sandbox.satisfiesRequirement)

    #expect(SwiftNEWPurchaseProof.kind(for: .appPurchase) == .appPurchase)
    #expect(SwiftNEWPurchaseProof.kind(for: .subscription(productIDs: [])) == .subscription)
    #expect(SwiftNEWPurchaseProof.kind(for: .appPurchaseAndSubscription(productIDs: [])) == nil)
}

@Test func proofPartsDecodeAppAndInAppTransactionClaims() throws {
    let appJWS = makeProofJWS(
        payload: #"{"bundleId":"com.example.app","receiptType":"Production","receiptCreationDate":1700000000000}"#
    ).jws
    let appParts = try #require(SwiftNEWPurchaseProof.parts(of: appJWS))
    #expect(appParts.algorithm == "ES256")
    #expect(appParts.certificateChain.count == 2)
    #expect(appParts.payload.resolvedEnvironment == .production)
    #expect(appParts.payload.signingDate == Date(timeIntervalSince1970: 1_700_000_000))
    #expect(appParts.payload.productId == nil)

    let subscriptionJWS = makeProofJWS(
        payload: #"{"bundleId":"com.example.app","environment":"Sandbox","productId":"pro","signedDate":1700000001000}"#
    ).jws
    let subscriptionParts = try #require(SwiftNEWPurchaseProof.parts(of: subscriptionJWS))
    #expect(subscriptionParts.payload.resolvedEnvironment == .sandbox)
    #expect(subscriptionParts.payload.signingDate == Date(timeIntervalSince1970: 1_700_000_001))

    #expect(SwiftNEWPurchaseProof.parts(of: "not-a-jws") == nil)
    #expect(SwiftNEWPurchaseProof.parts(of: "a.b") == nil)
    #expect(SwiftNEWPurchaseProof.parts(of: "!!.!!.!!") == nil)
    #expect(SwiftNEWPurchaseProof.parts(of: makeProofJWS(payload: "{}", x5c: ["%%%"]).jws) == nil)
    #expect(SwiftNEWPurchaseProof.base64URLDecoded("-_8") == Data([0xFB, 0xFF]))
}

@Test func proofSignatureMustComeFromTheSigningKey() throws {
    let signed = makeProofJWS(payload: #"{"bundleId":"com.example.app"}"#)
    let parts = try #require(SwiftNEWPurchaseProof.parts(of: signed.jws))
    let otherKey = P256.Signing.PrivateKey().publicKey.x963Representation

    #expect(SwiftNEWPurchaseProof.isSignatureValid(
        parts.signature,
        signingInput: parts.signingInput,
        x963PublicKey: signed.publicKey
    ))
    #expect(!SwiftNEWPurchaseProof.isSignatureValid(
        parts.signature,
        signingInput: parts.signingInput,
        x963PublicKey: otherKey
    ))
    #expect(!SwiftNEWPurchaseProof.isSignatureValid(
        parts.signature,
        signingInput: Data("tampered".utf8),
        x963PublicKey: signed.publicKey
    ))
    #expect(!SwiftNEWPurchaseProof.isSignatureValid(
        Data([1, 2, 3]),
        signingInput: parts.signingInput,
        x963PublicKey: signed.publicKey
    ))
    #expect(!SwiftNEWPurchaseProof.isSignatureValid(
        parts.signature,
        signingInput: parts.signingInput,
        x963PublicKey: Data([4, 5, 6])
    ))
}

@Test func proofChainMustEndInThePinnedAppleRoot() throws {
    let root = try #require(Data(base64Encoded: appleRootCAG3))
    let intermediate = try #require(Data(base64Encoded: appleWWDRCAG6))
    let pin = SwiftNEWPurchaseProof.appleRootCAG3SHA256

    #expect(SwiftNEWPurchaseProof.sha256Hex(root) == pin)

    // Apple's real intermediate chains to the real pinned root.
    #expect(SwiftNEWPurchaseProof.trustedLeafKey(
        in: [intermediate, root],
        rootSHA256: pin,
        verifyDate: Date(timeIntervalSince1970: 1_750_000_000)
    ) != nil)
    #expect(SwiftNEWPurchaseProof.trustedLeafKey(
        in: [intermediate, root],
        rootSHA256: pin.uppercased(),
        verifyDate: nil
    ) != nil)

    // Before the intermediate existed the chain was not valid.
    #expect(SwiftNEWPurchaseProof.trustedLeafKey(
        in: [intermediate, root],
        rootSHA256: pin,
        verifyDate: Date(timeIntervalSince1970: 1_000_000_000)
    ) == nil)
    // A different pin, a missing root, an unrelated leaf, and junk all fail.
    #expect(SwiftNEWPurchaseProof.trustedLeafKey(
        in: [intermediate, root],
        rootSHA256: String(repeating: "0", count: 64),
        verifyDate: nil
    ) == nil)
    #expect(SwiftNEWPurchaseProof.trustedLeafKey(in: [root], rootSHA256: pin, verifyDate: nil) == nil)
    #expect(SwiftNEWPurchaseProof.trustedLeafKey(in: [], rootSHA256: pin, verifyDate: nil) == nil)
    #expect(SwiftNEWPurchaseProof.trustedLeafKey(
        in: [Data([1, 2, 3]), root],
        rootSHA256: pin,
        verifyDate: nil
    ) == nil)
}

@Test func forgedProofsAreRejectedEvenWithAValidSignature() {
    // Signed correctly, but by a key Apple never certified.
    let selfSigned = makeProofJWS(
        payload: #"{"bundleId":"com.example.app","receiptType":"Production"}"#
    )
    #expect(SwiftNEWPurchaseProof.verifiedPayload(of: selfSigned.jws) == nil)

    // Apple's real chain, but the signature is not from its leaf key.
    let borrowedChain = makeProofJWS(
        payload: #"{"bundleId":"com.example.app","receiptType":"Production"}"#,
        x5c: [appleWWDRCAG6, appleRootCAG3]
    )
    #expect(SwiftNEWPurchaseProof.verifiedPayload(of: borrowedChain.jws) == nil)

    let wrongAlgorithm = makeProofJWS(payload: "{}", algorithm: "none")
    #expect(SwiftNEWPurchaseProof.verifiedPayload(of: wrongAlgorithm.jws) == nil)
    #expect(SwiftNEWPurchaseProof.verifiedPayload(of: "garbage") == nil)
}

@Test func proofPolicyRequiresProductionThisAppAndAnUnexpiredProduct() {
    let now = Date(timeIntervalSince1970: 1_700_000_000)
    let bundle = "com.example.app"
    let subscription = SwiftNEWPurchaseRequirement.subscription(productIDs: ["pro"])

    func satisfies(
        _ payload: SwiftNEWPurchaseProofPayload,
        _ requirement: SwiftNEWPurchaseRequirement,
        bundle: String? = "com.example.app"
    ) -> Bool {
        SwiftNEWPurchaseProof.satisfies(payload, requirement: requirement, bundleIdentifier: bundle, now: now)
    }

    let app = SwiftNEWPurchaseProofPayload(bundleId: bundle, receiptType: "Production")
    #expect(satisfies(app, .appPurchase))
    #expect(!satisfies(app, .appPurchase, bundle: "com.example.other"))
    #expect(!satisfies(app, .appPurchase, bundle: nil))
    #expect(!satisfies(SwiftNEWPurchaseProofPayload(bundleId: bundle, receiptType: "Sandbox"), .appPurchase))
    #expect(!satisfies(SwiftNEWPurchaseProofPayload(bundleId: bundle), .appPurchase))
    #expect(!satisfies(app, subscription))
    #expect(!satisfies(app, .appPurchaseAndSubscription(productIDs: ["pro"])))

    var active = SwiftNEWPurchaseProofPayload(bundleId: bundle, environment: "Production", productId: "pro")
    #expect(satisfies(active, subscription))
    // An in-app transaction never proves the app purchase itself.
    #expect(!satisfies(active, .appPurchase))
    #expect(!satisfies(active, .subscription(productIDs: ["other"])))

    active.expiresDate = 1_700_000_001_000
    #expect(satisfies(active, subscription))
    active.expiresDate = 1_699_999_999_000
    #expect(!satisfies(active, subscription))

    active.expiresDate = nil
    active.revocationDate = 1_600_000_000_000
    #expect(!satisfies(active, subscription))
}

/// Builds a compact JWS signed by a throwaway P-256 key.
private func makeProofJWS(
    payload: String,
    algorithm: String = "ES256",
    x5c: [String] = ["AQID", "BAUG"]
) -> (jws: String, publicKey: Data) {
    func base64URL(_ data: Data) -> String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    let chain = x5c.map { "\"\($0)\"" }.joined(separator: ",")
    let header = "{\"alg\":\"\(algorithm)\",\"x5c\":[\(chain)]}"
    let signingInput = base64URL(Data(header.utf8)) + "." + base64URL(Data(payload.utf8))
    let key = P256.Signing.PrivateKey()
    // Signing a fresh message with a fresh key cannot fail.
    let signature = try! key.signature(for: Data(signingInput.utf8))

    return (
        signingInput + "." + base64URL(signature.rawRepresentation),
        key.publicKey.x963Representation
    )
}

// Apple's public certificates, from https://www.apple.com/certificateauthority/
private let appleRootCAG3 = "MIICQzCCAcmgAwIBAgIILcX8iNLFS5UwCgYIKoZIzj0EAwMwZzEbMBkGA1UEAwwSQXBwbGUgUm9vdCBDQSAtIEczMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwHhcNMTQwNDMwMTgxOTA2WhcNMzkwNDMwMTgxOTA2WjBnMRswGQYDVQQDDBJBcHBsZSBSb290IENBIC0gRzMxJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRMwEQYDVQQKDApBcHBsZSBJbmMuMQswCQYDVQQGEwJVUzB2MBAGByqGSM49AgEGBSuBBAAiA2IABJjpLz1AcqTtkyJygRMc3RCV8cWjTnHcFBbZDuWmBSp3ZHtfTjjTuxxEtX/1H7YyYl3J6YRbTzBPEVoA/VhYDKX1DyxNB0cTddqXl5dvMVztK517IDvYuVTZXpmkOlEKMaNCMEAwHQYDVR0OBBYEFLuw3qFYM4iapIqZ3r6966/ayySrMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMAoGCCqGSM49BAMDA2gAMGUCMQCD6cHEFl4aXTQY2e3v9GwOAEZLuN+yRhHFD/3meoyhpmvOwgPUnPWTxnS4at+qIxUCMG1mihDK1A3UT82NQz60imOlM27jbdoXt2QfyFMm+YhidDkLF1vLUagM6BgD56KyKA=="
private let appleWWDRCAG6 = "MIIDFjCCApygAwIBAgIUIsGhRwp0c2nvU4YSycafPTjzbNcwCgYIKoZIzj0EAwMwZzEbMBkGA1UEAwwSQXBwbGUgUm9vdCBDQSAtIEczMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwHhcNMjEwMzE3MjAzNzEwWhcNMzYwMzE5MDAwMDAwWjB1MUQwQgYDVQQDDDtBcHBsZSBXb3JsZHdpZGUgRGV2ZWxvcGVyIFJlbGF0aW9ucyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTELMAkGA1UECwwCRzYxEzARBgNVBAoMCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTMHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEbsQKC94PrlWmZXnXgtxzdVJL8T0SGYngDRGpngn3N6PT8JMEb7FDi4bBmPhCnZ3/sq6PF/cGcKXWsL5vOteRhyJ45x3ASP7cOB+aao90fcpxSv/EZFbniAbNgZGhIhpIo4H6MIH3MBIGA1UdEwEB/wQIMAYBAf8CAQAwHwYDVR0jBBgwFoAUu7DeoVgziJqkipnevr3rr9rLJKswRgYIKwYBBQUHAQEEOjA4MDYGCCsGAQUFBzABhipodHRwOi8vb2NzcC5hcHBsZS5jb20vb2NzcDAzLWFwcGxlcm9vdGNhZzMwNwYDVR0fBDAwLjAsoCqgKIYmaHR0cDovL2NybC5hcHBsZS5jb20vYXBwbGVyb290Y2FnMy5jcmwwHQYDVR0OBBYEFD8vlCNR01DJmig97bB85c+lkGKZMA4GA1UdDwEB/wQEAwIBBjAQBgoqhkiG92NkBgIBBAIFADAKBggqhkjOPQQDAwNoADBlAjBAXhSq5IyKogMCPtw490BaB677CaEGJXufQB/EqZGd6CSjiCtOnuMTbXVXmxxcxfkCMQDTSPxarZXvNrkxU3TkUMI33yzvFVVRT4wxWJC994OsdcZ4+RGNsYDyR5gmdr0nDGg="

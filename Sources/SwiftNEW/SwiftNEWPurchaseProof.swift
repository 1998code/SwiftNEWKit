//
//  SwiftNEWPurchaseProof.swift
//  SwiftNEW
//

import CryptoKit
import Foundation
import Security

/// The claims SwiftNEW reads from an App Store signed transaction.
///
/// App transactions name the environment `receiptType` and their signing date
/// `receiptCreationDate`; in-app transactions use `environment` and
/// `signedDate`. Dates are milliseconds since 1970.
struct SwiftNEWPurchaseProofPayload: Decodable, Equatable, Sendable {
    var bundleId: String?
    var environment: String?
    var receiptType: String?
    var productId: String?
    var expiresDate: Double?
    var revocationDate: Double?
    var signedDate: Double?
    var receiptCreationDate: Double?

    var resolvedEnvironment: SwiftNEWPurchaseProof.Environment? {
        SwiftNEWPurchaseProof.Environment(environment ?? receiptType)
    }

    var signingDate: Date? {
        (signedDate ?? receiptCreationDate).map { Date(timeIntervalSince1970: $0 / 1_000) }
    }
}

/// A production purchase carried into builds whose StoreKit cannot see it.
///
/// TestFlight builds talk to the StoreKit sandbox, so they cannot tell whether
/// the tester bought anything in the App Store version. The App Store version
/// therefore keeps the App Store signed JWS of its verified production
/// purchase, and a later TestFlight build of the same app re-verifies that
/// signature instead of trusting a flag anyone could write.
enum SwiftNEWPurchaseProof {
    enum Environment: Equatable, Sendable {
        case production
        case sandbox
        case xcode

        init?(_ rawValue: String?) {
            switch rawValue?.lowercased() {
            case "production": self = .production
            case "sandbox": self = .sandbox
            case "xcode": self = .xcode
            default: return nil
            }
        }

        /// Sandbox purchases are free, so they never satisfy a requirement.
        var satisfiesRequirement: Bool {
            self != .sandbox
        }
    }

    enum Kind: String, Sendable {
        case appPurchase = "app"
        case subscription
    }

    struct Parts: Equatable, Sendable {
        let algorithm: String?
        let certificateChain: [Data]
        let payload: SwiftNEWPurchaseProofPayload
        let signingInput: Data
        let signature: Data
    }

    private struct Header: Decodable {
        let alg: String?
        let x5c: [String]?
    }

    /// SHA-256 of the DER encoding of "Apple Root CA - G3".
    static let appleRootCAG3SHA256 = "63343abfb89a6a03ebb57e9b3f5fa7be7c4f5c756f3017b3a8c488c3653e9179"

    static func parts(of jws: String) -> Parts? {
        let segments = jws.split(separator: ".", omittingEmptySubsequences: false)
        guard segments.count == 3,
              let headerData = base64URLDecoded(segments[0]),
              let payloadData = base64URLDecoded(segments[1]),
              let signature = base64URLDecoded(segments[2]),
              let header = try? JSONDecoder().decode(Header.self, from: headerData),
              let payload = try? JSONDecoder().decode(SwiftNEWPurchaseProofPayload.self, from: payloadData)
        else { return nil }

        let certificateChain = (header.x5c ?? []).compactMap { Data(base64Encoded: $0) }
        guard certificateChain.count == (header.x5c ?? []).count else { return nil }

        return Parts(
            algorithm: header.alg,
            certificateChain: certificateChain,
            payload: payload,
            signingInput: Data("\(segments[0]).\(segments[1])".utf8),
            signature: signature
        )
    }

    /// The payload of a JWS only when the App Store signed it: the certificate
    /// chain must end in the pinned Apple root and the leaf key must have
    /// produced the signature.
    static func verifiedPayload(
        of jws: String,
        rootSHA256: String = appleRootCAG3SHA256
    ) -> SwiftNEWPurchaseProofPayload? {
        guard let parts = parts(of: jws),
              parts.algorithm == "ES256",
              let leafKey = trustedLeafKey(
                in: parts.certificateChain,
                rootSHA256: rootSHA256,
                verifyDate: parts.payload.signingDate
              ),
              isSignatureValid(
                parts.signature,
                signingInput: parts.signingInput,
                x963PublicKey: leafKey
              )
        else { return nil }

        return parts.payload
    }

    /// Evaluates the chain against the pinned root and returns the leaf's
    /// public key in ANSI X9.63 form.
    static func trustedLeafKey(
        in certificateChain: [Data],
        rootSHA256: String,
        verifyDate: Date?
    ) -> Data? {
        guard certificateChain.count >= 2,
              let rootData = certificateChain.last,
              sha256Hex(rootData) == rootSHA256.lowercased()
        else { return nil }

        let certificates = certificateChain.compactMap {
            SecCertificateCreateWithData(nil, $0 as CFData)
        }
        guard certificates.count == certificateChain.count,
              let root = certificates.last
        else { return nil }

        var trust: SecTrust?
        guard SecTrustCreateWithCertificates(
            Array(certificates.dropLast()) as CFArray,
            SecPolicyCreateBasicX509(),
            &trust
        ) == errSecSuccess, let trust else { return nil }

        // A stored proof outlives its short-lived leaf certificate, so the
        // chain is judged as of the moment the App Store signed it.
        if let verifyDate {
            SecTrustSetVerifyDate(trust, verifyDate as CFDate)
        }
        guard SecTrustSetAnchorCertificates(trust, [root] as CFArray) == errSecSuccess,
              SecTrustSetAnchorCertificatesOnly(trust, true) == errSecSuccess,
              SecTrustEvaluateWithError(trust, nil),
              let key = SecCertificateCopyKey(certificates[0]),
              let keyData = SecKeyCopyExternalRepresentation(key, nil)
        else { return nil }

        return keyData as Data
    }

    static func isSignatureValid(
        _ signature: Data,
        signingInput: Data,
        x963PublicKey: Data
    ) -> Bool {
        guard let key = try? P256.Signing.PublicKey(x963Representation: x963PublicKey),
              let signature = try? P256.Signing.ECDSASignature(rawRepresentation: signature)
        else { return false }

        return key.isValidSignature(signature, for: signingInput)
    }

    /// Whether a verified payload proves the requirement for this app, now.
    static func satisfies(
        _ payload: SwiftNEWPurchaseProofPayload,
        requirement: SwiftNEWPurchaseRequirement,
        bundleIdentifier: String?,
        now: Date
    ) -> Bool {
        guard payload.resolvedEnvironment == .production,
              let bundleIdentifier,
              payload.bundleId == bundleIdentifier
        else { return false }

        switch requirement {
        case .appPurchase:
            // An in-app transaction is not proof of buying the app itself.
            return payload.productId == nil
        case .subscription:
            guard let productID = payload.productId,
                  SwiftNEWPurchaseEntitlement.satisfies(
                    requirement,
                    productID: productID,
                    isRevoked: payload.revocationDate != nil
                  )
            else { return false }

            guard let expiresDate = payload.expiresDate else { return true }
            return Date(timeIntervalSince1970: expiresDate / 1_000) > now
        case .appPurchaseAndSubscription:
            return false
        }
    }

    static func kind(for requirement: SwiftNEWPurchaseRequirement) -> Kind? {
        switch requirement {
        case .appPurchase: return .appPurchase
        case .subscription: return .subscription
        case .appPurchaseAndSubscription: return nil
        }
    }

    static func sha256Hex(_ data: Data) -> String {
        SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }

    static func base64URLDecoded<S: StringProtocol>(_ value: S) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        base64 += String(repeating: "=", count: (4 - base64.count % 4) % 4)
        return Data(base64Encoded: base64)
    }
}

/// Keeps the signed proof in the keychain, readable by later builds of the
/// same app on this device only.
enum SwiftNEWPurchaseProofStore {
    private static let service = "swiftnew.purchase-proof"

    // LCOV_EXCL_START -- The keychain is unavailable to the unsigned package test runners.
    static func load(_ kind: SwiftNEWPurchaseProof.Kind) -> String? {
        var query = baseQuery(for: kind)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data
        else { return nil }
        return String(data: data, encoding: .utf8)
    }

    static func save(_ jws: String, for kind: SwiftNEWPurchaseProof.Kind) {
        let query = baseQuery(for: kind)
        let attributes: [String: Any] = [
            kSecValueData as String: Data(jws.utf8),
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]

        if SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == errSecItemNotFound {
            SecItemAdd(query.merging(attributes) { $1 } as CFDictionary, nil)
        }
    }

    private static func baseQuery(for kind: SwiftNEWPurchaseProof.Kind) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: kind.rawValue
        ]
    }
    // LCOV_EXCL_STOP
}

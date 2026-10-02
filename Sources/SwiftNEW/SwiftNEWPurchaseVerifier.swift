//
//  SwiftNEWPurchaseVerifier.swift
//  SwiftNEW
//

import Foundation
import StoreKit

/// Live StoreKit 2 checks behind `purchaseRequirement`.
///
/// A requirement is met by a verified StoreKit result from the production (or
/// Xcode StoreKit-testing) environment. Sandbox results never count: TestFlight
/// and development builds get them for free. Those builds are satisfied instead
/// by the signed proof an App Store build of the same app stored earlier.
///
/// StoreKit only answers inside a signed App Store, TestFlight, sandbox, or
/// StoreKit-testing host, so these paths cannot run on the coverage runners.
enum SwiftNEWPurchaseVerifier {
    // LCOV_EXCL_START -- StoreKit is unavailable to the package test runners.
    static func isSatisfied(_ requirement: SwiftNEWPurchaseRequirement) async throws -> Bool {
        switch requirement {
        case .appPurchaseAndSubscription:
            for component in requirement.components where try await !isSatisfied(component) {
                return false
            }
            return true
        case .appPurchase:
            // AppTransaction needs iOS 16 / watchOS 9; older systems cannot
            // verify the purchase, so they are never locked out by it.
            guard #available(iOS 16.0, watchOS 9.0, macOS 13.0, tvOS 16.0, *) else { return true }

            var failure: Error?
            do {
                let result = try await AppTransaction.shared
                if case let .verified(transaction) = result,
                   accept(
                    jws: result.jwsRepresentation,
                    environment: transaction.environment.rawValue,
                    as: .appPurchase
                   ) {
                    return true
                }
            } catch {
                failure = error
            }

            if hasStoredProof(of: requirement) { return true }
            if let failure { throw failure }
            return false
        case .subscription:
            for await result in StoreKit.Transaction.currentEntitlements {
                guard case let .verified(transaction) = result,
                      SwiftNEWPurchaseEntitlement.satisfies(
                        requirement,
                        productID: transaction.productID,
                        isRevoked: transaction.revocationDate != nil
                      )
                else { continue }

                if accept(
                    jws: result.jwsRepresentation,
                    environment: environment(of: transaction, jws: result.jwsRepresentation),
                    as: .subscription
                ) {
                    return true
                }
            }
            return hasStoredProof(of: requirement)
        }
    }

    /// Counts a verified StoreKit result unless it came from the sandbox, and
    /// keeps the signed production result as proof for later TestFlight builds.
    private static func accept(
        jws: String,
        environment: String?,
        as kind: SwiftNEWPurchaseProof.Kind
    ) -> Bool {
        guard let environment = SwiftNEWPurchaseProof.Environment(environment),
              environment.satisfiesRequirement
        else { return false }

        if environment == .production {
            SwiftNEWPurchaseProofStore.save(jws, for: kind)
        }
        return true
    }

    private static func environment(of transaction: StoreKit.Transaction, jws: String) -> String? {
        if #available(iOS 16.0, watchOS 9.0, macOS 13.0, tvOS 16.0, *) {
            return transaction.environment.rawValue
        }
        return SwiftNEWPurchaseProof.parts(of: jws)?.payload.environment
    }

    private static func hasStoredProof(of requirement: SwiftNEWPurchaseRequirement) -> Bool {
        guard let kind = SwiftNEWPurchaseProof.kind(for: requirement),
              let jws = SwiftNEWPurchaseProofStore.load(kind),
              let payload = SwiftNEWPurchaseProof.verifiedPayload(of: jws)
        else { return false }

        return SwiftNEWPurchaseProof.satisfies(
            payload,
            requirement: requirement,
            bundleIdentifier: Bundle.main.bundleIdentifier,
            now: Date()
        )
    }

    static func restore() async throws {
        try await AppStore.sync()
    }

    static func updates() -> AsyncStream<Void> {
        AsyncStream { continuation in
            let task = Task {
                for await _ in StoreKit.Transaction.updates {
                    continuation.yield()
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }
    // LCOV_EXCL_STOP
}

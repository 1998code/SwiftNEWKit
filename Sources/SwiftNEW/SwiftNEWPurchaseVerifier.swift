//
//  SwiftNEWPurchaseVerifier.swift
//  SwiftNEW
//

import Foundation
import StoreKit

/// Live StoreKit 2 checks behind `purchaseRequirement`.
///
/// StoreKit only answers inside a signed App Store, TestFlight, sandbox, or
/// StoreKit-testing host, so these paths cannot run on the coverage runners.
enum SwiftNEWPurchaseVerifier {
    // LCOV_EXCL_START -- StoreKit is unavailable to the package test runners.
    static func isSatisfied(_ requirement: SwiftNEWPurchaseRequirement) async throws -> Bool {
        switch requirement {
        case .appPurchase:
            // AppTransaction needs iOS 16 / watchOS 9; older systems cannot
            // verify the purchase, so they are never locked out by it.
            guard #available(iOS 16.0, watchOS 9.0, macOS 13.0, tvOS 16.0, *) else { return true }
            if case .verified = try await AppTransaction.shared { return true }
            return false
        case .appPurchaseAndSubscription:
            for component in requirement.components where try await !isSatisfied(component) {
                return false
            }
            return true
        case .subscription:
            for await result in StoreKit.Transaction.currentEntitlements {
                guard case let .verified(transaction) = result else { continue }
                if SwiftNEWPurchaseEntitlement.satisfies(
                    requirement,
                    productID: transaction.productID,
                    isRevoked: transaction.revocationDate != nil
                ) {
                    return true
                }
            }
            return false
        }
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

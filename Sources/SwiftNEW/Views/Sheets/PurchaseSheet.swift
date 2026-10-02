//
//  PurchaseSheet.swift
//  SwiftNEW
//

import SwiftUI
import SwiftVB

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {

    // MARK: - Purchase Required View
    @ViewBuilder
    public var sheetPurchase: some View {
        if purchaseCheckPhase == .required {
            #if os(watchOS)
            watchPurchaseContent
            #else
            purchaseContent
            #endif
        } else {
            sheetPurchaseChecking
        }
    }

    @ViewBuilder
    public var sheetPurchaseChecking: some View {
        #if os(watchOS)
        ScrollView {
            purchaseCheckingContent
        }
        #else
        purchaseCheckingContent
        #endif
    }

    private var purchaseCheckingContent: some View {
        VStack(spacing: 18) {
            Spacer()
            Image(systemName: "lock.shield")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(String(localized: "Verifying Purchase...", bundle: .module))
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)
            ProgressView()
            Spacer()
        }
        .padding()
        #if os(macOS)
        .frame(width: 600, height: 600)
        #elseif os(tvOS)
        .frame(width: 600)
        #endif
    }

    private var watchPurchaseContent: some View {
        ScrollView {
            VStack(alignment: align, spacing: 14) {
                purchaseHeading
                Text(purchaseMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(textAlignment)

                if let purchaseErrorMessage {
                    Text(purchaseErrorMessage)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                if showsRestorePurchases {
                    restorePurchasesButton
                }
                if canPerformPurchase {
                    purchaseNowButton
                }
                if purchaseErrorMessage != nil || !canPerformPurchase {
                    retryPurchaseCheckButton
                }
            }
            .padding(.vertical)
        }
    }

    private var purchaseContent: some View {
        VStack(spacing: 0) {
            if showsRestorePurchases {
                restorePurchasesButton
                    .frame(minHeight: 44)
                    .padding(.top, 12)
                    .modifier(SwiftNEWUpdateEntranceModifier(delay: 0.16))
            }

            Spacer(minLength: 0)

            VStack(alignment: align, spacing: 28) {
                purchaseHero
                    .accessibilityHidden(true)
                    .modifier(SwiftNEWUpdateEntranceModifier(delay: 0))

                VStack(alignment: align, spacing: 10) {
                    Text(purchaseTitle)
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.primary)
                    Text(purchaseMessage)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(textAlignment)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityElement(children: .combine)
                .modifier(SwiftNEWUpdateEntranceModifier(delay: 0.08))
            }
            .frame(maxWidth: 420, alignment: frameAlignment)
            .padding(.horizontal, 32)
            .padding(.vertical, 28)
            .frame(maxWidth: .infinity)

            // Two trailing spacers keep the hero above the optical center.
            Spacer(minLength: 0)
            Spacer(minLength: 0)

            purchaseActionArea
                .modifier(SwiftNEWUpdateEntranceModifier(delay: 0.16))
        }
        #if os(macOS)
        .frame(width: 600, height: 600)
        #elseif os(tvOS)
        .frame(width: 600)
        #endif
    }

    /// The App Store icon of the listing with a lock badge; the lock badge
    /// alone until the artwork loads or when the lookup has no result.
    @ViewBuilder
    private var purchaseHero: some View {
        if let purchaseAppIconURL {
            AsyncImage(url: purchaseAppIconURL) { phase in
                if let image = phase.image {
                    purchaseAppIcon(image)
                } else {
                    purchaseLockBadge
                }
            }
        } else {
            purchaseLockBadge
        }
    }

    private var purchaseLockBadge: some View {
        iconBadge(systemNames: ["lock.fill", "lock.open.fill"])
            .scaleEffect(1.25)
            .frame(width: 96, height: 96)
    }

    private func purchaseAppIcon(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 96, height: 96)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: .black.opacity(0.12), radius: 12, y: 6)
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "lock.fill")
                    .font(.footnote.weight(.bold))
                    .foregroundStyle(resolvedButtonTextColor)
                    .frame(width: 32, height: 32)
                    .background(colorGradient, in: Circle())
                    .overlay {
                        Circle().stroke(.background, lineWidth: 2)
                    }
                    .offset(x: 8, y: 8)
            }
    }

    private var purchaseHeading: some View {
        VStack(alignment: align, spacing: 10) {
            iconBadge(systemNames: ["lock.fill"])
                .scaleEffect(0.875)
                .frame(width: 56, height: 56)
                .accessibilityHidden(true)
            Text(purchaseTitle)
                .font(.title.weight(.bold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(textAlignment)
        }
        .frame(maxWidth: .infinity, alignment: frameAlignment)
        .accessibilityElement(children: .combine)
    }

    /// Restoring applies to in-app purchases; the app's own purchase is tied
    /// to the App Store account and has nothing to restore.
    private var showsRestorePurchases: Bool {
        displayedPurchaseRequirement != .appPurchase
    }

    private var purchaseTitle: String {
        displayedPurchaseRequirement == .appPurchase
            ? String(localized: "Purchase Required", bundle: .module)
            : String(localized: "Subscription Required", bundle: .module)
    }

    private var purchaseMessage: String {
        displayedPurchaseRequirement == .appPurchase
            ? String(localized: "Purchase this app on the App Store to continue.", bundle: .module)
            : String(localized: "An active subscription is required to continue.", bundle: .module)
    }

    private var purchaseActionArea: some View {
        VStack(spacing: 10) {
            if let purchaseErrorMessage {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                        .accessibilityHidden(true)
                    Text(purchaseErrorMessage)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 4)
                    Button(action: retryPurchaseCheck) {
                        Text(String(localized: "Try Again", bundle: .module))
                            .fontWeight(.semibold)
                            .foregroundStyle(color)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(color.opacity(0.14), in: Capsule())
                            .contentShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .font(.footnote)
                .padding(.leading, 12)
                .padding(.trailing, 8)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    Color.secondary.opacity(0.08),
                    in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                )
            }

            if canPerformPurchase {
                purchaseNowButton
            } else if purchaseErrorMessage == nil {
                retryPurchaseCheckButton
            }
        }
        .frame(maxWidth: 380)
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity)
    }

    #if DEBUG
    /// Exercises the watch-specific composition from host-platform tests;
    /// production routing remains controlled by the platform check in
    /// `sheetPurchase`.
    var testingWatchPurchaseContent: some View {
        watchPurchaseContent
    }

    /// Renders the artwork treatment without waiting on a network image.
    var testingPurchaseAppIcon: some View {
        purchaseAppIcon(Image(systemName: "app.fill"))
    }
    #endif
}

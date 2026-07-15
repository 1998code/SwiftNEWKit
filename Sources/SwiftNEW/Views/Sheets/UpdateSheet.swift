//
//  UpdateSheet.swift
//  SwiftNEW
//

import SwiftUI
import SwiftVB

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {

    @ViewBuilder
    public var sheetUpdateChecking: some View {
        #if os(watchOS)
        ScrollView {
            updateCheckingContent
        }
        #else
        updateCheckingContent
        #endif
    }

    private var updateCheckingContent: some View {
        VStack(spacing: 18) {
            Spacer()
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(String(localized: "Checking for Updates...", bundle: .module))
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)
            ProgressView()
            if allowsSkippingUpdate, presentation != .embed {
                dismissUpdateButton
                    .padding(.top, 8)
            }
            Spacer()
        }
        .padding()
        #if os(macOS)
        .frame(width: 600, height: 600)
        #elseif os(tvOS)
        .frame(width: 600)
        #endif
    }

    // MARK: - Available Update View
    @ViewBuilder
    public var sheetUpdate: some View {
        if let availableUpdate {
            #if os(watchOS)
            watchUpdateContent(availableUpdate)
            #elseif os(tvOS)
            GeometryReader { geometry in
                updateContent(availableUpdate, maxScrollHeight: geometry.size.height * 0.45)
            }
            #else
            updateContent(availableUpdate, maxScrollHeight: nil)
            #endif
        }
    }

    private func watchUpdateContent(_ candidate: SwiftNEWUpdateCandidate) -> some View {
        ScrollView {
            VStack(alignment: align, spacing: 14) {
                updateHeading
                updateVersionSummary(latestVersion: candidate.version)

                ForEach(candidate.release.new) { release in
                    releaseRow(release, bodyFont: .footnote, spacing: 2)
                }

                if candidate.appStoreURL != nil {
                    updateNowButton
                } else {
                    if let appStoreLookupErrorMessage {
                        Text(appStoreLookupErrorMessage)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    retryAppStoreLookupButton
                }
                if allowsSkippingUpdate {
                    dismissUpdateButton
                }
            }
            .padding(.vertical)
        }
    }

    private func updateContent(
        _ candidate: SwiftNEWUpdateCandidate,
        maxScrollHeight: CGFloat?
    ) -> some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: align, spacing: 24) {
                    updateHeading
                        .modifier(SwiftNEWUpdateEntranceModifier(delay: 0))

                    updateVersionSummary(latestVersion: candidate.version)
                        .modifier(SwiftNEWUpdateEntranceModifier(delay: 0.08))

                    ForEach(candidate.release.new) { release in
                        updateReleaseCard(release)
                            .modifier(SwiftNEWUpdateEntranceModifier(delay: 0.16))
                    }
                }
                .frame(maxWidth: 420, alignment: frameAlignment)
                .padding(.horizontal, 24)
                .padding(.top, 28)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity)
            }
            #if os(tvOS)
            .frame(maxHeight: maxScrollHeight)
            #endif

            updateActionArea(candidate)
                .modifier(SwiftNEWUpdateEntranceModifier(delay: 0.22))
        }
        #if os(macOS)
        .frame(width: 600, height: 600)
        #elseif os(tvOS)
        .frame(width: 600)
        #endif
    }

    private var updateHeading: some View {
        VStack(alignment: align, spacing: 10) {
            iconBadge(systemNames: ["arrow.down.app.fill"])
                .scaleEffect(0.875)
                .frame(width: 56, height: 56)
                .accessibilityHidden(true)
            Text(String(localized: "Update Available", bundle: .module))
                .font(.title.weight(.bold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(textAlignment)
        }
        .frame(maxWidth: .infinity, alignment: frameAlignment)
        .accessibilityElement(children: .combine)
    }

    private func updateVersionSummary(latestVersion: String) -> some View {
        Group {
            #if os(watchOS)
            VStack(alignment: align, spacing: 12) {
                versionSummaryRow(
                    title: String(localized: "Current Version", bundle: .module),
                    version: Bundle.version
                )
                Divider()
                versionSummaryRow(
                    title: String(localized: "Latest Version", bundle: .module),
                    version: latestVersion
                )
            }
            #else
            HStack(spacing: 10) {
                versionSummaryTile(
                    title: String(localized: "Current Version", bundle: .module),
                    version: Bundle.version,
                    isLatest: false
                )

                Image(systemName: "arrow.forward")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(color)
                    .accessibilityHidden(true)

                versionSummaryTile(
                    title: String(localized: "Latest Version", bundle: .module),
                    version: latestVersion,
                    isLatest: true
                )
            }
            #endif
        }
        #if os(watchOS)
        .padding()
        #else
        .padding(12)
        #endif
        .frame(maxWidth: .infinity, alignment: frameAlignment)
        .modifier(
            SwiftNEWUpdateCardGlassModifier(
                cornerRadius: 16,
                fallbackMaterial: .thin
            )
        )
    }

    private func versionSummaryTile(
        title: String,
        version: String,
        isLatest: Bool
    ) -> some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Text(version)
                .font(.title3.weight(.bold))
                .foregroundStyle(isLatest ? color : Color.primary)
                .monospacedDigit()
                .minimumScaleFactor(0.75)
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .frame(minHeight: 72)
        .frame(maxWidth: .infinity)
        .modifier(
            SwiftNEWLatestVersionTileModifier(
                isLatest: isLatest,
                tint: color,
                cornerRadius: 12
            )
        )
        .accessibilityElement(children: .combine)
    }

    private func updateReleaseCard(_ release: Model) -> some View {
        let contentAlignment: HorizontalAlignment = align == .trailing ? .trailing : .leading
        let contentFrameAlignment: Alignment = align == .trailing ? .trailing : .leading

        return HStack(alignment: .top, spacing: 14) {
            if align == .leading || align == .center {
                updateReleaseIcon(release)
            }

            VStack(alignment: contentAlignment, spacing: 4) {
                Text(release.title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(release.subtitle)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(release.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: contentFrameAlignment)

            if align == .trailing {
                updateReleaseIcon(release)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: frameAlignment)
        .modifier(
            SwiftNEWUpdateCardGlassModifier(
                cornerRadius: 18,
                fallbackMaterial: .ultraThin
            )
        )
        .accessibilityElement(children: .combine)
    }

    private func updateReleaseIcon(_ release: Model) -> some View {
        iconBadge(systemNames: release.iconSequence)
            .scaleEffect(0.75)
            .frame(width: 48, height: 48)
            .accessibilityHidden(true)
    }

    private func updateActionArea(_ candidate: SwiftNEWUpdateCandidate) -> some View {
        VStack(spacing: 10) {
            if candidate.appStoreURL != nil {
                updateNowButton
            } else {
                if let appStoreLookupErrorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                            .accessibilityHidden(true)
                        Text(appStoreLookupErrorMessage)
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color.secondary.opacity(0.08),
                        in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                    )
                    .accessibilityElement(children: .combine)
                }
                retryAppStoreLookupButton
            }

            if allowsSkippingUpdate {
                dismissUpdateButton
                    .frame(minHeight: 44)
            }
        }
        .frame(maxWidth: 380)
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity)
    }

    private func versionSummaryRow(title: String, version: String) -> some View {
        HStack {
            if align == .trailing { Spacer() }
            VStack(alignment: align, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(version)
                    .font(.headline.weight(.semibold))
            }
            if align != .trailing { Spacer() }
        }
    }

    private var frameAlignment: Alignment {
        if align == .leading { return .leading }
        if align == .trailing { return .trailing }
        return .center
    }

    private var textAlignment: TextAlignment {
        if align == .leading { return .leading }
        if align == .trailing { return .trailing }
        return .center
    }
}

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
private struct SwiftNEWUpdateEntranceModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isVisible = false

    let delay: Double

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: reduceMotion || isVisible ? 0 : 14)
            .scaleEffect(reduceMotion || isVisible ? 1 : 0.98)
            .onAppear {
                let animation: Animation = reduceMotion
                    ? .easeOut(duration: 0.2)
                    : .spring(response: 0.5, dampingFraction: 0.86).delay(delay)

                withAnimation(animation) {
                    isVisible = true
                }
            }
            .onDisappear {
                isVisible = false
            }
    }
}

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
private struct SwiftNEWUpdateCardGlassModifier: ViewModifier {
    let cornerRadius: CGFloat
    let fallbackMaterial: SwiftNEWUpdateCardFallbackMaterial

    @ViewBuilder
    func body(content: Content) -> some View {
        #if compiler(>=6.2) && !os(visionOS)
        if #available(iOS 26.0, watchOS 26.0, macOS 26.0, tvOS 26.0, *) {
            content
                .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            fallback(content)
        }
        #else
        fallback(content)
        #endif
    }

    @ViewBuilder
    private func fallback(_ content: Content) -> some View {
        switch fallbackMaterial {
        case .thin:
            fallbackCard(content, material: .thinMaterial)
        case .ultraThin:
            fallbackCard(content, material: .ultraThinMaterial)
        }
    }

    private func fallbackCard(
        _ content: Content,
        material: Material
    ) -> some View {
        content
            .background(
                material,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            }
    }
}

private enum SwiftNEWUpdateCardFallbackMaterial {
    case thin
    case ultraThin
}

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
private struct SwiftNEWLatestVersionTileModifier: ViewModifier {
    let isLatest: Bool
    let tint: Color
    let cornerRadius: CGFloat

    @ViewBuilder
    func body(content: Content) -> some View {
        if isLatest {
            #if compiler(>=6.2) && os(iOS)
            if #available(iOS 26.0, *) {
                content
                    .glassEffect(
                        .regular.tint(tint.opacity(0.1)),
                        in: .rect(cornerRadius: cornerRadius)
                    )
            } else {
                fallback(content)
            }
            #else
            fallback(content)
            #endif
        } else {
            content
        }
    }

    private func fallback(_ content: Content) -> some View {
        content
            .background(
                tint.opacity(0.1),
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
    }
}

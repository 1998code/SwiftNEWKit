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
            .softScrollEdges()
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
                if showDescription {
                    Text(release.body)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
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

    #if DEBUG
    /// Exercises the watch-specific composition from host-platform tests. The
    /// view itself only contains portable SwiftUI primitives; production
    /// routing remains controlled by the platform checks in `sheetUpdate`.
    func testingWatchUpdateContent(_ candidate: SwiftNEWUpdateCandidate) -> some View {
        watchUpdateContent(candidate)
    }

    /// Makes the alignment behavior of the watch-only summary row testable on
    /// the macOS coverage runner without changing its production visibility.
    func testingUpdateVersionSummaryRow(
        title: String = "Version",
        version: String = "1.0"
    ) -> some View {
        versionSummaryRow(title: title, version: version)
    }

    /// Renders every legacy card treatment. These paths are selected by OS
    /// availability in production, so the current-OS coverage runner otherwise
    /// cannot execute them.
    var testingUpdateCardFallbacks: some View {
        VStack {
            SwiftNEWUpdateCardGlassModifier(
                cornerRadius: 16,
                fallbackMaterial: .thin
            )
            .fallback(Text("Thin material"))

            SwiftNEWUpdateCardGlassModifier(
                cornerRadius: 18,
                fallbackMaterial: .ultraThin
            )
            .fallback(Text("Ultra-thin material"))

            SwiftNEWUpdateCardGlassModifier(
                cornerRadius: 12,
                fallbackMaterial: .thin
            )
            .solidFallback(Text("Solid thin fallback"))

            SwiftNEWUpdateCardGlassModifier(
                cornerRadius: 12,
                fallbackMaterial: .ultraThin
            )
            .solidFallback(Text("Solid ultra-thin fallback"))
        }
    }
    #endif
}

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
enum SwiftNEWUpdateEntranceMotion: Equatable {
    case reduced
    case animated(delay: Double)

    init(reduceMotion: Bool, delay: Double) {
        self = reduceMotion ? .reduced : .animated(delay: delay)
    }

    var animation: Animation {
        switch self {
        case .reduced:
            return .easeOut(duration: 0.2)
        case let .animated(delay):
            return .spring(response: 0.5, dampingFraction: 0.86).delay(delay)
        }
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
                let animation = SwiftNEWUpdateEntranceMotion(
                    reduceMotion: reduceMotion,
                    delay: delay
                ).animation

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
            fallback(content) // LCOV_EXCL_LINE: selected only by the runner OS.
        }
        #else
        fallback(content)
        #endif
    }

    @ViewBuilder
    fileprivate func fallback<Content: View>(_ content: Content) -> some View {
        #if os(watchOS)
        if #available(watchOS 10.0, *) {
            materialFallback(content)
        } else {
            solidFallback(content)
        }
        #else
        materialFallback(content)
        #endif
    }

    @ViewBuilder
    @available(watchOS 10.0, *)
    fileprivate func materialFallback<Content: View>(_ content: Content) -> some View {
        switch fallbackMaterial {
        case .thin:
            fallbackCard(content, material: .thinMaterial)
        case .ultraThin:
            fallbackCard(content, material: .ultraThinMaterial)
        }
    }

    fileprivate func solidFallback<Content: View>(_ content: Content) -> some View {
        let opacity = fallbackMaterial == .thin ? 0.16 : 0.1

        return content
            .background(
                Color.secondary.opacity(opacity),
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
            }
    }

    private func fallbackCard<Content: View>(
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

private enum SwiftNEWUpdateCardFallbackMaterial: Equatable {
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

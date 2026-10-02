//
//  ContentView.swift
//  What's New?
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftNEW

enum DemoReleaseNotesSource {
    static let remoteUpdateURL = "https://raw.githubusercontent.com/1998code/SwiftNEWKit/refs/heads/main/Demo/remote-update-preview.json"

    static var remoteURL: String {
        let localization = Bundle.main.preferredLocalizations.first
            ?? Bundle.main.developmentLocalization
            ?? "en"

        return "https://raw.githubusercontent.com/1998code/SwiftNEWKit/refs/heads/main/Demo/What's%20New%3F/\(localization).lproj/data.json"
    }
}

#if os(watchOS)
private enum WatchDataMode: Hashable {
    case local
    case remote
    case update
}

private enum WatchVisualMode: Hashable {
    case still
    case liquid
    case particles
}

struct ContentView: View {
    @State private var showReleaseNotes = false
    @State private var dataMode: WatchDataMode = .local
    @State private var visualMode: WatchVisualMode = .still

    var body: some View {
        NavigationStack {
            ZStack {
                SwiftNEWBackdrop(
                    meshStyle: selectedMeshStyle,
                    specialEffect: selectedSpecialEffect
                )

                ScrollView {
                    VStack(spacing: 10) {
                        Picker("Data", selection: $dataMode) {
                            Text("Local").tag(WatchDataMode.local)
                            Text("Remote").tag(WatchDataMode.remote)
                            Text("Update").tag(WatchDataMode.update)
                        }
                        .pickerStyle(.navigationLink)

                        Picker("Visual", selection: $visualMode) {
                            Text("Still").tag(WatchVisualMode.still)
                            Text("Liquid").tag(WatchVisualMode.liquid)
                            Text("Particles").tag(WatchVisualMode.particles)
                        }
                        .pickerStyle(.navigationLink)

                        SwiftNEW(
                            show: $showReleaseNotes,
                            label: "Release Note",
                            labelImage: "arrow.up.circle.fill",
                            search: false,
                            data: selectedDataSource,
                            meshStyle: selectedMeshStyle,
                            specialEffect: selectedSpecialEffect,
                            buttonCornerRadius: 100,
                            showDescription: false,
                            checkForUpdates: checksForRemoteUpdate,
                            appStoreBundleIdentifier: checksForRemoteUpdate ? "com.apple.TestFlight" : nil
                        )
                        .padding(.top, 4)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }

    private var selectedDataSource: String {
        switch dataMode {
        case .local:
            return "data"
        case .remote:
            return DemoReleaseNotesSource.remoteURL
        case .update:
            return DemoReleaseNotesSource.remoteUpdateURL
        }
    }

    private var checksForRemoteUpdate: Bool {
        dataMode == .update
    }

    private var selectedMeshStyle: SwiftNEWMeshStyle {
        visualMode == .liquid ? .liquid : .still
    }

    private var selectedSpecialEffect: SwiftNEWSpecialEffect {
        visualMode == .particles ? .particles : .none
    }
}

#else
struct ContentView: View {
    @State private var showDefault = false
    @State private var showMini = false
    @State private var showFullScreen = false
    @State private var showParticles = false
    @State private var showRemote = false
    @State private var showPurchase = false
    @State private var purchaseMode: DemoPurchaseMode?

    var body: some View {
        ZStack {
            tabBackground

            TabView {
                defaultExample
                    .tabItem {
                        Label("Default", systemImage: "sparkles")
                    }

                examplePage(
                    title: "Full Screen",
                    description: "Present release notes using a full-screen cover."
                ) {
                    SwiftNEW(
                        show: $showFullScreen,
                        label: "Show Full Screen",
                        labelImage: "rectangle.inset.filled",
                        presentation: .fullScreenCover
                    )
                }
                .tabItem {
                    Label("Full Screen", systemImage: "rectangle.inset.filled")
                }

                examplePage(
                    title: "Effects",
                    description: "A SwiftNEW sheet with floating particles."
                ) {
                    SwiftNEW(
                        show: $showParticles,
                        label: "Show Particles",
                        labelImage: "circle.hexagongrid.fill",
                        specialEffect: .particles
                    )
                }
                .tabItem {
                    Label("Effects", systemImage: "wand.and.stars")
                }

                examplePage(
                    title: "Remote",
                    description: "Load release notes from a remote JSON file."
                ) {
                    SwiftNEW(
                        show: $showRemote,
                        label: "Show Remote Notes",
                        labelImage: "icloud",
                        data: DemoReleaseNotesSource.remoteURL
                    )
                }
                .tabItem {
                    Label("Remote", systemImage: "icloud")
                }

                examplePage(
                    title: "Purchase",
                    description: purchaseMode == nil
                        ? "Choose what must be verified before entering the app."
                        : "Verify the selected purchase before entering the app."
                ) {
                    if let purchaseMode {
                        SwiftNEW(
                            show: $showPurchase,
                            label: "Show Purchase Gate",
                            labelImage: "lock",
                            presentation: .fullScreenCover,
                            appStoreBundleIdentifier: "com.apple.TestFlight",
                            purchaseRequirement: purchaseMode.requirement,
                            purchaseEnvironment: .all
                        )
                    } else {
                        purchaseModePicker
                    }
                }
                .tabItem {
                    Label("Purchase", systemImage: "lock")
                }
            }
        }
    }

    private var tabBackground: some View {
        ZStack {
            Rectangle()
                .fill(.regularMaterial)

            LinearGradient(
                stops: [
                    .init(color: Color.accentColor.opacity(0.46), location: 0),
                    .init(color: Color.accentColor.opacity(0.22), location: 0.32),
                    .init(color: Color.accentColor.opacity(0.04), location: 0.7),
                    .init(color: Color.accentColor.opacity(0.1), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [Color.accentColor.opacity(0.24), .clear],
                center: UnitPoint(x: 0.8, y: 0.12),
                startRadius: 0,
                endRadius: 420
            )

            RadialGradient(
                colors: [Color.accentColor.opacity(0.12), .clear],
                center: UnitPoint(x: 0.2, y: 0.88),
                startRadius: 0,
                endRadius: 520
            )

            LinearGradient(
                colors: [
                    tabReadabilityColor.opacity(0.62),
                    tabReadabilityColor.opacity(0.46),
                    tabReadabilityColor.opacity(0.6)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }

    private var tabReadabilityColor: Color {
        #if os(macOS)
        Color(NSColor.windowBackgroundColor)
        #elseif os(tvOS)
        Color.black
        #else
        Color(.systemBackground)
        #endif
    }

    private var defaultExample: some View {
        NavigationView {
            examplePage(
                title: "Default",
                description: "The standard SwiftNEW button and sheet presentation."
            ) {
                SwiftNEW(show: $showDefault)
            }
            .overlay(alignment: .topTrailing) {
                miniToolbarHint
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    SwiftNEW(show: $showMini, size: "mini", glass: false)
                }
            }
        }
        .navigationViewStyle(.stack)
    }

    private var miniToolbarHint: some View {
        Label("Mini size fits a toolbar", systemImage: "arrow.up")
            .labelStyle(TrailingIconLabelStyle())
            .font(.footnote.weight(.medium))
            .foregroundStyle(.secondary)
            .padding(.top, 8)
            .padding(.trailing, 20)
    }

    private var purchaseModePicker: some View {
        VStack(spacing: 0) {
            ForEach(DemoPurchaseMode.allCases) { mode in
                Button {
                    purchaseMode = mode
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: mode.systemImage)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(Color.accentColor)
                            .frame(width: 38, height: 38)
                            .background(
                                Color.accentColor.opacity(0.14),
                                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                            )

                        VStack(alignment: .leading, spacing: 2) {
                            Text(mode.title)
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.primary)
                            Text(mode.detail)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .multilineTextAlignment(.leading)

                        Spacer(minLength: 8)

                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if mode != DemoPurchaseMode.allCases.last {
                    Divider()
                        .padding(.leading, 68)
                }
            }
        }
        .frame(maxWidth: 360)
        .background(
            .regularMaterial,
            in: RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
    }

    private func examplePage<Content: View>(
        title: String,
        description: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.largeTitle.bold())
                Text(description)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            content()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            tabBackground
        }
    }
}

private enum DemoPurchaseMode: String, CaseIterable, Identifiable {
    case appPurchase
    case subscription
    case both

    private static let productIDs = ["com.example.pro"]

    var id: String { rawValue }

    var title: String {
        switch self {
        case .appPurchase: return "App Store Purchase"
        case .subscription: return "Subscription"
        case .both: return "Purchase + Subscription"
        }
    }

    var detail: String {
        switch self {
        case .appPurchase: return "One-time purchase of the app"
        case .subscription: return "An active designated subscription"
        case .both: return "Both are required"
        }
    }

    var systemImage: String {
        switch self {
        case .appPurchase: return "bag"
        case .subscription: return "arrow.triangle.2.circlepath"
        case .both: return "checkmark.seal"
        }
    }

    var requirement: SwiftNEWPurchaseRequirement {
        switch self {
        case .appPurchase: return .appPurchase
        case .subscription: return .subscription(productIDs: Self.productIDs)
        case .both: return .appPurchaseAndSubscription(productIDs: Self.productIDs)
        }
    }
}

private struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 6) {
            configuration.title
            configuration.icon
        }
    }
}
#endif

//
//  ContentView.swift
//  What's New?
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftNEW

struct ContentView: View {
    @State private var showDefault = false
    @State private var showMini = false
    @State private var showFullScreen = false
    @State private var showParticles = false
    @State private var showRemote = false

    var body: some View {
        ZStack {
            tabBackground

            TabView {
                examplePage(
                    title: "Default",
                    description: "The standard SwiftNEW button and sheet presentation."
                ) {
                    SwiftNEW(show: $showDefault)
                }
                .tabItem {
                    Label("Default", systemImage: "sparkles")
                }

                miniToolbarExample
                    .tabItem {
                        Label("Mini", systemImage: "rectangle.compress.vertical")
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
                        data: remoteDataURL
                    )
                }
                .tabItem {
                    Label("Remote", systemImage: "icloud")
                }
            }
        }
    }

    private let remoteDataURL = "https://raw.githubusercontent.com/1998code/SwiftNEWKit/refs/heads/main/Demo/What's%20New%3F/en.lproj/data.json"

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
                    Color(.systemBackground).opacity(0.62),
                    Color(.systemBackground).opacity(0.46),
                    Color(.systemBackground).opacity(0.6)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }

    private var miniToolbarExample: some View {
        NavigationView {
            VStack(spacing: 8) {
                Text("Mini")
                    .font(.largeTitle.bold())
                Text("Tap the SwiftNEW button in the toolbar.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                tabBackground
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    SwiftNEW(show: $showMini, size: "mini", glass: false)
                }
            }
        }
        .navigationViewStyle(.stack)
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

//
//  SwiftNEW+Functions.swift
//  SwiftNEW
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import SwiftVB

#if os(iOS)
import Drops
#endif

@available(iOS 15.0, watchOS 8.0, macOS 12.0, tvOS 17.0, *)
extension SwiftNEW {
    var loadRequest: SwiftNEWLoadRequest {
        let configuredBundleIdentifier = appStoreBundleIdentifier?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let needsAppStoreBundleIdentifier = checkForUpdates
            && SwiftNEWRemoteSource.url(from: data) != nil
        let resolvedBundleIdentifier = needsAppStoreBundleIdentifier
            ? (configuredBundleIdentifier?.isEmpty == false
                ? configuredBundleIdentifier
                : loadDependencies.appStoreBundleIdentifier())
            : nil

        return SwiftNEWLoadRequest(
            source: data,
            checkForUpdates: checkForUpdates,
            bundleIdentifier: resolvedBundleIdentifier
        )
    }

    var shouldPrefetchRemoteUpdate: Bool {
        checkForUpdates && SwiftNEWRemoteSource.url(from: data) != nil
    }

    var shouldLoadData: Bool {
        forceLoadRequested || shouldPrefetchRemoteUpdate || presentation == .embed || show
    }

    var loadTaskID: SwiftNEWLoadTaskID {
        SwiftNEWLoadTaskID(
            request: loadRequest,
            shouldLoad: shouldLoadData,
            reloadID: reloadID
        )
    }

    private var configuredPresentation: SwiftNEWPendingPresentation {
        guard presentation != .embed else { return .none }

        #if os(iOS)
        return showDrop
            ? SwiftNEWPendingPresentation.drop
            : SwiftNEWPendingPresentation.sheet
        #else
        return SwiftNEWPendingPresentation.sheet
        #endif
    }

    // MARK: - Functions
    public func compareVersion() {
        let currentVersion = loadDependencies.currentVersion()
        let currentBuild = loadDependencies.currentBuild()

        if SwiftNEWVersionState.shouldPresent(
            currentVersion: currentVersion,
            currentBuild: currentBuild,
            savedVersion: version,
            savedBuild: build
        ) {
            let snapshot = SwiftNEWVersionSnapshot(
                version: currentVersion,
                build: currentBuild
            )
            let presentation = configuredPresentation

            if shouldPrefetchRemoteUpdate {
                pendingSeenVersion = snapshot
                hasPendingPresentation = presentation != .none
                    && !suppressedAutomaticUpdateRequests.contains(loadRequest)

                if updateCheckPhase == .resolved, loadedRequest == loadRequest {
                    resolvePresentation(
                        updateCandidate: availableUpdate,
                        request: loadRequest
                    )
                }
            } else {
                pendingSeenVersion = nil
                hasPendingPresentation = false
                commitSeenVersion(snapshot)
                if presentation != .none {
                    performPresentation(configuredPresentation)
                }
            }
        }
    }

    public func loadData() {
        let loadStateMachine = loadStateMachine
        Task { @MainActor in
            loadStateMachine.requestReload()
        }
    }

    @MainActor
    func runLoadTask(_ taskID: SwiftNEWLoadTaskID) async {
        guard !Task.isCancelled, taskID == loadTaskID else { return }
        let request = taskID.request

        if loadStateMachine.resetIfRequestChanged(to: request) {
            cancelActiveDrop()
        }

        guard !Task.isCancelled, taskID == loadTaskID else { return }
        compareVersion()
        guard !Task.isCancelled, taskID == loadTaskID else { return }

        guard taskID.shouldLoad else {
            loadGeneration = nil
            updateCheckPhase = .inactive

            if !shouldPrefetchRemoteUpdate {
                let shouldPresent = hasPendingPresentation
                hasPendingPresentation = false
                commitPendingSeenVersion()

                if shouldPresent {
                    performPresentation(configuredPresentation)
                }
            }
            return
        }

        guard loadedRequest != request else { return }

        if appStoreLookupRetryRequest == request,
           let updateCandidate = availableUpdate {
            let generation = loadStateMachine.beginAppStoreRetry()
            await retryAppStoreLookup(
                for: updateCandidate,
                request: request,
                taskID: taskID,
                generation: generation
            )
        } else {
            appStoreLookupRetryRequest = nil
            let isUpdatePreflight = request.checkForUpdates
                && SwiftNEWRemoteSource.url(from: request.source) != nil
            let generation = loadStateMachine.beginLoad(
                isUpdatePreflight: isUpdatePreflight
            )
            await loadData(for: request, taskID: taskID, generation: generation)
        }
    }

    @MainActor
    private func loadData(
        for request: SwiftNEWLoadRequest,
        taskID: SwiftNEWLoadTaskID,
        generation: UUID
    ) async {
        guard isCurrentLoad(request: request, taskID: taskID, generation: generation) else { return }
        let isUpdatePreflight = request.checkForUpdates
            && SwiftNEWRemoteSource.url(from: request.source) != nil

        do {
            let decoded = try await fetchReleaseNotes(for: request)
            guard isCurrentLoad(request: request, taskID: taskID, generation: generation) else { return }

            var updateCandidate = SwiftNEWUpdateResolver.candidate(
                in: decoded,
                currentVersion: loadDependencies.currentVersion(),
                source: request.source,
                checkForUpdates: request.checkForUpdates
            )
            var lookupErrorMessage: String?

            if updateCandidate != nil {
                do {
                    let appStoreURL = try await fetchAppStoreURL(
                        bundleIdentifier: request.bundleIdentifier
                    )
                    updateCandidate = updateCandidate?.resolvingAppStoreURL(appStoreURL)
                } catch {
                    guard !Task.isCancelled else { return }
                    lookupErrorMessage = String(
                        localized: "Unable to load App Store information.",
                        bundle: .module
                    )
                }
            }

            guard isCurrentLoad(request: request, taskID: taskID, generation: generation) else { return }
            loadStateMachine.finishLoad(
                items: decoded,
                updateCandidate: updateCandidate,
                lookupErrorMessage: lookupErrorMessage,
                request: request,
                isUpdatePreflight: isUpdatePreflight
            )
            resolvePresentation(updateCandidate: updateCandidate, request: request)
        } catch {
            guard !Task.isCancelled,
                  isCurrentLoad(request: request, taskID: taskID, generation: generation)
            else { return }

            print("SwiftNEW loadData error: \(error)")
            loadStateMachine.failLoad(
                request: request,
                isUpdatePreflight: isUpdatePreflight,
                message: String(localized: "Unable to load release notes.", bundle: .module)
            )
            resolvePresentation(updateCandidate: nil, request: request)
        }
    }

    private func fetchReleaseNotes(for request: SwiftNEWLoadRequest) async throws -> [Vmodel] {
        try await loadDependencies.loadReleaseNotes(request.source, dataBundle)
    }

    private func fetchAppStoreURL(bundleIdentifier: String?) async throws -> URL {
        guard let bundleIdentifier else {
            throw SwiftNEWAppStoreLookupError.missingBundleIdentifier
        }

        let defaultData = try await fetchAppStoreLookupData(
            bundleIdentifier: bundleIdentifier
        )
        if let appStoreURL = try SwiftNEWAppStoreLookup.appStoreURL(
            from: defaultData,
            bundleIdentifier: bundleIdentifier
        ) {
            return appStoreURL
        }

        guard !Task.isCancelled,
              let countryCode = SwiftNEWAppStoreLookup.normalizedCountryCode(
                currentRegionCode
              ),
              countryCode != "US"
        else { throw SwiftNEWAppStoreLookupError.noResult }

        let regionalData = try await fetchAppStoreLookupData(
            bundleIdentifier: bundleIdentifier,
            countryCode: countryCode
        )
        guard let appStoreURL = try SwiftNEWAppStoreLookup.appStoreURL(
            from: regionalData,
            bundleIdentifier: bundleIdentifier
        ) else { throw SwiftNEWAppStoreLookupError.noResult }
        return appStoreURL
    }

    @MainActor
    private func retryAppStoreLookup(
        for candidate: SwiftNEWUpdateCandidate,
        request: SwiftNEWLoadRequest,
        taskID: SwiftNEWLoadTaskID,
        generation: UUID
    ) async {
        guard isCurrentLoad(request: request, taskID: taskID, generation: generation) else {
            return
        }

        var appStoreURL: URL?
        var lookupErrorMessage: String?
        do {
            appStoreURL = try await fetchAppStoreURL(
                bundleIdentifier: request.bundleIdentifier
            )
            guard isCurrentLoad(request: request, taskID: taskID, generation: generation) else {
                return
            }
        } catch {
            guard !Task.isCancelled,
                  isCurrentLoad(request: request, taskID: taskID, generation: generation)
            else { return }
            lookupErrorMessage = String(
                localized: "Unable to load App Store information.",
                bundle: .module
            )
        }

        loadStateMachine.finishAppStoreRetry(
            candidate: candidate,
            appStoreURL: appStoreURL,
            errorMessage: lookupErrorMessage,
            request: request
        )
        resolvePresentation(updateCandidate: availableUpdate, request: request)
    }

    private func fetchAppStoreLookupData(
        bundleIdentifier: String,
        countryCode: String? = nil
    ) async throws -> Data {
        guard let lookupURL = SwiftNEWAppStoreLookup.requestURL(
            bundleIdentifier: bundleIdentifier,
            countryCode: countryCode
        ) else { throw SwiftNEWAppStoreLookupError.invalidRequest }

        let (data, response) = try await loadDependencies.loadURL(lookupURL)
        try validateHTTPResponse(response)
        return data
    }

    private var currentRegionCode: String? {
        loadDependencies.regionCode()
    }

    private func validateHTTPResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else { throw URLError(.badServerResponse) }
    }

    private func isCurrentLoad(
        request: SwiftNEWLoadRequest,
        taskID: SwiftNEWLoadTaskID,
        generation: UUID
    ) -> Bool {
        !Task.isCancelled
            && loadRequest == request
            && loadTaskID == taskID
            && loadGeneration == generation
    }

    private func resolvePresentation(
        updateCandidate: SwiftNEWUpdateCandidate?,
        request: SwiftNEWLoadRequest
    ) {
        let shouldPresent = hasPendingPresentation
        hasPendingPresentation = false
        commitPendingSeenVersion()

        if updateCandidate != nil {
            cancelActiveDrop()
            if presentation != .embed,
               !suppressedAutomaticUpdateRequests.contains(request),
               !show {
                withAnimation { show = true }
            }
            return
        }

        if shouldPresent {
            performPresentation(configuredPresentation)
        }
    }

    func requestPresentationAfterPreflight() {
        suppressedAutomaticUpdateRequests.remove(loadRequest)

        if shouldPrefetchRemoteUpdate, updateCheckPhase != .resolved {
            let presentation = configuredPresentation
            hasPendingPresentation = presentation != .none
            if presentation == .sheet {
                withAnimation { show = true }
            }
            return
        }

        if availableUpdate != nil {
            withAnimation { show = true }
        } else {
            performPresentation(configuredPresentation)
        }
    }

    func handleShowChange(_ isPresented: Bool) {
        guard !isPresented else { return }
        historySheet = false
        resetSearch()

        guard shouldPrefetchRemoteUpdate else { return }

        if updateCheckPhase != .resolved || availableUpdate != nil {
            hasPendingPresentation = false
            suppressedAutomaticUpdateRequests.insert(loadRequest)
            if updateCheckPhase != .resolved {
                commitCurrentVersionAsSeen()
            }
        }
    }

    private func performPresentation(_ presentation: SwiftNEWPendingPresentation) {
        switch presentation {
        case .none:
            break
        case .sheet:
            cancelActiveDrop()
            withAnimation { show = true }
        case .drop:
            #if os(iOS)
            drop()
            #else
            withAnimation { show = true }
            #endif
        }
    }

    func openAvailableUpdate() {
        openAvailableUpdate(using: { url in
            openURL(url)
        })
    }

    func openAvailableUpdate(using openURL: (URL) -> Void) {
        guard let appStoreURL = availableUpdate?.appStoreURL
        else { return }

        openURL(appStoreURL)
    }

    func retryAppStoreLookup() {
        guard availableUpdate != nil else { return }
        suppressedAutomaticUpdateRequests.remove(loadRequest)
        loadStateMachine.requestReload(retryingAppStoreFor: loadRequest)
    }

    func finishUpdatePresentation() {
        guard allowsSkippingUpdate else { return }

        if shouldPrefetchRemoteUpdate,
           (updateCheckPhase != .resolved || availableUpdate != nil) {
            suppressedAutomaticUpdateRequests.insert(loadRequest)
            hasPendingPresentation = false
            if updateCheckPhase != .resolved {
                commitCurrentVersionAsSeen()
            }
        }
        withAnimation {
            if presentation == .embed {
                availableUpdate = nil
            } else {
                show = false
            }
        }
    }

    private func commitPendingSeenVersion() {
        guard let pendingSeenVersion else { return }
        commitSeenVersion(pendingSeenVersion)
        self.pendingSeenVersion = nil
    }

    private func commitCurrentVersionAsSeen() {
        pendingSeenVersion = nil
        commitSeenVersion(
            SwiftNEWVersionSnapshot(
                version: loadDependencies.currentVersion(),
                build: loadDependencies.currentBuild()
            )
        )
    }

    private func commitSeenVersion(_ snapshot: SwiftNEWVersionSnapshot) {
        version = snapshot.version
        build = snapshot.build
    }

    func cancelActiveDrop() {
        #if os(iOS)
        guard activeDropEpoch != nil else { return }
        activeDropEpoch = nil
        Drops.hideCurrent()
        #endif
    }

    #if os(iOS)
    public func drop() {
        let epoch = UUID()
        let request = loadRequest
        activeDropEpoch = epoch

        let drop = Drop(title: String(localized: "Tap", bundle: .module),
                        subtitle: String(localized: "To See What's New.", bundle: .module),
                        icon: UIImage(systemName: labelImage),
                        action: .init {
                            guard activeDropEpoch == epoch, loadRequest == request else { return }
                            activeDropEpoch = nil
                            Drops.hideCurrent()
                            show = true
                        },
                        position: .top,
                        duration: 3.0,
                        accessibility: .init(message: String(localized: "Alert: Tap to see what's new.", bundle: .module)))
        Drops.show(drop)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
            if activeDropEpoch == epoch {
                activeDropEpoch = nil
            }
        }
    }
    #endif
}

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

        return SwiftNEWLoadRequest(
            source: data,
            checkForUpdates: checkForUpdates,
            bundleIdentifier: configuredBundleIdentifier?.isEmpty == false
                ? configuredBundleIdentifier
                : Bundle.main.bundleIdentifier
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
        let currentVersion = Bundle.version
        let currentBuild = Bundle.build

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
        Task { @MainActor in
            forceLoadRequested = true
            appStoreLookupRetryRequest = nil
            loadGeneration = nil
            loadedRequest = nil
            reloadID = UUID()
        }
    }

    @MainActor
    func runLoadTask(_ taskID: SwiftNEWLoadTaskID) async {
        guard !Task.isCancelled, taskID == loadTaskID else { return }
        let request = taskID.request

        if currentLoadRequest != request {
            cancelActiveDrop()
            currentLoadRequest = request
            loadedRequest = nil
            loadedDataSource = nil
            items = []
            availableUpdate = nil
            loadErrorMessage = nil
            appStoreLookupErrorMessage = nil
            appStoreLookupRetryRequest = nil
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

        let generation = UUID()
        loadGeneration = generation
        if appStoreLookupRetryRequest == request,
           let updateCandidate = availableUpdate {
            await retryAppStoreLookup(
                for: updateCandidate,
                request: request,
                taskID: taskID,
                generation: generation
            )
        } else {
            appStoreLookupRetryRequest = nil
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

        loading = true
        loadErrorMessage = nil
        appStoreLookupErrorMessage = nil
        availableUpdate = nil
        updateCheckPhase = isUpdatePreflight ? .checking : .inactive

        do {
            let decoded = try await fetchReleaseNotes(for: request)
            guard isCurrentLoad(request: request, taskID: taskID, generation: generation) else { return }

            var updateCandidate = SwiftNEWUpdateResolver.candidate(
                in: decoded,
                currentVersion: Bundle.version,
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
            items = decoded
            availableUpdate = updateCandidate
            appStoreLookupErrorMessage = lookupErrorMessage
            loading = false
            loadedDataSource = request.source
            loadedRequest = request
            loadGeneration = nil
            forceLoadRequested = false
            appStoreLookupRetryRequest = nil
            updateCheckPhase = isUpdatePreflight ? .resolved : .inactive
            resolvePresentation(updateCandidate: updateCandidate, request: request)
        } catch {
            guard !Task.isCancelled,
                  isCurrentLoad(request: request, taskID: taskID, generation: generation)
            else { return }

            print("SwiftNEW loadData error: \(error)")
            loading = false
            availableUpdate = nil
            appStoreLookupErrorMessage = nil
            loadedDataSource = request.source
            loadedRequest = request
            loadGeneration = nil
            forceLoadRequested = false
            appStoreLookupRetryRequest = nil
            updateCheckPhase = isUpdatePreflight ? .resolved : .inactive
            loadErrorMessage = String(localized: "Unable to load release notes.", bundle: .module)
            resolvePresentation(updateCandidate: nil, request: request)
        }
    }

    private func fetchReleaseNotes(for request: SwiftNEWLoadRequest) async throws -> [Vmodel] {
        if SwiftNEWRemoteSource.looksRemote(request.source) {
            guard let url = SwiftNEWRemoteSource.url(from: request.source) else {
                throw URLError(.badURL)
            }
            let (responseData, response) = try await URLSession.shared.data(from: url)
            try validateHTTPResponse(response)
            return try JSONDecoder().decode([Vmodel].self, from: responseData)
        }

        guard let url = dataBundle.url(forResource: request.source, withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try await Task.detached {
            let fileData = try Data(contentsOf: url)
            return try JSONDecoder().decode([Vmodel].self, from: fileData)
        }.value
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

        updateCheckPhase = .checking
        appStoreLookupErrorMessage = nil

        do {
            let appStoreURL = try await fetchAppStoreURL(
                bundleIdentifier: request.bundleIdentifier
            )
            guard isCurrentLoad(request: request, taskID: taskID, generation: generation) else {
                return
            }
            availableUpdate = candidate.resolvingAppStoreURL(appStoreURL)
        } catch {
            guard !Task.isCancelled,
                  isCurrentLoad(request: request, taskID: taskID, generation: generation)
            else { return }
            availableUpdate = candidate
            appStoreLookupErrorMessage = String(
                localized: "Unable to load App Store information.",
                bundle: .module
            )
        }

        loadedRequest = request
        appStoreLookupRetryRequest = nil
        loadGeneration = nil
        updateCheckPhase = .resolved
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

        let (data, response) = try await URLSession.shared.data(from: lookupURL)
        try validateHTTPResponse(response)
        return data
    }

    private var currentRegionCode: String? {
        if #available(iOS 16.0, watchOS 9.0, macOS 13.0, tvOS 16.0, *) {
            return Locale.current.region?.identifier
        }
        return Locale.current.regionCode
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
        guard !isPresented, shouldPrefetchRemoteUpdate else { return }

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
        guard let appStoreURL = availableUpdate?.appStoreURL
        else { return }

        openURL(appStoreURL)
    }

    func retryAppStoreLookup() {
        guard availableUpdate != nil else { return }
        suppressedAutomaticUpdateRequests.remove(loadRequest)
        appStoreLookupRetryRequest = loadRequest
        loadGeneration = nil
        loadedRequest = nil
        appStoreLookupErrorMessage = nil
        reloadID = UUID()
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
                version: Bundle.version,
                build: Bundle.build
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

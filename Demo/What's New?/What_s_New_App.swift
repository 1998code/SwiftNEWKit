//
//  What_s_New_App.swift
//  What's New?
//
//  Created by Ming on 11/6/2022.
//

import SwiftUI

@main
struct What_s_New_App: App {
#if os(iOS) && canImport(CarPlay) && !targetEnvironment(macCatalyst)
    @UIApplicationDelegateAdaptor(CarPlayDemoAppDelegate.self)
    private var appDelegate
#endif

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

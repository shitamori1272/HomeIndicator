//
//  HomeIndicatorWatchApp.swift
//  HomeIndicator WatchKit Extension
//
//  Created by Codex on 2026/02/17.
//

import SwiftUI

@main
struct HomeIndicatorWatchApp: App {
    @WKApplicationDelegateAdaptor(ExtensionDelegate.self) private var extensionDelegate

    var body: some Scene {
        WindowGroup {
            ContentView<ContentViewModel>(viewModel: ContentViewModel())
        }
        WKNotificationScene(controller: NotificationController.self, category: "sessionEnd")
    }
}

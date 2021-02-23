//
//  TrafficCameraViewerApp.swift
//  TrafficCameraViewer
//
//  Created by Scott on 2/19/21.
//

import SwiftUI

@main
struct TrafficCameraViewerApp: App {
    
    init() {
        let temporaryDirectory = NSTemporaryDirectory()
        let urlCache = URLCache(memoryCapacity: 250_000_000, diskCapacity: 450_000_000, diskPath: temporaryDirectory)
        URLCache.shared = urlCache
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

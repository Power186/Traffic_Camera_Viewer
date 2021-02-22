//
//  UserSettings.swift
//  TrafficCameraViewer
//
//  Created by Scott on 2/22/21.
//

import Foundation

final class UserSettings: ObservableObject {
    static let shared = UserSettings()
    
    @Published var searches: [String] {
        didSet {
            UserDefaults.standard.set(searches, forKey: "searchText")
        }
    }
    
    init() {
        self.searches = UserDefaults.standard.stringArray(forKey: "searchText") ?? [""]
    }
}

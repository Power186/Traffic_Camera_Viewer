//
//  Device.swift
//  TrafficCameraViewer
//
//  Created by Scott on 2/19/21.
//

import Foundation

struct Device: Codable {
    var cameras: [Camera]
}

struct Camera: Codable, Identifiable {
    var id: Int
    var name: String
    var primaryRoad: String
    var crossStreet: String
    var imageUrl: String?
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case id, name, primaryRoad, crossStreet, imageUrl, latitude, longitude
    }
}

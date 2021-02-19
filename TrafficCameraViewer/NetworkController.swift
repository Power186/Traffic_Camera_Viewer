//
//  NetworkController.swift
//  TrafficCameraViewer
//
//  Created by Scott on 2/19/21.
//

import UIKit

final class NetworkController {
    static let shared = NetworkController()
    
    enum PhotoInfoError: Error, LocalizedError {
        case imageDataMissing
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data,
               let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(PhotoInfoError.imageDataMissing))
            }
        }
        task.resume()
    }
    
    func fetchCameras(completion: @escaping (Result<Device, Error>) -> Void) {
        let url = URL(string: "https://algoapi.caps.ua.edu/v2.0/Cameras")
        guard let safeUrl = url else { return }
        
        let task = URLSession.shared.dataTask(with: safeUrl) { (data, _, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let cameraInfo = try jsonDecoder.decode(Device.self, from: data)
                    completion(.success(cameraInfo))
                } catch {
                    completion(.failure(error))
                }
            } else {
                if let error = error {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}

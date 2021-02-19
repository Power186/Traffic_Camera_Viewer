//
//  CameraViewModel.swift
//  TrafficCameraViewer
//
//  Created by Scott on 2/19/21.
//

import SwiftUI

final class CameraViewModel: ObservableObject {
    @Published var image = Image(systemName: "photo")
    @Published var cameras = [Camera]()
    
    func fetchImage(with camera: Camera) {
        guard let urlString = camera.imageUrl,
              let imageUrl = URL(string: urlString) else { return }

        NetworkController.shared.fetchImage(from: imageUrl) { [weak self] (result) in
            switch result {
            case .success(let uiImage):
                DispatchQueue.main.async {
                    self?.image = Image(uiImage: uiImage)
                }
            case .failure(let error):
                self?.displayError(error, title: "Failed to fetch image")
            }
        }
    }
    
    func fetchCameras() {
        NetworkController.shared.fetchCameras { [weak self] (result) in
            switch result {
            case .success(let device):
                DispatchQueue.main.async {
                    self?.cameras = device.cameras
                }
            case .failure(let error):
                self?.displayError(error, title: "Failed to fetch cameras")
            }
        }
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
}

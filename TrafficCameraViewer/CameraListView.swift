//
//  ContentView.swift
//  TrafficCameraViewer
//
//  Created by Scott on 2/19/21.
//

import SwiftUI

struct CameraListView: View {
    @ObservedObject var camerasVM = CameraViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(camerasVM.cameras) { camera in
                    NavigationLink(destination: CameraDetailView(camera: camera)) {
                        Text("\(camera.primaryRoad)")
                    }
                }
            }
            .onAppear(perform: {
                camerasVM.fetchCameras()
            })
            .animation(.easeIn)
            .navigationBarTitle("Cameras List")
        }
    } // body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraListView()
    }
}

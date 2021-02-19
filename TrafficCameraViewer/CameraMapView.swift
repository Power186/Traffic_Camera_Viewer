//
//  CameraMapView.swift
//  TrafficCameraViewer
//
//  Created by Scott on 2/19/21.
//

import SwiftUI
import MapKit

struct CameraMapView: View {
    @ObservedObject var cameraVM = CameraViewModel()
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 32.818230, longitude: -86.702298), span: MKCoordinateSpan(latitudeDelta: 3.65, longitudeDelta: 3.65))
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: cameraVM.cameras) { camera in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: camera.latitude, longitude: camera.longitude)) {
                        NavigationLink(destination: CameraDetailView(camera: camera)) {
                            Image(systemName: "mappin.and.ellipse")
                        }
                    }
                }
            }
            .navigationBarTitle("Cameras Map")
        }
        .onAppear(perform: {
            withAnimation {
                cameraVM.fetchCameras()
            }
        })
    } // body
    
}

struct CameraMapView_Previews: PreviewProvider {
    static var previews: some View {
        CameraMapView()
    }
}


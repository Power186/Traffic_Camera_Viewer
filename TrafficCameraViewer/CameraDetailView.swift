//
//  CameraDetailView.swift
//  TrafficCameraViewer
//
//  Created by Scott on 2/19/21.
//

import SwiftUI
import MapKit

struct CameraDetailView: View {
    private let camera: Camera
    @ObservedObject var cameraVM = CameraViewModel()
    @State private var region = MKCoordinateRegion()
    @State private var annotations = [Location]()
    
    init(camera: Camera) {
        self.camera = camera
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            cameraVM.image
                .resizable()
                .frame(width: 250, height: 200)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            
            Text(camera.name)
                .font(.title3)
                .foregroundColor(.red)
                
            HStack {
                Text("Primary Street")
                Spacer()
                Text(camera.primaryRoad)
                    .foregroundColor(.red)
            }
            .padding()
            .font(.headline)
            
            HStack {
                Text("Cross Street")
                Spacer()
                Text(camera.crossStreet)
                    .foregroundColor(.red)
            }
            .padding()
            .font(.headline)
            
            Map(coordinateRegion: $region, annotationItems: annotations) {
                MapAnnotation(coordinate: $0.coordinate) {
                    Image(systemName: "mappin")
                        .imageScale(.large)
                        .foregroundColor(.primary)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: 200, height: 100)
            
            Spacer()
            
        }
        .onAppear(perform: {
            withAnimation {
                cameraVM.fetchImage(with: camera)
                getCoordinate()
                getAnnotations()
            }
        })
        .padding(.top, 10)
    }
    
    func getCoordinate() {
        let cameraCoordinate = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: camera.latitude, longitude: camera.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        region = cameraCoordinate
    }
    
    func getAnnotations() {
        let mapAnnotations = [
            Location(coordinate: CLLocationCoordinate2D(latitude: camera.latitude, longitude: camera.longitude))
        ]
        annotations = mapAnnotations
    }
    
}

struct CameraDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CameraDetailView(camera: Camera(id: 0, name: "cameraName", primaryRoad: "Sugar Road", crossStreet: "Cross Street", imageUrl: nil, latitude: 0, longitude: 0))
    }
}

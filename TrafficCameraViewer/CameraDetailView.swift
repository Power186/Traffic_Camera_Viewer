//
//  CameraDetailView.swift
//  TrafficCameraViewer
//
//  Created by Scott on 2/19/21.
//

import SwiftUI
import MapKit
import AVKit

struct CameraDetailView: View {
    private let camera: Camera
    @ObservedObject var cameraVM = CameraViewModel()
    @State private var region = MKCoordinateRegion()
    @State private var annotations = [Location]()
    
    @State private var player = AVPlayer()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var playerCount = 50
    
    @State private var currentIndex = 0
    let numberOfCards = 2
    
    init(camera: Camera) {
        self.camera = camera
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                
                TabView(selection: $currentIndex) {
                    ForEach(0..<numberOfCards) { card in
                        switch card {
                        case 0:
                            cameraVM.image
                                .resizable()
                        case 1:
                            VideoPlayer(player: player)
                                .onReceive(timer, perform: { _ in
                                    lessThanOneMinutePlayBack()
                                })
                        default:
                            Text("Image and video player not configured")
                                .font(.title3)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(width: 250, height: 200)
                .cornerRadius(10)
                
                controls
                    .padding(8)

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
                    getPlayer()
                }
            })
            .padding(.top, 10)
        }
    }
    
    var controls: some View {
        HStack {
            Button(action: {
                previous()
            }) {
                Image(systemName: "chevron.left.circle.fill")
                    .imageScale(.large)
            }
            Spacer()
                .frame(width: 100)
            Button(action: {
                next()
            }) {
                Image(systemName: "chevron.right.circle.fill")
                    .imageScale(.large)
            }
        }.accentColor(.primary)
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
    
    func getPlayer() {
        let streamPlayer = AVPlayer(url:  URL(string: camera.streamUrl)!)
        player = streamPlayer
    }
    
    func lessThanOneMinutePlayBack() {
        if playerCount > 0 {
            playerCount -= 1
        }
        if playerCount == 0 {
            player.pause()
        }
    }
    
    private func previous() {
        withAnimation {
            currentIndex = currentIndex > 0 ? currentIndex - 1 : numberOfCards - 1
        }
    }
    
    private func next() {
        withAnimation {
            currentIndex = currentIndex < numberOfCards ? currentIndex + 1 : 0
        }
    }
    
}

struct CameraDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CameraDetailView(camera: Camera(id: 0, name: "cameraName", primaryRoad: "Sugar Road", crossStreet: "Cross Street", imageUrl: nil, latitude: 0, longitude: 0, streamUrl: ""))
    }
}

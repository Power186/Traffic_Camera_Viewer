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
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 32.818230, longitude: -86.702298), span: MKCoordinateSpan(latitudeDelta: 3.85, longitudeDelta: 4.25))
    
    @State private var isSearchSheetShowing = false
    @State private var searchText = ""
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Map(coordinateRegion: $region,
                        annotationItems: annotationFilter()) { camera in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: camera.latitude, longitude: camera.longitude)) {
                            
                            NavigationLink(destination: CameraDetailView(camera: camera)) {
                                Image(systemName: "mappin.and.ellipse")
                                    .imageScale(.large)
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 300, height: 375)
                    
                    searchInfo
                    
                    searchButton
                    
                    Spacer()
                    .navigationBarTitle("Cameras Map")
                    .onAppear(perform: {
                        cameraVM.fetchCameras()
                    })
                }
            }
        }
    } // body
    
    var searchInfo: some View {
        VStack(spacing: 8) {
            HStack {
                Text("\(annotationFilter().count)")
                    .foregroundColor(.red)
                    .bold()
                    .animation(.spring())
                Text("cameras")
            }
            Text("Search Query: \(searchText)")
        }
        .font(.custom("Avenir", size: 17))
    }
    
    var searchButton: some View {
        Button(action: {
            isSearchSheetShowing.toggle()
        }) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
                Text("Search")
                    .font(.custom("Avenir", size: 17))
                    .fontWeight(.bold)
            }
            .padding(8)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .sheet(isPresented: $isSearchSheetShowing, content: {
            searchView
        })
    }
    
    var searchView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Swipe to dismiss")
                        .font(.custom("Avenir", size: 17))
                    .fontWeight(.semibold)
                Image(systemName: "chevron.down")
                    .imageScale(.medium)
            }
                SearchBarView(searchText: $searchText, isSearching: $isSearching)
                Spacer()
                Text("Recent Searches here")
                    .font(.custom("Avenir", size: 18))
                Spacer()
            }
    }

    func annotationFilter() -> [Camera] {
        return cameraVM.cameras.filter({ $0.primaryRoad.lowercased().contains(searchText.lowercased()) ||
                                        searchText.isEmpty})
    }
    
}

struct CameraMapView_Previews: PreviewProvider {
    static var previews: some View {
        CameraMapView()
    }
}


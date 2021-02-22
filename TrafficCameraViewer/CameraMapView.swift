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
    
    @State private var recentSearches = [String]()
    
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
                    .padding(.top, 8)
                Image(systemName: "chevron.down")
                    .imageScale(.medium)
            }
                SearchBarView(searchText: $searchText, isSearching: $isSearching)
                Spacer()
            List {
                ForEach(UserSettings.shared.searches, id: \.self) { search in
                    HStack {
                        Text(search)
                        Spacer()
                        if !search.isEmpty {
                            Button(action: {
                                searchText = search
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                            }
                        }
                    }
                    .padding(.leading, 8)
                    .padding(.trailing, 8)
                }
                .font(.custom("Avenir", size: 18))
            }
                Spacer()
            }
        .onAppear(perform: {
            searchText = ""
        })
        .onDisappear(perform: {
            checkValidSearch()
            UserSettings.shared.searches.removeDuplicates()
        })
    }

    func annotationFilter() -> [Camera] {
        return cameraVM.cameras.filter({ $0.primaryRoad.lowercased().contains(searchText.lowercased()) ||
                                        searchText.isEmpty})
    }
    
    func checkValidSearch() {
        if !searchText.isEmpty {
            UserSettings.shared.searches.append(searchText)
        }
    }
    
}

struct CameraMapView_Previews: PreviewProvider {
    static var previews: some View {
        CameraMapView()
    }
}

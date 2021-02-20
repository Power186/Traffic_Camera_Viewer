//
//  MainView.swift
//  TrafficCameraViewer
//
//  Created by Scott on 2/19/21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            CameraMapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            CameraListView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("List")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

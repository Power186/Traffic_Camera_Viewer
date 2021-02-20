//
//  SearchBarView.swift
//  TrafficCameraViewer
//
//  Created by Scott on 2/20/21.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .imageScale(.medium)
                TextField("Search by primary street", text: $searchText)
                    .font(.custom("Avenir", size: 18))
            }
            .padding(8)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .padding(.horizontal)
            .onTapGesture {
                isSearching = true
            }
            .transition(.move(edge: .trailing))
            .animation(.spring())
            
            if isSearching {
                Button(action: {
                    isSearching = false
                    searchText = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .font(.custom("Avenir", size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(.trailing)
                        .padding(.leading, 0)
                }
            }
        }
    }
}

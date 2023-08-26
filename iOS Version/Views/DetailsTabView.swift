//
//  DetailsTabView.swift
//  Business Search
//
//  Created by Bo Tang on 12/4/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct DetailsTabView: View {
    @EnvironmentObject var businessSearchViewModel: BusinessSearchViewModel
    
    @State var id: String
    @State private var selectedTab = "One"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DetailsView()
                .tabItem {
                    Label("Business Detail", systemImage: "text.bubble.fill")
                }
                .tag("One")

            MapView(place: Marker(id: UUID(), lat: Double(businessSearchViewModel.details.latitude) ?? 0, long: Double(businessSearchViewModel.details.longitude) ?? 0), region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(businessSearchViewModel.details.latitude) ?? 0, longitude: Double(businessSearchViewModel.details.longitude) ?? 0), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                .tabItem {
                    Label("Map Location", systemImage: "location.fill")
                }
                .tag("Two")
            
            ReviewsView()
                .tabItem {
                    Label("Reviews", systemImage: "message.fill")
                }
                .tag("Three")
        }
        .onAppear {
            businessSearchViewModel.getDetails(id: id)
            businessSearchViewModel.getReviews(id: id)
        }
        .onDisappear {
            businessSearchViewModel.setIsLoadedToFalse()
        }
    }
}

struct DetailsTabView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsTabView(id: "S-HnlA1IjdgOPFIkWdEBVA")
            .environmentObject(BusinessSearchViewModel())
    }
}

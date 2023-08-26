//
//  MapView.swift
//  Business Search
//
//  Created by Bo Tang on 11/23/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct Marker: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    init(id: UUID = UUID(), lat: Double, long: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
}

    
    
    struct MapView: View {
        let place: Marker
        @State var region: MKCoordinateRegion

        var body: some View {
            VStack {
                Map(coordinateRegion: $region,
                    annotationItems: [place])
                { place in
                    MapMarker(coordinate: place.location,
                           tint: Color.red)
                }
            }
        }
    }
    

    








struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(place: Marker(id: UUID(), lat: 40.7280299, long: -74.00167), region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.7280299, longitude: -74.00167), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
            .previewDevice("iPhone 13 Pro")
    }
}

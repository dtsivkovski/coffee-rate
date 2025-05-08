//
//  AllRatingsMap.swift
//  Coffee Rate
//
//  Boilerplate created by Daniel Tsivkovski on 4/29/25.
//

import SwiftUI
import MapKit
import SwiftData

struct AllRatingsMap: View {
    
    @Environment(\.modelContext) var modelContext;
    @Query var ratings: [Rating];
    
    var body: some View {
        // create map
        Map(position: .constant(.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: 33.787915,
                    longitude: -117.853114
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01
                ))
        ))){
            // marker for each rating
            ForEach(ratings) { rating in
                if (rating.location != nil) {
                    Marker(
                        rating.name,
                        systemImage: "cup.and.saucer.fill",
                        coordinate: rating.location!
                    )
                }
            }
            
        }
    }
}

#Preview {
    AllRatingsMap()
}

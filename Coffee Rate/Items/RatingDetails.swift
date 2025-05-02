//
//  RatingDetails.swift
//  Coffee Rate
//
//  Created by Daniel Tsivkovski on 4/29/25.
//

import SwiftUI
import SwiftData
import MapKit

struct RatingDetails: View {
    
    @Environment(\.modelContext) var modelContext;
    @Query var ratings: [Rating];
    var rating : Rating;
    
    var ratingIndex : Int {
        ratings.firstIndex(where: { $0.id == rating.id }) ?? 0;
    }
    
    var circleBackgroundColor : Color {
        get {
            if (rating.overallRating > 7.0) {
                return Color(red: 0.5, green: 1.0, blue: 0.5)
            } else if (rating.overallRating < 3.5) {
                return Color(red: 1.0, green: 0.5, blue: 0.5)
            } else {
                return .yellow;
            }
        }
    }
    
    var body: some View {
        ScrollView {
            // create the map element
            Map(position: .constant(.region(
                MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: rating.location?.latitude ?? 33.78, longitude: rating.location?.longitude ?? -117.85), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
            )), interactionModes: .zoom){
                // marker for the coffee shop
                Marker(
                    rating.name,
                    coordinate: rating.location ?? CLLocationCoordinate2D(latitude: 33.78, longitude: -117.85)
                )
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
            .padding(20)
            .shadow(radius: 8, y: 5.0)
            ZStack {
                Circle().fill(circleBackgroundColor)
                    .frame(height: 90)
                    .offset(y: -80)
                    .shadow(radius: 6, y: 4)
            }
        }
    }
}

#Preview {
    RatingDetails(rating: Rating(name: "Philz Coffee", latitude: 33.789955, longitude: -117.853434, whenVisited: Date(), studyVibe: 9, foodOrDrinkRating: 9, noiseLevel: .normal, availability: 2, overallRating: 8.7))
}

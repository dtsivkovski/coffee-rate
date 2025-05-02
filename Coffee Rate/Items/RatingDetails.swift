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
    
    var noiseLevelString: String {
        switch (NoiseLevel(rawValue: rating.noiseLevel)) {
        case .quiet:
            return "Quiet";
            break;
        case .loud:
            return "Loud";
            break;
        default:
            return "Normal";
            break;
        }
    }
    
    var circleBackgroundColor : Color {
        get {
            if (rating.overallRating > 7.0) {
                return Color(red: 213.0/256, green: 252.0/256, blue: 192.0/256)
            } else if (rating.overallRating < 3.5) {
                return Color(red: 255/256, green: 152/256, blue: 140/256)
            } else {
                return Color(red: 255/256, green: 227/256, blue: 135/256);
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
                Circle().fill(.white)
                    .frame(height: 90)
                    .shadow(radius: 6, y: 4)
                Circle().fill(Gradient(colors: [circleBackgroundColor]))
                    .frame(height: 80)
                Text("\(rating.overallRating.formatted())")
                    .font(.title)
                    .fontWeight(.semibold)
                    .shadow(radius:1, y:2)
            }
            .offset(y: -80)
            .padding([.bottom], -70)
            VStack {
                Text(rating.name)
                    .font(.title)
                    .fontWeight(.bold)
                RatingProgress(label: "Study Vibe", value: rating.studyVibe, outOf: 10)
                RatingProgress(label: "Food/Drink", value: rating.foodOrDrinkRating, outOf: 10)
                RatingProgress(label: "Availability", value: rating.availability, outOf: 5)
            }
            .padding([.leading, .trailing], 40)
        }
    }
}

struct RatingProgress : View {
    
    var label: String;
    
    var value: Int;
    var outOf: Int;
    
    var body: some View {
        VStack {
            HStack {
                Text(label)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(value)/\(outOf)")
                    .fontWeight(.semibold)
            }.padding(.bottom, -2)
            ProgressView(value: Double(value)/Double(outOf))
        }
        .padding(.top, 10)
    }
}

#Preview {
    RatingDetails(rating: Rating(name: "Philz Coffee", latitude: 33.789955, longitude: -117.853434, whenVisited: Date(), studyVibe: 9, foodOrDrinkRating: 9, noiseLevel: .normal, availability: 2, overallRating: 8.7))
}

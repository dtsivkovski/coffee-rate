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
    @Environment(\.colorScheme) var colorScheme;
    @Query var ratings: [Rating];
    var rating : Rating;
    
    // gets the index for the rating position
    // TODO: use when editing (to know which one needs to be changed in the modelContext)
    var ratingIndex : Int {
        ratings.firstIndex(where: { $0.id == rating.id }) ?? 0;
    }
    
    // get a string for the noise level value
    var noiseLevelString: String {
        switch (NoiseLevel(rawValue: rating.noiseLevel)) {
            case .quiet:
                return "Quiet";
            case .loud:
                return "Loud";
            default:
                return "Normal";
        }
    }
    
    var circleBackgroundColor : Color {
        get {
            if (colorScheme == .dark) {
                if (rating.overallRating > 7.0) {
                    return Color(red: 50/256, green: 150/256, blue: 50/256)
                } else if (rating.overallRating < 3.5) {
                    return Color(red: 150/256, green: 50/256, blue: 50/256)
                } else {
                    return .yellow.mix(with: .red, by: 0.3).mix(with: .black, by: 0.05);
                }
            }
            if (rating.overallRating > 7.0) {
                return Color(red: 213/256, green: 252/256, blue: 192/256)
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
            if (rating.location != nil) {
                MapPreview(name: rating.name, location: rating.location!)
            }
            else {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Gradient(colors: [
                            .blue,
                            .black
                        ]))
                        .frame(height: 300)
                        .padding(20)
                        .shadow(radius: 8, y: 5.0)
                    Text("No location data")
                        .font(.title)
                        .foregroundStyle(.white)
                        .shadow(radius: 2, y: 3)
                }
            }
            ZStack {
                Circle().fill(.white)
                    .frame(height: 90)
                    .shadow(radius: 6, y: 4)
                Circle().fill(Gradient(colors: [circleBackgroundColor]))
                    .frame(height: 80)
                Text("\(rating.overallRating.formatted())")
                    .font(.title)
                    .fontWeight(.semibold)
                    .shadow(radius:1, y: 2)
            }
            .offset(y: -80)
            .padding([.bottom], -70)
            VStack {
                Text(rating.name)
                    .font(.title)
                    .fontWeight(.bold)
                Text("Visited on \(rating.whenVisited, style: .date)")
                    .font(.subheadline)
                    .padding(.bottom, 8)
                // z stack containing background rectangle and the individual ratings
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.thinMaterial)
                        .shadow(radius: 8, y: 5.0)
                    VStack {
                        HStack {
                            Text("Ratings")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }.padding(-3)
                        RatingProgress(symbol: "laptopcomputer" ,label: "Study Vibe", value: rating.studyVibe, outOf: 10)
                        RatingProgress(symbol: "cup.and.saucer.fill", label: "Food/Drink", value: rating.foodOrDrinkRating, outOf: 10)
                        RatingProgress(symbol: "person.2.fill", label: "Availability", value: rating.availability, outOf: 5)
                        RatingProgress(symbol: "waveform", label: "Noise Level", value: rating.noiseLevel, outOf: 2, alternateLabel: noiseLevelString)
                    }
                    .padding(16)
                }
                if (rating.comments != nil) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.thinMaterial)
                            .shadow(radius: 8, y: 5.0)
                        VStack {
                            HStack {
                                Text("Notes")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }.padding(-2)
                            Text(rating.comments!)
                        }
                            .padding(16)
                    }.padding(.top, 10)
                }
                
            }
            .padding([.leading, .trailing], 20)
        }
    }
}

struct RatingProgress : View {
    
    var symbol: String;
    var label: String;
    
    var value: Int;
    var outOf: Int;
    
    var alternateLabel: String?;
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: symbol)
                Text(label)
                    .fontWeight(.medium)
                Spacer()
                Text( alternateLabel != nil ? alternateLabel! : "\(value)/\(outOf)")
                    .fontWeight(.semibold)
            }.padding(.bottom, -2)
            ProgressView(value: Double(value)/Double(outOf))
        }
        .padding([.top, .bottom], 5)
    }
}

struct MapPreview : View {
    
    var name: String;
    var location: CLLocationCoordinate2D;
    
    var body: some View {
        Map(position: .constant(.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.002,
                    longitudeDelta: 0.002
                ))
        )), interactionModes: .zoom){
            // marker for the coffee shop
            Marker(
                name,
                coordinate: location
            )
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
        .padding(20)
        .shadow(radius: 8, y: 5.0)
    }
}

#Preview {
    RatingDetails(rating: Rating(name: "Philz Coffee", latitude: 33.789955, longitude: -117.853434, whenVisited: Date(), studyVibe: 9, foodOrDrinkRating: 9, noiseLevel: .normal, availability: 2, overallRating: 5.4, comments: "Really amazing place for a coffee! Good drinks, even better atmosphere, but not really ideal spots to actually study at."))
}

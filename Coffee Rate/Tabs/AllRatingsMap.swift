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
    @State private var navigationPath = NavigationPath();
    
    func getTintFromRating(overallRating: Double) -> Color {
        if (overallRating > 7.0) {
            return .green;
        }
        else if (overallRating < 3.5) {
            return .red;
        }
        return .yellow;
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
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
                ForEach (ratings) { rating in
                    if let location = rating.location {
                        Annotation (
                            rating.name,
                            coordinate: location,
                            anchor: .bottom
                        ) {
                            // content of the annotation
                            ZStack {
                                Circle()
                                    .fill(.thinMaterial)
                                    .frame(width: 60, height: 60)
                                Circle()
                                    .fill(getTintFromRating(overallRating: rating.overallRating).opacity(0.7))
                                    .frame(width: 50, height: 50)
                                Text("\(rating.overallRating.formatted())")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .onTapGesture {
                                navigationPath.append(rating);
                            }
                        }
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: "Add Rating") {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .navigationTitle("Your Ratings")
        }
        .navigationDestination(for: String.self) { _ in
            AddRating() // TODO: add path parameter to AddRating
        }
        .navigationDestination(for: Rating.self) { rating in
            RatingDetails(rating: rating)
        }
    }
}

#Preview {
    AllRatingsMap()
}

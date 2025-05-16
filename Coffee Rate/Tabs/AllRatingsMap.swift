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
    @Environment(\.colorScheme) var colorScheme;
    @Query var ratings: [Rating];
    @State private var navigationPath: NavigationPath = NavigationPath();
    
    func getTintFromRating(overallRating: Double) -> Color {
        if (overallRating > 7.0) {
            return .green;
        }
        else if (overallRating < 3.5) {
            return .red;
        }
        return .yellow.mix(with: .black, by: 0.05);
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
                                    .fill(.thickMaterial)
                                    .frame(width: 60, height: 60)
                                    .shadow(radius: 4, y: 4)
                                Circle()
                                    .fill(getTintFromRating(overallRating: rating.overallRating).opacity(0.8))
                                    .frame(width: 50, height: 50)
                                Text("\(rating.overallRating.formatted(.number.rounded(increment: 0.1)))")
                                    .font(.headline)
                                    .foregroundColor(colorScheme == .dark ? .black : .white)
                                    .shadow(radius: 1, y: 2)
                            }
                            .onTapGesture {
                                navigationPath.append(rating);
                            }
                        }
                    }
                }
                
            }
            // navbar path items
            .navigationDestination(for: String.self) { _ in
                // path to add a new rating
                AddRating(navigationPath: $navigationPath)
            }
            .navigationDestination(for: Rating.self) { rating in
                // path to get details for a rating
                RatingDetails(rating: rating, navigationPath: $navigationPath)
            }
            .navigationTitle("Your Ratings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: "Add Rating") {
                        Image(systemName: "plus.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    AllRatingsMap()
}

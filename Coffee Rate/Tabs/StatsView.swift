//
//  StatsView.swift
//  Coffee Rate
//
//  Created by Daniel Tsivkovski on 5/14/25.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    
    // get ratings
    @Environment(\.modelContext) var modelContext;
    @Query var ratings: [Rating];
    @State private var navigationPath: NavigationPath = NavigationPath();
    
    // average overall rating
    private var averageRating: Double {
        var sum = 0.0;
        
        for rating in ratings {
            sum += rating.overallRating;
        }
        
        return sum / Double(ratings.count);
    }
    
    // total count of ratings
    private var totalRatings: Int {
        ratings.count;
    }
    
    // highest rating for all ratings
    private var highestRating: Rating? {
        if ratings.count == 0 { return nil } // if no ratings
        
        var max = 0.0;
        var highestRating: Rating = ratings[0];
        
        for rating in ratings {
            if (rating.overallRating > max) {
                highestRating = rating;
                max = rating.overallRating;
            }
        }
        
        return highestRating;
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                // stats section
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.thinMaterial)
                            .shadow(radius: 8, y: 5.0)
                        VStack {
                            Text("Key Stats")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.bottom, 2)
                            if (totalRatings > 0) { // if there are ratings
                                HStack (spacing: 30) {
                                    StatItem(value: averageRating, label: "Average Rating", rounded: false)
                                    StatItem(value: Double(totalRatings), label: "Total Ratings", rounded: true)
                                }
                                
                            } else {
                                Text("Add your first rating to see your stats.")
                            }
                        }
                        .padding(16)
                    }
                }.padding()
                // highest rating
                if (totalRatings > 0) {
                    VStack {
                        TopRatingPreview(navigationPath: $navigationPath, rating: highestRating!)
                    }.padding()
                }
            }
            .navigationTitle("Your Stats")
            .navigationDestination(for: Rating.self) { rating in
                // path to get details for a rating
                RatingDetails(rating: rating, navigationPath: $navigationPath)
            }
        }
    }
}

struct StatItem: View {
    
    var value: Double;
    var label: String;
    var rounded: Bool;
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(.thinMaterial.shadow(.inner(color: .black.opacity(0.2),radius: 4, y: 5)))
            VStack {
                // labels for stat item
                Text(value.formatted(.number.rounded(increment: rounded ? 1 : 0.1)))
                    .font(.largeTitle)
                    .shadow(radius: 1, y: 2)
                Text(label)
                    .font(.subheadline)
                    .padding([.leading, .trailing])
            }
        }
        .frame(width: 140)
    }
}

struct TopRatingPreview: View {
    
    
    @Environment(\.colorScheme) var colorScheme;
    @Binding var navigationPath: NavigationPath;
    var rating: Rating;
    
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
                return Color(red: 170/256, green: 230/256, blue: 160/256)
            } else if (rating.overallRating < 3.5) {
                return Color(red: 255/256, green: 152/256, blue: 140/256)
            } else {
                return Color(red: 255/256, green: 227/256, blue: 135/256);
            }
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.thinMaterial)
                .shadow(radius: 8, y: 5.0)
            VStack {
                Text("Your #1 Rating")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 2)
                
                NavigationLink(value: rating) {
                    HStack {
                        ZStack {
                            Circle()
                                .foregroundStyle(circleBackgroundColor.shadow(.inner(color: .black.opacity(0.2), radius: 4, y: 5)))
                                .frame(height: 120)
                            Text("\(rating.overallRating.formatted(.number.rounded(increment: 0.1)))")
                                .font(.largeTitle)
                                .shadow(radius:1, y: 2)
                        }
                        Text("\(rating.name)")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                }.tint(.black)
            }
            .padding(16)
        }
    }
}

#Preview {
    StatsView()
}

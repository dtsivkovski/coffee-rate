//
//  Favorites.swift
//  Coffee Rate
//
//  Created by Daniel Tsivkovski on 4/29/25.
//  Reference used for Favorites functionality:
// - https://developer.apple.com/tutorials/swiftui/handling-user-input -
//  This reference was used to create a Favorites button to keep track of favorite Ratings and display them in a seperate Favoirtes List

import SwiftUI
import SwiftData

struct Favorites: View {
    @Environment(\.modelContext) var modelContext
    @Query var ratings: [Rating]
    @State private var navigationPath = NavigationPath()
    
    var filteredRatings: [Rating] {
            ratings.filter { rating in
               rating.isFavorited
            }
        }
    
    var body: some View {
        LogoHeader()
        
        NavigationSplitView {
            List(filteredRatings) { rating in
                NavigationLink {
                    RatingDetails(rating: rating, navigationPath: $navigationPath)
                } label: {
                    RatingListCell(rating: rating)
                }
            }
            .navigationTitle("Favorites")
        } detail: {
            Text("Select a Coffee Shop")
        }
    }
}

    #Preview {
        Favorites()
    }

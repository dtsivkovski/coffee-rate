//
//  Favorites.swift
//  Coffee Rate
//
//  Created by Daniel Tsivkovski on 4/29/25.
//

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

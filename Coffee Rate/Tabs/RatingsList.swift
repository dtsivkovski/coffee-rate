//
//  RatingsList.swift
//  Coffee Rate
//
//  Boilerplate created by Daniel Tsivkovski on 4/29/25.
//

import SwiftUI
import SwiftData

struct RatingsList: View {
    
    @Environment(\.modelContext) var modelContext;
    @Query var ratings: [Rating];
    @State var navigationPath = NavigationPath();
    
    // variable for search
    @State private var searchText = "";
    
    // deletion values
    @State private var itemsToDelete: IndexSet?
    @State private var showingDeleteAlert = false;
    
    var body: some View {
        VStack {
            NavigationStack (path: $navigationPath) {
                List {
                    ForEach(filteredRatings) { rating in
                        NavigationLink(value: rating) {
                            RatingListCell(rating: rating)
                        }
                    }
                    .onDelete(perform: confirmDelete)
                }
                .navigationDestination(for: Rating.self) {
                    rating in RatingDetails(rating: rating, navigationPath: $navigationPath)
                }
                .navigationDestination(for: String.self) {
                    _ in AddRating(navigationPath: $navigationPath)
                }
                .navigationTitle("Your Ratings")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(value: "Add Grocery") {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search Ratings")
                // alert for deletion
                .alert("Delete this rating", isPresented: $showingDeleteAlert, presenting: itemsToDelete) { indices in
                    Button("Delete", role: .destructive) {
                        // if deletion is followed through with then delete
                        deleteItems(at: indices)
                        itemsToDelete = nil
                        showingDeleteAlert = false
                    }
                    Button("Cancel", role: .cancel) {
                        // if cancelled reset vars
                        itemsToDelete = nil
                        showingDeleteAlert = false
                    }
                } message: { indices in
                    Text("Are you sure that you want to delete this rating? This cannot be undone.")
                }
            }
        }
    }
    
    var filteredRatings: [Rating] {
        if (searchText.isEmpty) {
            return ratings;
        } else {
            return ratings.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func confirmDelete(at offsets: IndexSet) {
        // set items to be deleted and show alert
        itemsToDelete = offsets;
        showingDeleteAlert = true;
    }
    
    func deleteItems(at offsets: IndexSet) {
        for offset in offsets {
            // get offsets from filtered ratings (in case deleting from searched list)
            guard offset < filteredRatings.count else { continue } // don't delete if outside of length of filtered items
            let ratingToDelete = filteredRatings[offset]
            modelContext.delete(ratingToDelete) // delete correct rating
        }
    }
}

struct RatingListCell: View {
    
    
    @Environment(\.colorScheme) var colorScheme;
    
    var rating: Rating;
    
    // get color for the circle rating value
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
        HStack {
            ZStack {
                Circle()
                    .foregroundStyle(circleBackgroundColor.shadow(.inner(color: .black.opacity(0.15),radius: 2, y: 3)))
                VStack {
                    // labels for stat item
                    Text(rating.overallRating.formatted(.number.rounded(increment: 0.1)))
                        .font(.title2)
                        .shadow(radius: 1, y: 2)
                }
            }
            .frame(width: 60)
            Text(rating.name)
        }
    }
}

#Preview {
    RatingsList()
}

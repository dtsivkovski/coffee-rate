//
//  RatingsList.swift
//  Coffee Rate
//
//  Boilerplate created by Daniel Tsivkovski on 4/29/25.
//

import SwiftUI
import SwiftData

struct RatingsList: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var ratings: [Rating]
    @State private var navigationPath = NavigationPath()
    
    // variable for search
    @State private var searchText: String = ""
    
    // deletion values
    @State private var itemsToDelete: IndexSet?
    @State private var showingDeleteAlert = false;
    
    var body: some View {
        Text("Logo Linking to All Ratings Map Here") //replace with header + logo
            .padding()

        NavigationSplitView {
            List {
                ForEach(filteredRatings) { rating in
                    NavigationLink(value: rating) {
                        RatingListCell(rating: rating)
                    }
                }
                .onDelete(perform: confirmDelete)
            }
            .navigationTitle("All Ratings")
            // rating navigation
            .navigationDestination(for: Rating.self) { rating in
                RatingDetails(rating: rating)
            }
            // add rating navigaiton
            .navigationDestination(for: String.self) { value in
                if value == "Add Rating" {
                    AddRating()
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: "Add Rating") {
                        Image(systemName: "plus.circle")
                            .foregroundColor(Color(red: 15/255, green: 102/255, blue: 23/255))
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
        } detail: {
            Text("Select a Coffee Shop")
        }
        
        
    }//end of body
    
    // filter all ratings by search text
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
    
    var rating: Rating
    
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
                return Color(red: 50/256, green: 160/256, blue: 50/256)
            } else if (rating.overallRating < 3.5) {
                return Color(red: 200/256, green: 50/256, blue: 50/256)
            } else {
                return .yellow.mix(with: .red, by: 0.3).mix(with: .black, by: 0.05);
            }
        }
    }
    
    var body: some View{
        HStack{
            Image(systemName: "cup.and.saucer.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundStyle(circleBackgroundColor)
                .shadow(color: .black.opacity(0.2), radius: 1, y: 2)
            .padding(.trailing, 10)
            VStack (alignment: .leading) {
                Text(rating.name)
                    .fontWeight(.medium)
                Text("\(rating.overallRating.formatted(.number.rounded(increment: 0.1))) / 10")
                    .foregroundStyle(.secondary)
            }
            Spacer()
            
            if rating.isFavorited {
                Image("favorites-coffee-icon-selected")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            }
        }
        
    }
}



//Reference to preview container for testing
enum PreviewData {
  static var container: ModelContainer!
}


#Preview {
    // Build an in-memory container for Rating
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Rating.self, configurations: config)
    // Hold the container so it doesn’t get deallocated
    PreviewData.container = container

    let ctx = container.mainContext
    let sample1 = Rating(
      name: "Contra Coffee & Tea",
      latitude: 33.788187,
      longitude: -117.851938,
      whenVisited: Date(),
      isFavorited: false,
      studyVibe: 8,
      foodOrDrinkRating: 9,
      noiseLevel: .normal,
      availability: 3,
      overallRating: 2.5,
      comments: "Cozy spot with great lattes!"
    )
    let sample2 = Rating(
      name: "Long Dog Coffee",
      latitude: 33.789180,
      longitude: -117.853625,
      whenVisited: Date().addingTimeInterval(-86400),
      isFavorited: true,
      studyVibe: 7,
      foodOrDrinkRating: 8,
      noiseLevel: .quiet,
      availability: 2,
      overallRating: 7.5,
      comments: nil
    )
    ctx.insert(sample1)
    ctx.insert(sample2)

    // Inject the full container into the preview
    return RatingsList()
      .modelContainer(container)
}


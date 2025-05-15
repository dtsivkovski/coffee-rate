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
    
    var body: some View {
        Text("Logo Linking to All Ratings Map Here") //replace with header + logo
            .padding()

        NavigationSplitView {
            List(ratings) { rating in
                NavigationLink {
                    RatingDetails(rating: rating, navigationPath: $navigationPath)
                } label: {
                    RatingListCell(rating: rating)
                }
            }
            .navigationTitle("All Ratings")
        } detail: {
            Text("Select a Coffee Shop")
        }
    
            .toolbar{
                Button(action: addShop) {
                    Image(systemName: "rectangle.stack.fill.badge.plus")
                        .foregroundColor(Color(red: 15/255, green: 102/255, blue: 23/255))
                }
                .buttonStyle(.bordered)
                .background(Color.white)
            }
        
        
    }//end of body
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(ratings[index])
        }
    }
    
    // will need to navigate this to the AddRating view
    func addShop(){
        let newShop = Rating(name: "Long Dog",latitude: 33.788187, longitude: -117.851938, whenVisited: Date(), isFavorited: false, studyVibe: 10, foodOrDrinkRating: 9, noiseLevel: .normal, availability: 0, overallRating: 8.712341234, comments: "Super cute inside!")
        modelContext.insert(newShop)
    }
    
}

struct RatingListCell: View {
    var rating: Rating
    
    var body: some View{
        HStack{
            Image(systemName: "cup.and.saucer.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding(.trailing, 10)
            Text(rating.name)
                .font(.title2)
                
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
      overallRating: 8.2,
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

